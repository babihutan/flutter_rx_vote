import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/firebase_options.dart';
import 'package:flutter_rx_vote/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final _ = dbService;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rx Vote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

