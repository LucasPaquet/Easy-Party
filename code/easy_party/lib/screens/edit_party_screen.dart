import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/event.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/font.dart';
import '../style/spacings.dart';
import '../widget/guest_expansion_tile.dart';
import '../widget/invited_card.dart';
import '../widget/main_button.dart';
import '../widget/main_text_field.dart';
import '../widget/small_main_button.dart';

class EditPartyScreen extends StatefulWidget {
  static const routeName = '/editparty';

  const EditPartyScreen({super.key});

  @override
  State<EditPartyScreen> createState() => _EditPartyScreenState();
}

class _EditPartyScreenState extends State<EditPartyScreen> {
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _invitedList = [];

  late String errorMsg = "";

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // permet de mettre a jour les donnees de l'event
  Future<void> updateEventDetails(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(uid).update({
        'nom': _nomController.text,
        'adresse': _adresseController.text,
        'theme': _themeController.text,
        'date': DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
        'invited': FieldValue.arrayUnion(_invitedList),
      }
      );
      Navigator.of(context).pop(); // Ferme le screen
      // Mettre à jour les données dans Firebase avec les valeurs des contrôleurs et de la date/heure sélectionnées
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de l\'événement : $e');
    }

  }

  // Supprime l'événement
  Future<void> deleteEvent(String uid) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("Voulez-vous vraiment supprimer cet événement ?"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Fermer le dialogue
                  await FirebaseFirestore.instance.collection('events').doc(uid).delete(); //Supression dans firebase
                  Navigator.of(context).pop(); // Ferme le screen
                },
                child: const Text("Oui"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer le dialogue
                },
                child: const Text("Non"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'événement : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // permet de recupere les arguments de navigator push
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Event event = arguments[0] as Event;
    final String uid = arguments[1] as String;

    _nomController.text = event.nom;
    _adresseController.text = event.adresse;
    _themeController.text = event.theme ?? "Pas de thème";
    _selectedDate = event.date;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Modifier l'événement",
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
                  const SizedBox(
                    height: kVerticalSpacing,
                  ),
                  const Text(
                    "Nom : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Nom de la fête',
                    icone: const Icon(Icons.badge_outlined),
                    controller: _nomController,
                  ),
                  const Text(
                    "Addresse: ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Addresse',
                    icone: const Icon(Icons.home),
                    isHide: false,
                    controller: _adresseController,
                  ),
                  const Text(
                    "Thème : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Ex : Déguisé, années 2000, Disco,...',
                    icone: const Icon(Icons.checkroom),
                    isHide: false,
                    controller: _themeController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Date: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year} à ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: kBGMediumStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallMainButton(
                        text: "Sélectionner la date",
                        onTap: () => _selectDate(context),
                        isMain: true,
                      ),
                      SmallMainButton(
                        text: "Sélectionner l'heure",
                        onTap: () => _selectTime(context),
                        isMain: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  MainTextField(
                    text: "Ajouter des invités",
                    icone: const Icon(Icons.account_box_rounded),
                    controller: _emailController,
                    onSubmitted: (value) {
                      setState(() {
                        _invitedList.add(value);
                        _emailController.clear(); // vide le champs
                      });
                    },
                  ),
                  Wrap(
                    spacing: kWarpSpacing,
                    runSpacing: kWarpSpacing,
                    children: _invitedList.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String email = entry.value;
                      return InvitedCard(
                        email: email,
                        onTap: () {
                          setState(() {
                            _invitedList.removeAt(index); // Supprime l'élément sélectionné
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
                      text: "Modifier l'événement",
                      onTap: () => {updateEventDetails(uid)},
                      isMain: true,
                    ),
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  Text(
                    errorMsg,
                    style: kErrorStyle,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
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
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MainButton(
                      text: "Supprimer l'événement",
                      onTap: () => {deleteEvent(uid)},
                      isMain: false,
                    ),
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
