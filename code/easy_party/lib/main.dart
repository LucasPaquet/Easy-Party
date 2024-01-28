import 'package:easy_party/firebase_options.dart';
import 'package:easy_party/routes.dart';
import 'package:easy_party/style/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Party',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kBackgroundColor),
        useMaterial3: true,
      ),
      routes: routes,
    );
  }
}


