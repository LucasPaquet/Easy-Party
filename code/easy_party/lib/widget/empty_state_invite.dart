import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/font.dart';

class EmptyStateInvite extends StatelessWidget {
  const EmptyStateInvite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kBackgroundColor,
      ),
      child: Center(
        child: Column(
          children: [
            const Text(
              "Oh non,\nvous n'avez pas d'invitation",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/img/emptystateinvite.png',
              fit: BoxFit.fill,
            ),
            const Text(
              "C'est ici que vous recevrez les invitations à des événements",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
