import 'package:easy_party/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/font.dart';

class GuestExpansionTile extends StatelessWidget {
  final List<String> invitedGuests;
  final String titleText; // Ajout du titre en tant que paramètre

  const GuestExpansionTile({
    required this.invitedGuests,
    required this.titleText, // Utilisation du titre en tant que paramètre
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      iconColor: kBoxColor,
      collapsedIconColor: kBoxColor,
      title: Text(
        titleText, // Utilisation du titre fourni dans le constructeur
        style: kBGSemiLargeStyle,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: invitedGuests.length,
            itemBuilder: (context, index) {
              return Text(
                invitedGuests[index],
                style: kBGMediumStyle,
              );
            },
          ),
        ),
      ],
    );
  }
}
