// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Person implements Comparable<Person> {

  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String COLLECTION_NAME = 'persons';

  final String name;
  final String email;
  String get personId => reference.id;
  String get id => reference.id;
  final DocumentReference reference;

  @override
  int compareTo(Person p) {
    return p.name.compareTo(name);
  }

  Person.fromMap(Map<String, dynamic> map, this.reference)
      : assert(map[NAME] != null),
        assert(map[EMAIL] != null),
        name = map[NAME],
        email = map[EMAIL];

  Person.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.reference);

  @override
  String toString() => "Person<${reference.id}, name=$name, email=$email>";

  static Future<String> create(
      {required String name, required String email, String? id}) async {
    final personId =
        id ?? FirebaseFirestore.instance.collection(COLLECTION_NAME).doc().id;
    final doc = FirebaseFirestore.instance.doc('$COLLECTION_NAME/$personId');
    final Map<String, dynamic> map = {};
    map[EMAIL] = email;
    map[NAME] = name;
    await doc.set(map);
    debugPrint('[person] created person $personId with $map');
    return personId;
  }

  static initPersons() {
    create(
        id: 'person-1',
        name: 'James Jones',
        email: 'jamesjones@mailinator.com');
    create(
        id: 'person-2',
        name: 'Summer Anderson',
        email: 'summeranderson@mailinator.com');
    create(id: 'person-3', name: 'Randy Tong', email: 'rtong@mailinator.com');
    create(
        id: 'person-3',
        name: 'Felix Wallace',
        email: 'fwallace@mailinator.com');
        create(
        id: 'person-4',
        name: 'Jennifer Song',
        email: 'jsong@mailinator.com');
            create(
        id: 'person-5',
        name: 'Mike Little',
        email: 'michaellittle@mailinator.com');
            create(
        id: 'person-6',
        name: 'Tim Thompson',
        email: 'tthomp@mailinator.com');
            create(
        id: 'person-7',
        name: 'Alicia Washington',
        email: 'awashington@mailinator.com');
  }
}
