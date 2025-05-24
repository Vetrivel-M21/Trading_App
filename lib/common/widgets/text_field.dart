import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  
  const MyTextFeild({
    super.key,
    required this.controller,
    required this.lable,
    required this.readOnly,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: lable,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
