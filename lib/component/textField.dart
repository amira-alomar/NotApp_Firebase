import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText ;
  final TextEditingController mycontroller;
  const CustomField({super.key, required this.hintText, required this.mycontroller, this.validator});
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey)),
      ),
    );
  }
}
