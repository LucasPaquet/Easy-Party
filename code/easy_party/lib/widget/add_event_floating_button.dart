
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/screens/add_party_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../style/colors.dart';

class AddEventFloatingButton extends StatelessWidget {

  // permet a l'utilisateur a s'invite avec l'uid
  Future<void> showAddEmailDialog(BuildContext context) async {
    TextEditingController eventIdController = TextEditingController();
    String eventId = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(   // pour afficher un pop du systeme
          title: const Text('Ajouter votre email'),
          content: TextField(
            controller: eventIdController,
            decoration: const InputDecoration(
              hintText: 'Entrez l\'UID de l\'événement',
            ),
            onChanged: (value) {
              eventId = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () async {
                String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
                DocumentSnapshot eventSnapshot =
                await FirebaseFirestore.instance.collection('events').doc(eventId).get(); // recupere l'events avec le meme UID

                if (eventSnapshot.exists) { // si il trouve l'events (si il existe)
                  dynamic eventData = eventSnapshot.data();
                  List<dynamic> invitedList = eventData != null && eventData['invited'] != null
                      ? List.from(eventData['invited']) // recupere la liste des invites
                      : []; // sinon retourn rien (pas d'invite)

                  if (!invitedList.contains(currentUserEmail)) {  // si l'utlisateur n'est PAS dans les invites
                    invitedList.add(currentUserEmail); // ajoute a la liste
                    await FirebaseFirestore.instance // push sur firestore
                        .collection('events')
                        .doc(eventId)
                        .update({'invited': invitedList});

                    ScaffoldMessenger.of(context).showSnackBar( // afficher une petite banierre
                      const SnackBar(
                        content: Text('Vous avez été ajoutez à la liste des invités avec succès !'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar( // afficher une petite banierre
                      const SnackBar(
                        content: Text('Vous êtes déjà dans la liste des invités.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar( // afficher une petite banierre
                    const SnackBar(
                      content: Text('Aucun événement trouvé avec cet UID.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      visible: true,
      closeManually: false,
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: kBackgroundSecondColor,
      foregroundColor: kTextOnBGColor,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.event),
          label: 'Créer un événement',
          onTap: () {
            Navigator.pushNamed(context, AddPartyScreen.routeName);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.group),
          label: 'Rejoindre un événement',
          onTap: () {
            showAddEmailDialog(context);
          },
        ),
      ],
    );
  }
}