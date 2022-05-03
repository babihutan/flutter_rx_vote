import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/signup_bloc.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final SignupBloc _signupBloc = SignupBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder<bool>(
          stream: _signupBloc.isSubmitValid,
          builder: (context, isValidSnap) {
            return ElevatedButton(
              onPressed: (isValidSnap.hasData && isValidSnap.data!)
                  ? () {
                      _signupBloc.submit();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Submit'),
            );
          }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _nameField(context),
            _emailField(context),
            _passwordField(context),
          ],
        ),
      ),
    );
  }

  Widget _nameField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.name,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _signupBloc.changeName,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Jim Jones',
            labelText: 'Name',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
          ),
        );
      },
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
