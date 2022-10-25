import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

void showCustomSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Constants.whiteColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: Constants.primaryblueColor,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
