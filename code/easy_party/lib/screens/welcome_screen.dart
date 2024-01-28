import 'package:easy_party/screens/login_screen.dart';
import 'package:easy_party/screens/register_screen.dart';
import 'package:easy_party/style/colors.dart';
import 'package:easy_party/style/spacings.dart';
import 'package:flutter/material.dart';

import '../style/font.dart';
import '../widget/main_button.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: kBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kVerticalSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Easy Party',
                  style: TextStyle(
                    fontFamily: 'Promo',
                    fontSize: 70,
                    color: kTextOnBGColor,
                  ),
                ),
                Image.asset(
                  'assets/icons/WelcomeLogo.png',
                  height: kWelcomeLogoSizeHeight,
                  width: kWelcomeLogoSizeWidth,
                  fit: BoxFit.fill,
                ),
                MainButton(
                    text: 'Se connecter',
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    isMain: true),
                MainButton(
                    text: 'Créer un compte',
                    onTap: () {
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    },
                    isMain: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
