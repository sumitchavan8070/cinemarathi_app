
import 'package:flutter/material.dart';
import 'package:school_management/constants.dart';

class TimedRoute {
  final Route<dynamic> route;
  final DateTime startTime;
  DateTime? _endTime;

  TimedRoute({required this.route, required this.startTime});

  Duration get duration => (_endTime ?? DateTime.now()).difference(startTime);

  DateTime? get endTime => _endTime;

  set endTime(DateTime? value) {
    _endTime = value;
    if (value != null) {
      // coreRouteMonitorService(route, timeSpent: duration.inSeconds);
    }
  }
}

class CoreNavigationObserver extends NavigatorObserver with WidgetsBindingObserver {
  // Singleton instance
  DateTime? _backgroundTimestamp;

  static final CoreNavigationObserver _instance = CoreNavigationObserver._internal();
  factory CoreNavigationObserver() => _instance;
  CoreNavigationObserver._internal();

  final List<Route<dynamic>> _routeStack = [];
  final List<TimedRoute> _routeStackWithTime = [];

  String get currentRouteName {
    return _routeStackWithTime.isNotEmpty
        ? _routeStackWithTime.last.route.settings.name ?? 'UnnamedRoute'
        : 'NoRoute';
  }

  Object? get currentRouteArgs {
    return _routeStackWithTime.isNotEmpty
        ? _routeStackWithTime.last.route.settings.arguments
        : null;
  }

  List<String> get routeNames {
    return _routeStack.map((route) => route.settings.name ?? 'UnnamedRoute').toList();
  }

  List<Route<dynamic>> get routeStack => List.unmodifiable(_routeStack);

  void _printRouteStack(String action) {
    final buffer = StringBuffer();
    buffer.writeln('--- [$action]');
    buffer.writeln('Top: $currentRouteName');
    buffer.writeln('Stack:');
    for (final timedRoute in _routeStackWithTime) {
      final name = timedRoute.route.settings.name ?? 'UnnamedRoute';
      final duration = timedRoute.duration;
      buffer.writeln(
        '→ $name | Time spent: ${duration.inSeconds}s',
      );
    }
    logger.d(buffer.toString());
  }

  void clearStack() {
    _routeStack.clear();
    _printRouteStack('CLEAR');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);

    // Update end time of the previous route (if exists)
    if (_routeStackWithTime.isNotEmpty) {
      _routeStackWithTime.last.endTime = DateTime.now();
    }

    // Add new timed route
    _routeStackWithTime.add(TimedRoute(route: route, startTime: DateTime.now()));

    _printRouteStack('PUSH');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _routeStack.indexOf(oldRoute);
      if (index != -1) {
        _routeStack[index] = newRoute!;
      } else if (newRoute != null) {
        _routeStack.add(newRoute);
      }

      final timedIndex = _routeStackWithTime.indexWhere((tr) => tr.route == oldRoute);
      if (timedIndex != -1) {
        _routeStackWithTime[timedIndex].endTime = DateTime.now();
        _routeStackWithTime.insert(
          timedIndex + 1,
          TimedRoute(route: newRoute!, startTime: DateTime.now()),
        );
      } else if (newRoute != null) {
        _routeStackWithTime.add(
          TimedRoute(route: newRoute, startTime: DateTime.now()),
        );
      }
    } else if (newRoute != null) {
      _routeStack.add(newRoute);
      if (_routeStackWithTime.isNotEmpty) {
        _routeStackWithTime.last.endTime = DateTime.now();
      }
      _routeStackWithTime.add(
        TimedRoute(route: newRoute, startTime: DateTime.now()),
      );
    }

    _printRouteStack('REPLACE');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _printRouteStack('POP');
  }

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void notifyTabChange({required String screen, required String tab}) {
    final virtualRouteName = '$screen-$tab';

    final fakeRoute = _VirtualRoute(virtualRouteName);

    if (_routeStackWithTime.isNotEmpty) {
      _routeStackWithTime.last.endTime = DateTime.now();
    }

    _routeStackWithTime.add(
      TimedRoute(route: fakeRoute, startTime: DateTime.now()),
    );

    _printRouteStack('TAB CHANGE');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_routeStackWithTime.isEmpty) {
      logger.d('[Lifecycle] State changed to $state, but route stack is empty.');
      return;
    }

    logger.d('[Lifecycle] App state changed: $state');

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _backgroundTimestamp = DateTime.now();
      logger.d('[Lifecycle] App moved to background at $_backgroundTimestamp');
    } else if (state == AppLifecycleState.resumed && _backgroundTimestamp != null) {
      final now = DateTime.now();
      final backgroundDuration = now.difference(_backgroundTimestamp!);

      final currentTimedRoute = _routeStackWithTime.last;
      final updatedStartTime = currentTimedRoute.startTime.add(backgroundDuration);

      logger.d('[Lifecycle] App resumed at $now\n'
          '→ Background duration: ${backgroundDuration.inSeconds}s\n'
          '→ Adjusting route start time: ${currentTimedRoute.route.settings.name ?? 'UnnamedRoute'}\n'
          '→ Original start time: ${currentTimedRoute.startTime}\n'
          '→ Updated start time: $updatedStartTime');

      // Replace the current TimedRoute with adjusted start time
      _routeStackWithTime[_routeStackWithTime.length - 1] = TimedRoute(
        route: currentTimedRoute.route,
        startTime: updatedStartTime,
      );

      _backgroundTimestamp = null;
    }
  }
}

class _VirtualRoute extends Route<dynamic> {
  final String name;

  _VirtualRoute(this.name);

  @override
  RouteSettings get settings => RouteSettings(name: name);
}
