import 'package:cloud_firestore/cloud_firestore.dart';

class Person implements Comparable<Person> {
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String COLLECTION_NAME = 'persons';

  final String name;
  final String email;
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
      {required String name, required String email}) async {
    final doc = FirebaseFirestore.instance.collection(COLLECTION_NAME).doc();
    final Map<String, dynamic> map = {};
    map[EMAIL] = email;
    map[NAME] = name;
    await doc.set(map);
    return doc.id;
  }
}
