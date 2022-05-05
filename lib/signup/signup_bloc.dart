import 'package:flutter/foundation.dart';
import 'signup_validators.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc with SignupValidators {
  SignupBloc() {
    // _validateAllStreamsHaveDataAndNoErrors = ValidateAllStreamsHaveDataAndNoErrors()
    //                                           ..listen([
    //                                               name,
    //                                               email,
    //                                               password,
    //                                             ]);
  }

  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get changeName => _nameSubject.sink.add;

  final _nameSubject = BehaviorSubject<String>();
  Stream<String> get name => _nameSubject.stream;
  Function(String) get changePassword => _passwordSubject.sink.add;

  // Stream<bool> get isSubmitValid => Rx.combineLatest3(name, email, password,
  //         (String n, String e, String pwd)  => true);

  // late ValidateAllStreamsHaveDataAndNoErrors _validateAllStreamsHaveDataAndNoErrors;
  // Stream<bool?> get isSubmitValidBoelensFix => _validateAllStreamsHaveDataAndNoErrors.status;

  Future<void> submit() async {
    // final name = _nameSubject.value;
    // final email = _emailSubject.value;
    // debugPrint('name=$name, email=$email');
    // final personId = await Person.create(name: name, email: email);
    // debugPrint('created person $personId');
    // return;
  }

  dispose() {
    debugPrint('[signup_bloc] dispose');
    _passwordSubject.close();
    //_emailSubject.close();
    _nameSubject.close();
    //_validateAllStreamsHaveDataAndNoErrors.dispose();
  }
}
