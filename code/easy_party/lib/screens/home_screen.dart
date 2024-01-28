import 'package:easy_party/style/font.dart';
import 'package:easy_party/style/spacings.dart';
import 'package:easy_party/widget/cancel_button.dart';
import 'package:easy_party/widget/event_stream.dart';
import 'package:easy_party/widget/host_stream.dart';
import 'package:easy_party/widget/invited_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../widget/add_event_floating_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddEventFloatingButton(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: kBoxColor,
        backgroundColor: kTextOnBGColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.local_bar),
            label: 'Événement',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available),
            label: 'Organisation',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            label: 'Invitation',
          ),
        ],
      ),
      body: <Widget>[
        // PREMIERE PAGE
        Container(
          decoration: const BoxDecoration(
            color: kBackgroundColor,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMain),
              child: Column(
                children: [
                  Row(
                    children: [
                      CancelButton(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Vos événements à venir",
                        style: kBGStyle,
                      ),
                    ],
                  ),
                  const Expanded(
                    child: EventStream(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // DEUXIEME PAGE
        Container(
          decoration: const BoxDecoration(
            color: kBackgroundColor,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMain),
              child: Column(
                children: [
                  Row(
                    children: [
                      CancelButton(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Vos événements organisés",
                        style: kBGStyle,
                      ),
                    ],
                  ),
                  const Expanded(
                    child: HostStream(),
                  )
                ],
              ),
            ),
          ),
        ),
        // TROISIEME PAGE
        Container(
          decoration: const BoxDecoration(
            color: kBackgroundColor,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMain),
              child: Column(
                children: [
                  Row(
                    children: [
                      CancelButton(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Invitations",
                        style: kBGStyle,
                      ),
                    ],
                  ),
                  const Expanded(
                    child: InvitedStream(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );
  }
}
