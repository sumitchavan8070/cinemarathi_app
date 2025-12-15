import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/smooth_rectangular_border.dart';

import 'app_colors.dart';

class AppBoxDecoration {

  static BoxDecoration getBoxDecoration({
    double borderRadius = 10,
    Color color = Colors.white,
    double spreadRadius = 0,
    double blurRadius = 20,
    bool showShadow = true,
    Color shadowColor = Colors.black,
    double shadowOpacity = 0.06,
    double offsetX = 0,
    double offsetY = 4,
    Gradient? gradient, // Add nullable gradient parameter

  }) {
    return BoxDecoration(
      borderRadius: SmoothBorderRadius(
        cornerRadius: borderRadius,
        cornerSmoothing: 1.0,
      ),
      color: color,
      gradient: gradient,

      boxShadow: [
        if (showShadow)
          BoxShadow(
            spreadRadius: spreadRadius,
            blurRadius: blurRadius,
            color: shadowColor.withOpacity(shadowOpacity),
            offset: Offset(offsetX, offsetY),
          ),
      ],
    );
  }

  static BoxDecoration getBorderBoxDecoration({
    double borderRadius = 16,
    Color color = Colors.white,
    double borderWidth = 1,
    Color borderColor = AppColors.frenchGrey,
    double spreadRadius = 0,
    double blurRadius = 12,
    bool showShadow = true,
    Color shadowColor = AppColors.black04,
    double offsetX = 0,
    double offsetY = 4,
  }) {
    return BoxDecoration(
      borderRadius: SmoothBorderRadius(
        cornerRadius: borderRadius,
        cornerSmoothing: 1.0,
      ),
      color: color,
      border: Border.all(
        width: borderWidth,
        color: borderColor,
      ),
      boxShadow: [
        if (showShadow)
          BoxShadow(
            spreadRadius: spreadRadius,
            blurRadius: blurRadius,
            color: shadowColor,
            offset: Offset(offsetX, offsetY),
          ),
      ],
    );
  }
}


class CoreBoxDecoration {
  static BoxDecoration getBoxDecoration({
    double borderRadius = 20,
    Color color = Colors.white,
    bool removeShadow = false,
    bool addBorder = false,
    Border? border,
    Gradient? gradient,
    BoxShape shape = BoxShape.rectangle,
    List<BoxShadow> boxShadow = const [
      BoxShadow(offset: Offset(0, 6), blurRadius: 16, color: AppColors.blackEel20)
    ],
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      color: color,
      shape: shape,
      border: addBorder == true
          ? border ??
          Border.all(
            width: 1,
            color: AppColors.primaryColor,
          )
          : null,
      boxShadow: removeShadow == false ? boxShadow : null,
    );
  }

  static BoxDecoration getPortfolioBoxDecoration({
    double borderRadius = 16,
    Color color = Colors.white,
    double borderWidth = 1,
    Color borderColor = AppColors.silverChalice,
    double spreadRadius = 0,
    double blurRadius = 12,
    bool showShadow = true,
    Color shadowColor = AppColors.black04,
    double offsetX = 0,
    double offsetY = 4,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
      border: Border.all(
        width: borderWidth,
        color: borderColor,
      ),
      boxShadow: [
        if (showShadow)
          BoxShadow(
            spreadRadius: spreadRadius,
            blurRadius: blurRadius,
            color: shadowColor,
            offset: Offset(offsetX, offsetY),
          ),
      ],
    );
  }

}
