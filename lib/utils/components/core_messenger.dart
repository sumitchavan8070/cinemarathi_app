import 'package:flutter/material.dart';
import 'package:school_management/utils/constants/app_colors.dart';
import 'package:school_management/utils/constants/init_app.dart';


enum CoreScaffoldMessengerType {
  success,
  error,
  warning,
  information,
}

coreMessenger(
  String content, {
  int duration = 4,
  CoreScaffoldMessengerType messageType = CoreScaffoldMessengerType.information,
}) {
  Color backgroundColor = AppColors.whiteFrost;
  Color mainColor = AppColors.primaryColor;
  IconData stateIcon = Icons.info_outline;

  switch (messageType) {
    case CoreScaffoldMessengerType.success:
      backgroundColor = AppColors.hintOfGreen;
      mainColor = AppColors.shareGreen;
      stateIcon = Icons.check;
      break;

    case CoreScaffoldMessengerType.error:
      mainColor = AppColors.cadmiumRed;
      backgroundColor = AppColors.bgRed;
      stateIcon = Icons.cancel_outlined;
      break;

    case CoreScaffoldMessengerType.warning:
      backgroundColor = AppColors.earlyDawn;
      mainColor = AppColors.fuelYellow;
      stateIcon = Icons.warning_amber;
      break;

    case CoreScaffoldMessengerType.information:
      backgroundColor = AppColors.whiteFrost;
      mainColor = AppColors.primaryColor;
      stateIcon = Icons.info_outline;
      break;
  }

  globalScaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: mainColor, width: 0.4),
      ),
      content: Row(
        children: [
          Icon(stateIcon, color: mainColor),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              content,
              style: TextStyle(fontSize: 14, color: mainColor),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
  return;
}
