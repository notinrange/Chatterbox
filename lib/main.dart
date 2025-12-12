import 'package:chatterbox/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
late Size mq;

void main() {
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter Box',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal,fontSize: 19),
          backgroundColor: Colors.blue.shade200,
        )
      ),
      home: const LoginScreen()
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
}

// agar kisi task ko async bana rahe h toh await optional h 
// par agar kisi task ko await bana rahe h toh async chaiye hoga
// Async returns future object
// Async* returns Stream object
