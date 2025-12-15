import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';

class FancyTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final bool showLogo;
  final bool backButton;
  final bool showActions;
  final String? title;
  final Color? backgroundColor;

  const FancyTopBar({
    super.key,
    this.onBack,
    this.onAction,
    this.showLogo = true,
    this.title,
    this.backgroundColor,
    this.backButton = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 60,

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor ?? Color(0xFFF4F7FE).withOpacity(0.50),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // LEFT ICON (BACK)
                GestureDetector(
                  onTap:
                      onBack ??
                      () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: AppBoxDecoration.getBoxDecoration(
                      color: Colors.white,
                      borderRadius: 12,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        backButton
                            ? AssetPaths.backSVG
                            : AssetPaths.menuSVG, // Replace with action icon
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // TITLE OR LOGO
                showLogo
                    ? SvgPicture.asset(AssetPaths.snehVidyaSVG, height: 28)
                    : Text(
                        title ?? "",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                const Spacer(),

                // RIGHT ACTION BUTTON
                if (showActions)
                  GestureDetector(
                    onTap: onAction ?? () => context.pushNamed('/userAttendanceView'),
                    child: Container(
                      height: 40,

                      width: 40,
                      decoration: AppBoxDecoration.getBoxDecoration(
                        color: Colors.white,
                        borderRadius: 12,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AssetPaths.notificationSVG, // Replace with action icon
                          height: 18,
                          width: 18,
                        ),
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

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
