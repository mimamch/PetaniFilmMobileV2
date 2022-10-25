import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.prefix,
    this.inputType = TextInputType.text,
    this.controller,
    this.placeholder,
    this.onChange,
    this.secure = false,
    this.disabled = false,
    this.maxLines = 1,
  });
  final String? prefix;
  final TextInputType inputType;
  final TextEditingController? controller;
  final String? placeholder;
  final Function? onChange;
  final bool secure;
  final bool disabled;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: secure,
      controller: controller,
      readOnly: disabled,
      onChanged: ((value) => onChange == null ? null : onChange!(value)),
      style: const TextStyle(
        color: Constants.blackColor,
        // fontSize: 16,
      ),
      decoration: InputDecoration(
        prefixIcon: prefix == null
            ? null
            : Text(
                '  $prefix ',
                style: const TextStyle(
                  color: Constants.blackColor,
                  // fontSize: 16,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: placeholder,
        hintStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Color(
              0xFFE2E1E4,
            ),
          ),
        ),
      ),
      keyboardType: inputType,
      maxLines: maxLines,
    );
  }
}
