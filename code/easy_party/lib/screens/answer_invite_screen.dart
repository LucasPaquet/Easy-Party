import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/font.dart';
import '../style/spacings.dart';
import '../widget/guest_expansion_tile.dart';
import '../widget/invited_card.dart';
import '../widget/invited_info.dart';
import '../widget/main_button.dart';
import '../widget/main_text_field.dart';
import '../widget/presence_combobox.dart';

class AnswerInviteScreen extends StatefulWidget {
  static const routeName = '/answerinvite';

  AnswerInviteScreen({super.key});

  @override
  State<AnswerInviteScreen> createState() => _AnswerInviteScreenState();
}

class _AnswerInviteScreenState extends State<AnswerInviteScreen> {
  final TextEditingController _presenceController = TextEditingController();

  final TextEditingController _eBringController = TextEditingController();

  final List<String> _bringList = [];

  Future<void> updateInvitationResponse(String eventId, String response) async {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    String fieldName = (response == "Absent") ? 'absent' : 'present';

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);

        // Supprimer l'utilisateur des invités
        transaction.update(eventRef, {"invited": FieldValue.arrayRemove([currentUserEmail])});

        // Ajouter les choses prises
        if (_bringList.isNotEmpty) {
          transaction.update(eventRef, {"brings": FieldValue.arrayUnion(_bringList)});
        }

        // Ajouter l'utilisateur à absent ou present
        transaction.update(eventRef, {fieldName: FieldValue.arrayUnion([currentUserEmail])});
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'enregistrement de la réponse : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // permet de recupere les arguments de navigator push
    final List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Event event = arguments[0] as Event;
    final String uid = arguments[1] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invitation à l'événement",
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
                  const SizedBox(height: kHorizontalSpacing),
                  Text(
                    'Hôte : ${event.host.prenom} ${event.host.nom}(${event.host.email})',
                    style: kBGMediumStyle,
                  ),
                  const SizedBox(height: kHorizontalSpacing),
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
                  const SizedBox(height: kHorizontalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Présence : ",
                        style: kBGStyle,
                      ),
                      PresenceComboBox(
                        controller: _presenceController,
                      ),
                    ],
                  ),
                  const Text(
                    "J'apporte: ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: "Ex : Chips, soda, apéritif, bière, ...",
                    icone: const Icon(Icons.takeout_dining),
                    controller: _eBringController,
                    onSubmitted: (value) {
                      setState(() {
                        _bringList.add(value);
                        _eBringController.clear(); // vide le champs
                      });
                    },
                  ),
                  Wrap(
                    spacing: kWarpSpacing,
                    runSpacing: kWarpSpacing,
                    children: _bringList.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String email = entry.value;
                      return InvitedCard(
                        email: email,
                        onTap: () {
                          setState(() {
                            _bringList.removeAt(index); // Supprime l'élément sélectionné
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: kHorizontalSpacingL,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MainButton(
                        text: 'Envoyer ma réponse',
                        onTap: () {
                          updateInvitationResponse(uid, _presenceController.text);
                          // parce que pas de context sinon
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar( // afficher une petite banierre
                            const SnackBar(
                              content: Text("La réponse à bien été envoyé"),
                              duration: Duration(seconds: 3), // Durée du SnackBar
                            ),
                          );
                        },
                        isMain: true),
                  ),
                  const SizedBox(
                    height: kVerticalSpacing,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
