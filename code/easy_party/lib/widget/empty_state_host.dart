import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/font.dart';

class EmptyStateHost extends StatelessWidget {
  const EmptyStateHost({super.key});

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
              "Oops,\nvous n\'organisez pas encore d'événement",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/img/emptystate.png',
              fit: BoxFit.fill,
            ),
            const Text(
              "Appuyer sur le '+'\n pour créer un événement",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
