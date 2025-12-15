import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';


/// Provides methods to manage dynamic links.
final class DynamicLinkHandler {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].

  // Future<void> initialize() async {
  //   // * Listens to the dynamic links and manages navigation.
  //   _appLinks.uriLinkStream.listen(_handleLinkData).onError((error) {
  //     logger.d('Dynamic Link Handler');
  //   });
  //   _checkInitialLink();
  // }
  // TODO
  Future<void> initialize(BuildContext context) async {
    // Delay execution to ensure context has GoRouter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appLinks.uriLinkStream.listen(
        (uri) => _handleLinkData(uri, context),
        onError: (error) {
          logger.d('Dynamic Link Handler error: $error');
        },
      );
    });

    await _checkInitialLink(context);
  }

  /// Handle navigation if initial link is found on app start.
  // Future<void> _checkInitialLink() async {
  //   final initialLink = await _appLinks.getInitialLink();
  //   if (initialLink != null) {
  //     _handleLinkData(initialLink);
  //   }
  // }

  // TODO
  Future<void> _checkInitialLink(BuildContext context) async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLinkData(initialLink, context);
      });
    }
  }

  /// Handles the link navigation Dynamic Links.
  // void _handleLinkData(Uri data) {
  //   final route = data.pathSegments[1]; // ["profile", "sumit", "settings"]
  //
  //   final queryParams = data.queryParameters;
  //
  //   logger.d('Dynamic Link Handler route $route');
  //   logger.d('Dynamic Link queryParams $queryParams');
  //   logger.d('Dynamic Link isLoggedIn $isLoggedIn');
  //
  //
  //   if (isLoggedIn == false) return;
  //
  //   if (route == "playebookaudio") {
  //     final audioName = queryParams["audio_name"];
  //     logger.d('Dynamic audioName $audioName');
  //     const audioUrl =
  //         "https://soundcloud.com/beatlabaudio/stonebank-hard-essentials-vol-1-serum-2-presets?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing";
  //
  //
  //
  //     final tempAudiomap = {
  //       "audioUrl": audioUrl,
  //       "audioEbookName": "beatlabaudio",
  //     };
  //
  //     debugPrint("\n----------- $audioName --------\n");
  //     if (audioName == "beatlabaudio") {
  //       MyNavigator.pushNamed("/$route", extra: tempAudiomap);
  //       return;
  //     }
  //     return;
  //   }
  //
  //   MyNavigator.pushNamed("/$route", extra: queryParams);
  //
  //   // if(data.path == "/freedom-sip"){
  //   //   CoreNavigator.pushNamed(CoreRoutePaths.freedomSIPFeature);
  //   // }
  //   // if (queryParams.isNotEmpty) {
  //   //   // Perform navigation as needed.
  //   //   // Get required data by [queryParams]
  //   // }
  // }

  void _handleLinkData(Uri data, BuildContext context) {
    final route = data.pathSegments[1];
    final queryParams = data.queryParameters;
    bool isLoggedIn = corePrefs.read(CorePrepPaths.isLoggedIn) == true;

    logger.d('Dynamic Link Handler route $route');
    logger.d('Dynamic Link queryParams $queryParams');
    logger.d('Dynamic Link isLoggedIn $isLoggedIn');

    if (!isLoggedIn) return;

    if (route == "playebookaudio") {
      final audioName = queryParams["audio_name"];
      logger.d('Dynamic audioName $audioName');

      const audioUrl =
          "https://soundcloud.com/beatlabaudio/stonebank-hard-essentials-vol-1-serum-2-presets?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing";
      final tempAudiomap = {"audioUrl": audioUrl, "audioEbookName": "beatlabaudio"};

      debugPrint("\n----------- $audioName --------\n");

      if (audioName == "beatlabaudio") {
        context.pushNamed("/$route", extra: tempAudiomap);
        return;
      }
      return;
    }

    context.pushNamed("/$route", extra: queryParams);
  }

  /// Provides the short url for your dynamic link.
  Future<String> createProductLink({required int id, required String title}) async {
    // Call Rest API if link needs to be generated from backend.
    return 'https://example.com/products?id=$id&title=$title';
  }
}
