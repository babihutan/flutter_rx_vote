import 'package:flutter/foundation.dart';
import 'validate_all_streams_have_data_and_no_errors.dart';
import '../data/person.dart';
import 'signup_validators.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc with SignupValidators {

  SignupBloc() {
    //TODO:  remove for shaft
    _validateAllStreamsHaveDataAndNoErrors = ValidateAllStreamsHaveDataAndNoErrors()
                                              ..listen([
                                                  name,
                                                  email,
                                                  password,
                                                ]);
  }

  //TODO:  remove for live coding
  final _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Function(String) get changeEmail => _emailSubject.sink.add;

  final _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password =>
      _passwordSubject.stream.transform(validatePassword);
  Function(String) get changeName => _nameSubject.sink.add;

  final _nameSubject = BehaviorSubject<String>();
  Stream<String> get name => _nameSubject.stream.transform(validateName);
  Function(String) get changePassword => _passwordSubject.sink.add;

  Stream<bool> get isSubmitValid => Rx.combineLatest3(name, email, password,
          (String n, String e, String pwd)  => true);

  //TODO:  remove for shaft
  late ValidateAllStreamsHaveDataAndNoErrors _validateAllStreamsHaveDataAndNoErrors;
  Stream<bool?> get isSubmitValidBoelensFix => _validateAllStreamsHaveDataAndNoErrors.status;

  Future<void> submit() async {
    final name = _nameSubject.value;
    final email = _emailSubject.value;
    debugPrint('name=$name, email=$email');
    final personId = await Person.create(name: name, email: email);
    debugPrint('created person $personId');
    return;
  }

  dispose() {
    debugPrint('[signup_bloc] dispose');
    _passwordSubject.close();
    _emailSubject.close();
    _nameSubject.close();
    _validateAllStreamsHaveDataAndNoErrors.dispose();
  }

}
