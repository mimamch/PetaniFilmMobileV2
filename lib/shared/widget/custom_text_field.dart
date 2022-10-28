import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.inputType = TextInputType.text,
      this.controller,
      this.placeholder,
      this.onChange,
      this.secure = false,
      this.disabled = false,
      this.maxLines = 1,
      this.action,
      this.onSubmitted});
  final TextInputType inputType;
  final TextEditingController? controller;
  final String? placeholder;
  final Function? onChange;
  final Function? onSubmitted;
  final bool secure;
  final bool disabled;
  final int? maxLines;
  final TextInputAction? action;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: secure,
      controller: controller,
      readOnly: disabled,
      onChanged: ((value) => onChange == null ? null : onChange!(value)),
      style: const TextStyle(
        color: Constants.whiteColor,
        // fontSize: 16,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(width: 1, color: Constants.whiteColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(width: 2, color: Constants.whiteColor)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: placeholder,
        hintStyle: const TextStyle(fontSize: 14, color: Constants.whiteColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Constants.whiteColor,
          ),
        ),
      ),
      keyboardType: inputType,
      maxLines: maxLines,
      textInputAction: action,
      onSubmitted: (value) {
        if (onSubmitted != null) onSubmitted!(value);
      },
    );
  }
}
