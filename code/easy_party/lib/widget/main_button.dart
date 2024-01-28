import 'package:easy_party/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/font.dart';
import '../style/others.dart';
import '../style/spacings.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isMain;

  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(kPaddingButton),
        decoration: BoxDecoration(
            color: isMain ? kBoxColor : kErrorColor,
            borderRadius: BorderRadius.circular(kRadiusMain)),
        child: Text(
          text,
          style: isMain ? kButtonStyle : kButtonDeleteStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
