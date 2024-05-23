import 'package:flutter/material.dart';
import 'package:social_x/core/utils/constants/colors.dart';

class TSnackBar {
  static void showSuccessSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: TColors.lightPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static void showErrorSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: TColors.lightPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
