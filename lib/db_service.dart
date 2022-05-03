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
        .collection(Person.COLLECTION_NAME)
        .snapshots()
        .listen((QuerySnapshot qs) {
      debugPrint('There are ${qs.docs.length} persons');
      final List<Person> list = [];
      for (DocumentSnapshot ds in qs.docs) {
        final p = Person.fromSnapshot(ds);
        list.add(p);
      }
      list.sort();
      _personsSubject.sink.add(list);
    });
  }

  dispose() {
    _personsSubject.close();
  }
}
