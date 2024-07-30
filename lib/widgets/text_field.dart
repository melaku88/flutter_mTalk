import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final bool obsecure;
  final IconData icon;
  final TextInputType textInputType;
  final String hintText;
  final VoidCallback onTap;
  const MyTextField(
      {super.key,
      required this.lable,
      required this.icon,
      required this.textInputType,
      required this.controller,
      required this.hintText, required this.onTap, required this.obsecure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: false,
      obscureText: obsecure,
      keyboardType: textInputType,
      cursorWidth: 1.0,
      style: TextStyle(
        color: Colors.lightBlue
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15.0, vertical: 0.0),
        label: Text(lable),
        labelStyle: TextStyle(color: Colors.black38),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 189, 227, 244),
          fontSize: 12.0
        ),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),

        suffixIcon: InkWell(
          onTap: onTap,
          child: Icon(icon,
          size: 21.0, color: Colors.black54,)
        ),
      ),
    );
  }
}
