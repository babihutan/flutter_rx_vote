import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/signup_validators.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc with SignupValidators {
  final _passwordSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordSubject.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailSubject.sink.add;
  Function(String) get changePassword => _passwordSubject.sink.add;

  Stream<bool> get isSubmitValid =>
      Rx.combineLatest2(email, password, (String email, String pwd) {
        debugPrint('email=$email, pwd=$pwd');
        return true;
      });

  dispose() {
    _passwordSubject.close();
    _emailSubject.close();
  }

  submit() {
    debugPrint('submit');
  }
}
