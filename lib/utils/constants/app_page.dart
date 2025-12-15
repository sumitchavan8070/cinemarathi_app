import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_management/utils/constants/app_bar.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/blur_bottom_navigation_bar_widget.dart';
import 'package:school_management/utils/constants/fancy_app_bar.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/navigation/navigator.dart';

import '../../constants.dart';

class AppPageView extends StatefulWidget {
  final bool extendBody;
  final bool? showBottomNavigation;
  final bool showDrawer;

  final bool topSafeArea;

  final Widget body;
  final Widget? floatingActionWidget;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatLocation;
  final GlobalKey<ScaffoldState>? scaffoldKey; // <-- Rename this (recommended)

  const AppPageView({
    super.key,
    required this.body,
    this.extendBody = true,
    this.topSafeArea = true,
    this.showBottomNavigation = false,
    this.floatingActionWidget,
    this.floatLocation,
    this.showDrawer = false,
    this.scaffoldKey, this.bottomNavigationBar,
  });

  @override
  State<AppPageView> createState() => _AppPageViewState();
}

class _AppPageViewState extends State<AppPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,

      // <-- Passing nullable key safely
      extendBody: widget.extendBody,
      backgroundColor: Colors.white,

      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(border: Border.all(color: Color(0xFFC7BAF3), width: 4)),
              child: Column(
                children: [
                  // Top 30% Gradient Area
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC7BAF3), Colors.white],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(top: widget.topSafeArea, child: widget.body),
        ],
      ),
      floatingActionButtonLocation:
      widget.floatLocation ?? FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      widget.floatingActionWidget ?? _buildBottomNavigation(widget.showBottomNavigation),
      bottomNavigationBar: widget.bottomNavigationBar ?? null,
    );
  }

  _buildBottomNavigation(value) {
    if (!value) return SizedBox.shrink();
    return BlurBottomNavigationBar(
      selectedIndex: 1,
      onItemTapped: (p0, p1) {
        logger.e("$p0 ||  $p1 ");
        if (p1 == "/profile") {
          MyNavigator.pushNamed(GoPaths.profile);
        }
      },
    );
  }

  _buildDrawer() {
    return Drawer(
      width: MediaQuery
          .of(context)
          .size
          .width,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: TapRegion(
        onTapInside: (event) {
          logger.e("onTapInside");

          // widget.scaffoldKey?.currentState?.closeDrawer();
        },
        onTapOutside: (event) {
          logger.e("onTapOutside");
          widget.scaffoldKey?.currentState?.closeDrawer();
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            margin: EdgeInsets.only(
              left: 12,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.24,
              top: 24,
              bottom: 10,
            ),
            decoration: AppBoxDecoration.getBoxDecoration(showShadow: false, borderRadius: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: AppBoxDecoration.getBorderBoxDecoration(
                    showShadow: true,
                    color: const Color(0xFFF4F7FE).withOpacity(0.40),
                    borderRadius: 100,
                    borderColor: Colors.transparent,
                  ),
                  child: Image.asset(AssetPaths.appLogoPNG, fit: BoxFit.fill),
                ),
                SizedBox(height: 20),

                ListTile(
                  leading: Image.asset(AssetPaths.homeGIF, fit: BoxFit.fill, width: 30, height: 30),
                  title: Text("Home", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Image.asset(AssetPaths.userGIF, fit: BoxFit.fill, width: 30, height: 30),
                  title: Text("Profile", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    Navigator.pop(context);

                    MyNavigator.pushNamed(GoPaths.profile);
                  },
                ),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.campFireGIF,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),

                  title: Text("Manage Leave", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    Navigator.pop(context);

                    MyNavigator.pushNamed(GoPaths.leaveManagement);
                  },
                ),

                ListTile(
                  leading: Image.asset(
                    AssetPaths.padLockGIF,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text("Change Password", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    // TODO: Implement logout
                    widget.scaffoldKey?.currentState?.closeDrawer();
                    MyNavigator.pushNamed(GoPaths.changePassword);
                  },
                ),

                ListTile(
                  leading: Image.asset(AssetPaths.busGIF, fit: BoxFit.fill, width: 30, height: 30),
                  title: Text("Transport", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    // TODO: Implement logout
                    widget.scaffoldKey?.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    AssetPaths.noticePNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text("Notices", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    // TODO: Implement logout
                    widget.scaffoldKey?.currentState?.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    AssetPaths.noticePNG,
                    fit: BoxFit.fill,
                    width: 30,
                    height: 30,
                  ),
                  title: Text("Support", style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium),
                  onTap: () {
                    // TODO: Implement logout
                    widget.scaffoldKey?.currentState?.closeDrawer();
                    MyNavigator.pushNamed(GoPaths.support);
                  },
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.whiteSmoke,
                      backgroundColor: AppColors.desertStorm,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      // corePrefs.erase();
                      // _closeDrawer();

                      // final route =
                      // context.goNamed("/login", extra: {"number": ""});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetPaths.logoutSVG),
                        const SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
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
}
