import 'package:dto/event.dart';
import 'package:easy_party/style/font.dart';
import 'package:easy_party/style/spacings.dart';
import 'package:easy_party/widget/guest_expansion_tile.dart';
import 'package:easy_party/widget/invited_info.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class InfoPartyScreen extends StatelessWidget {
  static const routeName = '/infoparty';

  const InfoPartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event? event = ModalRoute.of(context)?.settings.arguments as Event?;
    if (event != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Information de l'événement",
            style: kBGStyle,
          ),
          iconTheme: const IconThemeData(
            color: kTextOnBGColor,
          ),
          backgroundColor: kBackgroundSecondColor,
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: kBackgroundColor,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingMain),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InvitedInfo(
                      adresse: event.adresse,
                      theme: event.theme ?? "Pas de thème",
                      nom: event.nom,
                      date: event.date,
                    ),
                    const SizedBox(
                      height: kVerticalSpacing,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Présent : ${event.present?.length}",
                          style: kInfoStyle,
                        ),
                        Text(
                          "En attente : ${event.invited.length}",
                          style: kInfoStyle,
                        ),
                        Text(
                          "Absent : ${event.absent?.length}",
                          style: kInfoStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: kVerticalSpacing),
                    Text(
                      'Hôte : ${event.host.prenom} ${event.host.nom}(${event.host.email})',
                      style: kBGMediumStyle,
                    ),
                    const SizedBox(height: kVerticalSpacing),
                    GuestExpansionTile(
                      titleText: "Présents",
                      invitedGuests: event.present ?? [],
                    ),
                    GuestExpansionTile(
                      titleText: "Invités",
                      invitedGuests: event.invited,
                    ),
                    GuestExpansionTile(
                      titleText: "Absents",
                      invitedGuests: event.absent ?? [],
                    ),
                    GuestExpansionTile(
                      titleText: "Ce qu'il y aura",
                      invitedGuests: event.brings ?? [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const Placeholder(); // si event est null
  }
}
