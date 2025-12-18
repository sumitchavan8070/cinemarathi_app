import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/authentication_module/view/cine_marathi_landing_view.dart';
import 'package:school_management/authentication_module/view/edit_profile_view.dart';
import 'package:school_management/authentication_module/view/prp_setup.dart';
import 'package:school_management/authentication_module/view/sign_in_up_view.dart';
import 'package:school_management/authentication_module/view/support_view.dart';
import 'package:school_management/authentication_module/view/change_password_view.dart';
import 'package:school_management/authentication_module/view/terms_and_conditions_view.dart';
import 'package:school_management/authentication_module/view/privacy_policy_view.dart';
import 'package:school_management/authentication_module/view/casting_calls_screen.dart';
import 'package:school_management/authentication_module/view/settings_view.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/payments/razorpay.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/services/core_navigation_observer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter goRouterConfig = GoRouter(
  initialLocation: GoPaths.splash,
  navigatorKey: rootNavigatorKey,

  redirect: (context, state) {
    final bool isLoggedIn = corePrefs.read(CorePrepPaths.isLoggedIn) == true;

    final bool goingToOnboarding = state.matchedLocation == GoPaths.splash;
    final bool goingToSplash = state.matchedLocation == GoPaths.splash;

    // User NOT logged in → go to onboarding
    // if (!isLoggedIn) {
    //   if (!goingToOnboarding) return GoPaths.onBoarding;
    //   return null;
    // }
    // User logged in → block onboarding/splash
    if (isLoggedIn && (goingToOnboarding || goingToSplash)) {
      return GoPaths.landingPage;
    }

    return null;
  },

  observers: [CoreNavigationObserver()],

  routes: [
    // Splash
    // GoRoute(
    //   parentNavigatorKey: rootNavigatorKey,
    //   path: GoPaths.splash,
    //   name: GoPaths.splash,
    //   builder: (context, state) {
    //     return const OnbodingScreen(); // if you want a real splash, change this
    //   },
    // ),

    // Auth Screen
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.splash,
      name: GoPaths.splash,
      builder: (context, state) {
        return SignInUpView(); // if you want a real splash, change this
      },
    ),

    // Auth Screen
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.landingPage,
      name: GoPaths.landingPage,
      builder: (context, state) {
        return const LandingPage(); // if you want a real splash, change this
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.editProfile,
      name: GoPaths.editProfile,
      builder: (context, state) {
        return const EditProfileView(); // if you want a real splash, change this
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.support,
      name: GoPaths.support,
      builder: (context, state) {
        return const SupportView();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.changePassword,
      name: GoPaths.changePassword,
      builder: (context, state) {
        return const ChangePasswordView();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.termsAndConditions,
      name: GoPaths.termsAndConditions,
      builder: (context, state) {
        return const TermsAndConditionsView();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.privacyPolicy,
      name: GoPaths.privacyPolicy,
      builder: (context, state) {
        return const PrivacyPolicyView();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.castingCalls,
      name: GoPaths.castingCalls,
      builder: (context, state) {
        return CastingCallsScreen(
          onTap: () {
            // Navigate back
            Navigator.of(context).pop();
          },
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.settings,
      name: GoPaths.settings,
      builder: (context, state) {
        return const SettingsView();
      },
    ),

    // Auth Screen
    // GoRoute(
    //   parentNavigatorKey: rootNavigatorKey,
    //   path: GoPaths.onboarding,
    //   name: GoPaths.onboarding,
    //   builder: (context, state) {
    //     return const LandingPage(); // if you want a real splash, change this
    //   },
    // ),

    // Auth Screen
    // GoRoute(
    //   parentNavigatorKey: rootNavigatorKey,
    //   path: GoPaths.letsFameHomeScreen,
    //   name: GoPaths.letsFameHomeScreen,
    //   builder: (context, state) {
    //     return const HomeView(); // if you want a real splash, change this
    //   },
    // ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.profileSetUp,
      name: GoPaths.profileSetUp,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final email = extras["email"] as String;
        final fullName = extras["fullName"] as String;
        final password = extras["password"] as String;

        return ProfileSetup(
          email: email,
          fullName: fullName,
          password: password,
        ); // if you want a real splash, change this
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.razorPayPayment,
      name: GoPaths.razorPayPayment,
      builder: (context, state) {
        return RazorPayPaymentScreen();
      },
    ),
  ],
);
