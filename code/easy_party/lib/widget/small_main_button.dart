import 'package:easy_party/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/font.dart';
import '../style/spacings.dart';

class SmallMainButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isMain;

  const SmallMainButton({
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
        padding: const EdgeInsets.all(kPaddingButton),
        decoration: BoxDecoration(
            color: isMain ? kBoxColor : kElementColor,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: kSmallButtonStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
