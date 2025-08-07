import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final String? labelText;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool? enable;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextInputType keyboardType;
  final bool? readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.maxLines,
    this.minLines,
    this.enable,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      onTap: onTap,
      onChanged: onChanged,
      enabled: enable,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      forceErrorText: errorText,
      onSaved: onSaved,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        errorMaxLines: 4,
        suffixIcon: suffixIcon,
        // border: customOutlineInputBorder,
        // enabledBorder: customOutlineInputBorder,
        // focusedBorder: customOutlineInputBorder.copyWith(
        //   borderSide: const BorderSide(color: Color(0xFF17a2b8)),
        // ),
      ),
    );
  }
}
