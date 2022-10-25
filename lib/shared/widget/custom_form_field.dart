import 'package:flutter/material.dart';
import 'package:petani_film_v2/shared/widget/custom_text_field.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.controller,
      this.prefix,
      required this.title,
      this.secure = false,
      this.disabled = false,
      this.inputType = TextInputType.text,
      this.maxLines = 1});
  final TextEditingController controller;
  final String? prefix;
  final String title;
  final bool secure;
  final bool disabled;
  final TextInputType inputType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextField(
          inputType: inputType,
          prefix: prefix,
          controller: controller,
          secure: secure,
          disabled: disabled,
          maxLines: maxLines,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
