import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/spacings.dart';

class InvitedCard extends StatelessWidget {
  final String email;
  final VoidCallback onTap;

  const InvitedCard({
    Key? key,
    required this.email,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBoxColor,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(kPaddingButton),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(email),
              const SizedBox(width: kHorizontalSpacingS),
              const Icon(
                Icons.cancel,
                size: kIconInvited,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
