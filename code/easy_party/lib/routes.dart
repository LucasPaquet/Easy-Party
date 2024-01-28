import 'package:easy_party/screens/add_party_screen.dart';
import 'package:easy_party/screens/answer_invite_screen.dart';
import 'package:easy_party/screens/edit_party_screen.dart';
import 'package:easy_party/screens/home_screen.dart';
import 'package:easy_party/screens/info_party_screen.dart';
import 'package:easy_party/screens/login_screen.dart';
import 'package:easy_party/screens/register_screen.dart';
import 'package:easy_party/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  WelcomeScreen.routeName : (context) => const WelcomeScreen(),
  LoginScreen.routeName : (context) => LoginScreen(),
  RegisterScreen.routeName : (context) => RegisterScreen(),
  HomeScreen.routeName : (context) => const HomeScreen(),
  AddPartyScreen.routeName : (context) => const AddPartyScreen(),
  InfoPartyScreen.routeName : (context) => const InfoPartyScreen(),
  AnswerInviteScreen.routeName : (context) => AnswerInviteScreen(),
  EditPartyScreen.routeName : (context) => const EditPartyScreen(),
};