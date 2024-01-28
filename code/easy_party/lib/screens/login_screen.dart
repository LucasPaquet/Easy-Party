import 'package:easy_party/screens/home_screen.dart';
import 'package:easy_party/style/font.dart';
import 'package:easy_party/style/spacings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../widget/main_button.dart';
import '../widget/main_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late String errorMsg = "";

  Future<void> _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si la connexion est réussie, naviguez vers la page d'accueil
      Navigator.pushNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email') {
          errorMsg = "Email invalide";
        } else if (e.code == 'invalid-credential') {
          errorMsg = "Mot de passe ou email incorrect";
        } else if (e.code == 'user-disabled') {
          errorMsg = "Votre compte est désactivé";
        } else {
          errorMsg = e.message ?? "Erreur inconnue";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    kDebugMode
        ? _usernameController.text = "a@a.com"
        : ""; // en debug mode, pre remplir
    kDebugMode
        ? _passwordController.text = "azerty"
        : ""; // en debug mode, pre remplir
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connexion",
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
                    height: kHorizontalSpacingL,
                  ),
                  const Text(
                    "Addresse mail : ",
                    style: kBGMediumStyle,
                  ),
                  MainTextField(
                    text: 'Addresse mail',
                    icone: const Icon(Icons.account_circle),
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: kHorizontalSpacingL,
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
                        text: 'Se connecter',
                        onTap: () {
                          _signIn(context);
                        },
                        isMain: true),
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
