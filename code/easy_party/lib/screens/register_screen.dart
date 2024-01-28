import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_party/style/font.dart';
import 'package:easy_party/style/spacings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dto/user.dart' as dto_user;

import '../style/colors.dart';
import '../widget/main_button.dart';
import '../widget/main_text_field.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 // on enleve le const ?
  final TextEditingController _nomController = TextEditingController();

  final TextEditingController _prenomController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late String errorMsg = "";

  Future<void> _createAccount(BuildContext context) async {

    // verification de si les champs nom et prenom sont vide
    if (_nomController.text.trim().isEmpty || _prenomController.text.trim().isEmpty) {
      setState(() {
        errorMsg = "Veuillez saisir un nom et un prénom";
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _usernameController.text.trim(),
              password: _passwordController.text.trim());

      dto_user.User newUser = dto_user.User( // Créer un object User pour après l'ajouter
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _usernameController.text.trim(),
      );

      await FirebaseFirestore.instance  // ajouter newUser qu'on vient de créer
          .collection('users')
          .add(newUser.toJson());

      Navigator.pushNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email') {
          errorMsg = "Email invalide";
        } else if (e.code == 'email-already-in-use') {
          errorMsg = "L'email utilisé est déjà utilisé";
        } else if (e.code == 'weak-password') {
          errorMsg = "Votre mot de passe est trop faible";
        } else {
          errorMsg = e.message ?? "Erreur inconnue";
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer un compte",
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
                  const Text(
                    "Nom : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Nom',
                    icone: const Icon(Icons.person),
                    controller: _nomController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  const Text(
                    "Prénom :",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Prénom',
                    icone: const Icon(Icons.person_outlined),
                    controller: _prenomController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  const Text(
                    "Addresse mail : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Addresse mail',
                    icone: const Icon(Icons.email),
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacing,
                  ),
                  const Text(
                    "Mot de passe : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Mot de passe',
                    icone: const Icon(Icons.lock),
                    isHide: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacingL,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MainButton(
                      text: 'Créer un compte',
                      onTap: () {
                        _createAccount(context);
                      },
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
