import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimeField extends StatefulWidget {
  final String? labelText;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomDateTimeField({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.errorText,
    required this.hintText,
  });

  @override
  State<CustomDateTimeField> createState() => _CustomDateTimeFieldState();
}

class _CustomDateTimeFieldState extends State<CustomDateTimeField> {
  late TextEditingController _controller;
  bool _isControllerOwner = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
      _isControllerOwner = true;
    } else {
      _controller = widget.controller!;
      _isControllerOwner = false;
    }
  }

  @override
  void dispose() {
    if (_isControllerOwner) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (pickedDate != null) {
      final dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      setState(() {
        _controller.text = formattedDate;
        widget.onChanged?.call(dateTime.toIso8601String());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _controller,
      readOnly: true,
      onTap: () => _selectDateTime(context),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        // border: customOutlineInputBorder,
        // enabledBorder: customOutlineInputBorder,
        // focusedBorder: customOutlineInputBorder.copyWith(
        //   borderSide: const BorderSide(color: Color(0xFF17a2b8)),
        // ),
      ),
      validator: widget.validator,
      forceErrorText: widget.errorText,
    );
  }
}

const customOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF17a2b8)),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
