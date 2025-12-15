import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_management/authentication_module/controller/client_dashboard_controller.dart';
import 'package:school_management/authentication_module/view/cine_profile.dart';
import 'package:school_management/authentication_module/view/discover_screen.dart';
import 'package:school_management/authentication_module/view/home_view.dart';
import 'package:school_management/authentication_module/view/jobs_screen.dart';
import 'package:school_management/authentication_module/view/talent_public_profile.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

final _getDashboardController = Get.put(ClientDashboardController());

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController();

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();

    _getDashboardController.getClientDashboardDetails();

    screens = [
      HomeView(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      DiscoverTalentsScreen(),
      TalentPublicProfileScreen(),
      // NetworkScreen(),
      // NotificationsScreen(),
      DiscoverJobsScreen(
        onTap: () {
          onNavTap(0);
        },
      ),

      ProfileScreen(
        onTap: () {
          onNavTap(0);
        },
      ),
    ];
  }

  void onNavTap(int index) {
    setState(() => selectedIndex = index);
    _pageController.jumpToPage(
      index,
      // duration: const Duration(milliseconds: 300),
      // curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D0B1A),

      drawer: _buildDrawer(),

      // ------------------------------------------------------------
      // PAGE VIEW
      // ------------------------------------------------------------
      body: PageView(
        controller: _pageController,
        allowImplicitScrolling: false,

        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => selectedIndex = index);
        },
        children: screens,
      ),

      // ------------------------------------------------------------
      // BOTTOM NAVIGATION BAR
      // ------------------------------------------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(icon: Icons.home, label: "Home", index: 0),
            _navItem(icon: Icons.explore, label: "Explore", index: 1),
            _navItem(icon: Icons.chat_bubble_outline, label: "Chat", index: 2),
            _navItem(icon: Icons.work_outline, label: "Jobs", index: 3),
            _navItem(icon: Icons.person_outline, label: "Profile", index: 4),
          ],
        ),
      ),
    );
  }

  _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: TapRegion(
        onTapInside: (event) {
          logger.e("onTapInside");
        },
        onTapOutside: (event) {
          logger.e("onTapOutside");
          _scaffoldKey.currentState?.closeDrawer();
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            margin: EdgeInsets.only(

              left: 12,
              right: MediaQuery.of(context).size.width * 0.24,
              top: 24,
              bottom: 10,
            ),
            decoration: AppBoxDecoration.getBoxDecoration(
              showShadow: false,
              borderRadius: 16,
              color: Colors.white.withOpacity(0.08),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                SizedBox(height: 40),

                Row(
                  children: [
                    SizedBox(width: 10),

                    Container(
                      width: 50,
                      height: 50,
                      // padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [Colors.pink, Colors.purple]),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://avatars.githubusercontent.com/u/111274627?v=4",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CineMarathi",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Where Talent Meets Opportunity",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.housePNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    "Home",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.boyProfilePNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    MyNavigator.pushNamed(GoPaths.profile);
                  },
                ),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.padLockPNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    // TODO: Implement logout

                    _scaffoldKey.currentState?.closeDrawer();
                    MyNavigator.pushNamed(GoPaths.changePassword);
                  },
                ),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.noticePNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    "Support",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    // TODO: Implement logout
                    _scaffoldKey.currentState?.closeDrawer();
                    MyNavigator.pushNamed(GoPaths.support);
                  },
                ),
                Spacer(),

                _getDashboardController.obx((state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GlassPlanCard(
                      name: state?.plan?.name,
                      price: state?.plan?.price,
                      durationDays: state?.plan?.durationDays,
                      features: state?.plan?.features,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.whiteSmoke,
                      backgroundColor: AppColors.desertStorm,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      corePrefs.erase();
                      MyNavigator.popUntilAndPushNamed(GoPaths.splash);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetPaths.logoutSVG),
                        const SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: 0.15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAV ITEM BUILDER
  // ------------------------------------------------------------
  Widget _navItem({required IconData icon, required String label, required int index}) {
    bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () => onNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.purpleAccent : Colors.grey, size: active ? 28 : 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.purpleAccent : Colors.grey,
              fontSize: active ? 13 : 12,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:ui';
// import 'package:flutter/material.dart';

class GlassPlanCard extends StatelessWidget {
  final String? name;
  final String? price;
  final dynamic durationDays;
  final String? features;

  const GlassPlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PLAN NAME
              Text(
                name ?? "-",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              // PRICE + DURATION
              Text(
                "₹${price ?? '--'} • ${durationDays ?? '--'} days",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              // FEATURES
              Text(
                features ?? "-",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade300, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
