import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_management/utils/common_model.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';
import 'package:school_management/utils/constants/blurry_container.dart';
import 'package:url_launcher/url_launcher.dart';

class BlurBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int, String) onItemTapped;

  BlurBottomNavigationBar({super.key, required this.selectedIndex, required this.onItemTapped});

  final navBarData = [
    KeyValuePair(key: AssetPaths.dashboardSVG, value: "/dashboard"),
    KeyValuePair(key: AssetPaths.heartSVG, value: '/heart'),
    KeyValuePair(key: AssetPaths.heartSVG, value: ""),
    KeyValuePair(key: AssetPaths.contactSVG, value: "contact"),
    KeyValuePair(key: AssetPaths.profileSVG, value: "/profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildBlurNavBar();
  }

  _buildBlurNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: AppBoxDecoration.getBorderBoxDecoration(
              showShadow: false,
              color: AppColors.white.withOpacity(0.01),
              borderRadius: 16,
              borderColor: AppColors.gunMetal.withOpacity(0.10),
            ),
            child: BlurredContainer(
              height: 60,
              child: Container(
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: AppBoxDecoration.getBoxDecoration(
                  showShadow: false,
                  color: AppColors.white.withOpacity(0.01),
                  borderRadius: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(navBarData.length, (index) {
                    final item = navBarData[index];

                    return GestureDetector(
                      onTap: () async {
                        // if (item.value == "contact") {
                        //   final Uri phoneUri = Uri(scheme: 'tel', path: "+919773388670");
                        //
                        //   if (await canLaunchUrl(phoneUri)) {
                        //     await launchUrl(phoneUri);
                        //   } else {
                        //     debugPrint("Could not launch phone dialer");
                        //   }
                        if (item.value == "contact") {
                          final Uri phoneUri = Uri(scheme: 'tel', path: "+918862071189");

                          await launchUrl(
                            phoneUri,
                            mode: LaunchMode.externalApplication, // 👈 REQUIRED for Android 11+
                          );
                          return;
                        }
                        // alice.smith@example.com

                        onItemTapped(index, item.value);
                      },
                      child: Container(
                        height: 60,
                        decoration: index == 0
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(0.6),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              )
                            : null,
                        child: SvgPicture.asset(item.key, height: 24, width: 24),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: () {
                onItemTapped(3, AssetPaths.whiteSearchSVG);
              },

              child: Container(
                height: 62,
                width: 62,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Blue background
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.6),
                      spreadRadius: 0,
                      blurRadius: 24,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: SvgPicture.asset(AssetPaths.whiteSearchSVG),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//alice.smith@example.com