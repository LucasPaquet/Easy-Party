import 'package:easy_party/style/font.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class EmptyStateEvent extends StatelessWidget {
  const EmptyStateEvent({super.key});

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
              "Mince,\nvous ne participez à aucun événement",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/img/emptystateevent.png',
              fit: BoxFit.fill,
            ),
            const Text(
              "Pour rejoindre un événement appuyer sur le '+'\nou aller dans vos invitations",
              style: kEmptyStateStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
