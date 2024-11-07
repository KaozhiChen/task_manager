import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager/pages/login_page.dart';
import 'theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      theme: ThemeData(
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primary,
          secondary: secondary,
        ),
      ),
    );
  }
}
