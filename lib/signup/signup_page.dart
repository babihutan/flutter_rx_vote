import 'package:flutter/material.dart';
import 'signup_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late SignupBloc _signupBloc;

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _signupBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder<bool?>(
        stream: _signupBloc.isSubmitValidBoelensFix,
        builder: (context, isValidSnap) {
          return ElevatedButton(
            onPressed: (isValidSnap.hasData &&
                    isValidSnap.data != null &&
                    isValidSnap.data!)
                ? () async {
                    await _signupBloc.submit();
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('Submit'),
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _nameTextField(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _emailTextField(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _passwordTextField(context),
          ),
        ],
      ),
    );
  }

  Widget _nameTextField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.name,
      builder: (context, snapshot) {
        return TextField(
          style: const TextStyle(fontWeight: FontWeight.w500),
          onChanged: _signupBloc.changeName,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Jim Jones',
            labelText: 'Name',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            fillColor: Theme.of(context).primaryColorLight,
            filled: true,
          ),
        );
      },
    );
  }

  Widget _emailTextField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.email,
      builder: (context, snapshot) {
        return TextField(
          style: const TextStyle(fontWeight: FontWeight.w500),
          onChanged: _signupBloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'me@fun.com',
            labelText: 'Email',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            fillColor: Theme.of(context).primaryColorLight,
            filled: true,
          ),
        );
      },
    );
  }

  Widget _passwordTextField(BuildContext context) {
    return StreamBuilder(
      stream: _signupBloc.password,
      builder: (context, snapshot) {
        return TextField(
          style: const TextStyle(fontWeight: FontWeight.w500),
          obscureText: true,
          onChanged: _signupBloc.changePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            fillColor: Theme.of(context).primaryColorLight,
            filled: true,
          ),
        );
      },
    );
  }
}
