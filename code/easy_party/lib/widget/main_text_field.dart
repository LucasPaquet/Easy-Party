import 'package:easy_party/style/colors.dart';
import 'package:easy_party/style/others.dart';
import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  final String text;
  final Icon icone;
  final bool isHide;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;

  const MainTextField({
    Key? key,
    required this.text,
    required this.icone,
    this.isHide = false,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icone,
        fillColor: kBoxColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMain),
          borderSide: BorderSide.none,
        ),
        hintText: text,
      ),
      obscureText: isHide,
      enableSuggestions: !isHide,
      autocorrect: !isHide,
      onSubmitted: onSubmitted,
    );
  }
}
