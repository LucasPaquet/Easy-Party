import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/event.dart';
import 'package:dto/user.dart' as dto_user;
import 'package:easy_party/screens/answer_invite_screen.dart';
import 'package:easy_party/widget/empty_state_invite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'invited_info.dart';

class InvitedStream extends StatefulWidget {
  const InvitedStream({super.key});

  @override
  State<InvitedStream> createState() => _InvitedStreamState();
}

class _InvitedStreamState extends State<InvitedStream> {
  late Stream<QuerySnapshot> _eventsStream;

  List<String> convertInvited(List<dynamic> invitedList) {
    return invitedList.map((dynamic item) => item.toString()).toList();
  }

  @override
  void initState() {
    super.initState();
    _eventsStream = FirebaseFirestore.instance
        .collection('events')
        .where('invited',
            arrayContains: FirebaseAuth.instance.currentUser!.email)
        .withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toJson())
        .snapshots();
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
          return const EmptyStateInvite();
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
                  AnswerInviteScreen.routeName,
                  arguments: [event, doc.id],
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
