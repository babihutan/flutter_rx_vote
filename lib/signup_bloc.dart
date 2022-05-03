import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/person_data.dart';
import 'package:flutter_rx_vote/signup_validators.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc with SignupValidators {
  final _passwordSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _nameSubject = BehaviorSubject<String>();

  Stream<String> get name => _emailSubject.stream.transform(validateName);
  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordSubject.stream.transform(validatePassword);

  Function(String) get changeName => _nameSubject.sink.add;
  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;

  Stream<bool> get isSubmitValid =>
      Rx.combineLatest3(name, email, password, (String n, String e, String pwd) => true);

  dispose() {
    _passwordSubject.close();
    _emailSubject.close();
    _nameSubject.close();
  }

  submit() async {
    final name = _nameSubject.value;
    final email = _emailSubject.value;
    debugPrint('name=$name, email=$email');
    final personId = await Person.create(name: name, email: email);
    debugPrint('created person $personId');
    _nameSubject.sink.add('');
    _emailSubject.sink.add('');
    _passwordSubject.sink.add('');
  }
}
