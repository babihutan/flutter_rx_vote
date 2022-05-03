import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/firebase_options.dart';
import 'package:flutter_rx_vote/signup_bloc.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final SignupBloc _signupBloc = SignupBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder<bool>(
        stream: _signupBloc.isSubmitValid,
        builder: (context, isValidSnap) {
          return ElevatedButton(
            onPressed: (isValidSnap.hasData && isValidSnap.data!) ? _signupBloc.submit : null,
            child: const Text('Submit'),
          );
        }
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _emailField(context),
            _passwordField(context),
          ],
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _signupBloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'me@fun.com',
            labelText: 'Email',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
          ),
        );
      },
    );
  }

  Widget _passwordField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: _signupBloc.changePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
          ),
        );
      },
    );
  }
}
