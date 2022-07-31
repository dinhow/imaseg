import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  const CustomTextformfield(
      {Key? key,
      this.counterText,
      this.labelText,
      this.maxLenght,
      this.textInputType,
      this.controller,
      this.textCapitalization,
      this.validator})
      : super(key: key);

  final String? counterText;
  final String? labelText;
  final int? maxLenght;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      maxLength: maxLenght,
      textCapitalization: textCapitalization!,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        counterText: counterText,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelText: labelText,
      ),
    );
  }
}
