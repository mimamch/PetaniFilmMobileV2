import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class CustomLoadingDialog {
  static void showCustomLoadingDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      transitionAnimationDuration: const Duration(
        milliseconds: 100,
      ),
      dialogType: DialogType.noHeader,
      padding: const EdgeInsets.all(30),
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      body: Column(
        children: const [
          CircularProgressIndicator(
            color: Constants.primaryblueColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text('Mohon Menunggu...')
        ],
      ),
    ).show();
  }

  static void hideCustomLoadingDialog(BuildContext context) {
    AwesomeDialog(context: context).dismiss();
    // Navigator.of(context).pop();
  }
}
