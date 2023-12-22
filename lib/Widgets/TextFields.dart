import 'package:flutter/material.dart';

class TextFields extends StatefulWidget {

  final String text;
  final TextEditingController textEditingController;
  final TextInputType textInputType;

  final bool? isPassword;

  const TextFields({
    super.key,
    required this.text,
    required this.textEditingController,
    required this.textInputType,
    this.isPassword
  });

  @override
  State<TextFields> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,

        obscureText: widget.isPassword??false  ?
            true:
            false,
        decoration: InputDecoration(
            hintText: widget.text,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,width: 3)
            )
        ),

      ),
    );
  }
}
