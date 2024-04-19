import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final int? maxLength;
  final bool isNumeric;

  const StyledTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLength,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  _StyledTextFieldState createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: widget.controller,
        maxLength: widget.maxLength ?? null,
        keyboardType:
            widget.isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.isNumeric
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
      ),
    );
  }
}
