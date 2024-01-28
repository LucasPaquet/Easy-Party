import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/spacings.dart';

class CancelButton extends StatelessWidget {
  final Function onTap;

  const CancelButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
          padding: const EdgeInsets.all(kPaddingButton),

          child: const Icon(
            Icons.logout,
            color: kBoxColor,
          )),
    );
  }
}
