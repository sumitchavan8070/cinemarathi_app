import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/asset_paths.dart';

class GraddingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? openDrawer;
  final Function()? backOnTap;
  final bool backButton;
  final bool showActions;
  final String? title;
  final bool showLeading;
  final bool centerTitle;
  final Color? bgColor;
  final bool isBlur;

  const GraddingAppBar({
    super.key,
    this.openDrawer,
    this.backOnTap,
    this.backButton = false,
    this.title,
    this.showActions = false,
    this.showLeading = true,
    this.centerTitle = true,
    this.bgColor,
    this.isBlur = false,
  });

  Widget getActionIcon(String svgAsset) {
    return Container(
      height: 40,
      width: 40,
      decoration: AppBoxDecoration.getBoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.20),
        // color: Color(0xFFF4F7FE),
        borderRadius: 16,
      ),
      child: Center(child: SvgPicture.asset(svgAsset, fit: BoxFit.fill, height: 42, width: 42)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildActions() {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              context.pushNamed("/accommodation-clientWishList");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 12),
              child: SvgPicture.asset(
                AssetPaths.backSVG,
                fit: BoxFit.fill,
                height: 42,
                width: 42,
              ),
            ),
          ),
        );



    }

    Widget buildTitle() {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SvgPicture.asset(AssetPaths.snehVidyaSVG),
        );


      // if (CoreAppInfo().coreAppName == CoreAppInfo.ptePrep) {
      //   return Padding(
      //     padding: const EdgeInsets.only(bottom: 12),
      //     child: SvgPicture.asset(CoreAssetPath.graddingPTELogoSVG),
      //   );
      // }
      //
      // if (title == null) {
      //   return Padding(
      //     padding: const EdgeInsets.only(bottom: 12),
      //     child: SvgPicture.asset(CoreAssetPath.graddingLogoSVG),
      //   );
      // }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title!, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20)),
      );
    }

    Widget appBar = AppBar(
      titleSpacing: 0,

      automaticallyImplyLeading: false,
      title: buildTitle(),
      centerTitle: centerTitle || !backButton,
      leadingWidth: backButton ? null : 62,
      backgroundColor: bgColor ?? Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: showLeading
          ? backButton
                ? GestureDetector(
                    onTap:
                        backOnTap ??
                        () {
                          if (context.canPop()) context.pop();
                        },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: SvgPicture.asset(AssetPaths.backSVG),
                    ),
                  )
                : GestureDetector(
                    onTap: openDrawer,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(AssetPaths.backSVG),
                    ),
                  )
          : null,
      actions: showActions ? [buildActions()] : null,
    );

    if (isBlur) _buildBlur(context);

    return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (isBlur ? 60 : 0));

  _buildBlur(BuildContext context) {

    // return Text("data");
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 26, 8, 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteFrost.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.only(top: 8),
            height: kToolbarHeight,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(AssetPaths.backSVG, fit: BoxFit.fill),
                  ),
                  SvgPicture.asset(AssetPaths.snehVidyaSVG),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed("/profile");
                    },
                    child: SvgPicture.asset(AssetPaths.backSVG),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
