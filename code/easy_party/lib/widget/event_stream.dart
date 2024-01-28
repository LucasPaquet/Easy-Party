import 'package:clipboard/clipboard.dart';
import 'package:dto/event.dart';
import 'package:dto/user.dart' as dto_user;
import 'package:easy_party/widget/empty_state_event.dart';
import 'package:easy_party/widget/invited_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/info_party_screen.dart';

class EventStream extends StatefulWidget {
  const EventStream({Key? key}) : super(key: key);

  @override
  _EventStreamState createState() => _EventStreamState();
}

class _EventStreamState extends State<EventStream> {
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = FirebaseFirestore.instance
        .collection('events')
        .where('present',
            arrayContains: FirebaseAuth.instance.currentUser!.email)
        .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toJson())
        .snapshots();
  }

  List<String> convertInvited(List<dynamic> invitedList) {
    return invitedList.map((dynamic item) => item.toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des données.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          // si pas de donnees, on affiche le empty state
          return const EmptyStateEvent();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            List<String> invited = convertInvited(doc['invited']);
            List<String> present = convertInvited(doc['present']);
            List<String> absent = convertInvited(doc['absent']);
            List<String> brings = convertInvited(doc['brings']);
            return GestureDetector(
              onLongPress: () {
                // on appuie longtemps, on copie l'uid
                FlutterClipboard.copy(
                    doc.id); // permet de copier l'uid dans le presse papier

                ScaffoldMessenger.of(context).showSnackBar(
                  // afficher une petite banierre
                  const SnackBar(
                    content: Text(
                        "Le code de l'événement à été copié dans le presse papier"),
                    duration: Duration(seconds: 3), // Durée du SnackBar
                  ),
                );
              },
              onTap: () {
                // Navigation vers InfoPartyScreen avec les données de l'événement
                Event event = Event(
                  adresse: doc['adresse'],
                  theme: doc['theme'],
                  nom: doc['nom'],
                  date: doc['date'].toDate(),
                  invited: invited,
                  present: present,
                  absent: absent,
                  host: dto_user.User(
                    email: doc['host.email'],
                    nom: doc['host.nom'],
                    prenom: doc['host.prenom'],
                  ),
                  brings: brings,
                );

                Navigator.pushNamed(
                  context,
                  InfoPartyScreen.routeName,
                  arguments: event,
                );
              },
              child: Column(
                children: [
                  InvitedInfo(
                      adresse: doc['adresse'],
                      theme: doc['theme'],
                      date: doc['date'].toDate(),
                      nom: doc['nom']),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
