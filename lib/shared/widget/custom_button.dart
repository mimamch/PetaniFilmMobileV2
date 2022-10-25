import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class CustomButtonPrimary extends StatelessWidget {
  const CustomButtonPrimary({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(
          Constants.primaryblueColor,
        ),
        minimumSize: const MaterialStatePropertyAll(
          Size(double.infinity, 50),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Constants.whiteColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class CustomButtonSecondary extends StatelessWidget {
  const CustomButtonSecondary({
    Key? key,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : () => onTap(),
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(
          Constants.whiteColor,
        ),
        minimumSize: const MaterialStatePropertyAll(
          Size(double.infinity, 50),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Constants.lightBlueColor,
              width: 2,
            ),
          ),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Constants.blackColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
