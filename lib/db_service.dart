import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/person_data.dart';
import 'package:rxdart/rxdart.dart';

var dbService = DatabaseService();

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal() {
    debugPrint('[db] ctor');
    _fetchPersons();
  }

  final _personsSubject = BehaviorSubject<List<Person>>();
  Stream<List<Person>> get persons => _personsSubject.stream;

  _fetchPersons() {
    FirebaseFirestore.instance
        .collection('persons')
        .snapshots()
        .listen((QuerySnapshot qs) {
      for (DocumentSnapshot ds in qs.docs) {
        final p = Person.fromSnapshot(ds);
        debugPrint(p.toString());
      }
    });
  }

  dispose() {
    _personsSubject.close();
  }
}
