import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/event.dart';
import 'package:easy_party/widget/small_main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../style/font.dart';
import '../style/spacings.dart';
import '../widget/invited_card.dart';
import '../widget/main_button.dart';
import '../widget/main_text_field.dart';
import 'package:dto/user.dart' as dto_user;

class AddPartyScreen extends StatefulWidget {
  static const routeName = '/addparty';

  const AddPartyScreen({Key? key}) : super(key: key);

  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
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

  // permet d'ajoute un evenement dans firestore
  void _ajouterEvenement() async {
    // verification de si les champs nom et prenom sont vide
    if (_nomController.text.trim().isEmpty || _adresseController.text.trim().isEmpty) {
      setState(() {
        errorMsg = "Veuillez saisir un nom et une addresse";
      });
      return;
    }

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => value.docs.first);
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    // Creation d'un nouvel événement
    Event newEvent = Event(
        adresse: _adresseController.text,
        theme: _themeController.text,
        nom: _nomController.text,
        host: dto_user.User(
            email: userData['email'],
            nom: userData['nom'],
            prenom: userData['prenom']),
        date: DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, _selectedTime.hour, _selectedTime.minute),
        invited: _invitedList);

    // Ajout du nouvel événement dans Firestore
    FirebaseFirestore.instance
        .collection('events')
        .add(newEvent.toJson())
        .then((_) {
      // si tout se passe bien
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        // afficher une petite banierre
        const SnackBar(
          content: Text("L'événement à bien été crée"),
          duration: Duration(seconds: 3), // Durée du SnackBar
        ),
      );
    }).catchError((error) {
      // si erreur
      setState(() {
        errorMsg = "Erreur lors de l'ajout de l'événement : $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer un événement",
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
                      text: "Créer l'événement",
                      onTap: () => {_ajouterEvenement()},
                      isMain: true,
                    ),
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  Text(
                    errorMsg,
                    style: kErrorStyle,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
