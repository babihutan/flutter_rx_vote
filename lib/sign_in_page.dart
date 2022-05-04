import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/home_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _fastLoginButton(context, 'jamesjones@mailinator.com'),
            _fastLoginButton(context, 'bbb'),
            _fastLoginButton(context, 'aaa'),
          ],
        ),
      ),
    );
  }

  Widget _fastLoginButton(BuildContext context, String email) {
    return TextButton(
      onPressed: () {
        dbService.login(email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
      child: Text('Login as $email'),
    );
  }
}
