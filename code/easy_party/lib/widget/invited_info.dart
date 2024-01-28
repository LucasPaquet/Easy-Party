import 'package:easy_party/style/colors.dart';
import 'package:flutter/material.dart';

import '../style/spacings.dart';

class InvitedInfo extends StatelessWidget {
  final String adresse;
  final String theme;
  final String nom;
  final DateTime date;

  const InvitedInfo({
    Key? key,
    required this.adresse,
    required this.theme,
    required this.nom,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kBoxColor,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kVerticalSpacingBoxInfo),
              Text(
                'Adresse: $adresse',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: kVerticalSpacingBoxInfo),
              Text( // padLeft ajoute force 2 chiffre et ajoute 0 a gauche si ce nombre n'est pas atteint (pour eviter 1:8 pour 01:08)
                'Date: ${date.day}-${date.month}-${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: kVerticalSpacingBoxInfo),
              Text(
                'Theme: $theme',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
