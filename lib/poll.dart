import 'package:cloud_firestore/cloud_firestore.dart';

class Poll implements Comparable<Poll> {
  static const String NAME = 'name';
  static const String ORIGINATING_PERSON_ID = 'originatingPersonId';
  static const String POSTING_DATE = 'postingDate';
  static const String VOTING_DEADLINE_DATE = 'voteDeadlineDate';
  static const String ANSWERS = 'answers';
  static const String COLLECTION_NAME = 'polls';

  final String name;
  final String originatingPersonId;
  final List<String> answers;
  final DateTime postingDate;
  final DateTime votingDeadlineDate;
  String get pollId => reference.id;
  String get id => reference.id;
  final DocumentReference reference;

  @override
  int compareTo(Poll p) {
    return p.name.compareTo(name);
  }

  Poll.fromMap(Map<String, dynamic> map, this.reference)
      : assert(map[NAME] != null),
        assert(map[ORIGINATING_PERSON_ID] != null),
        assert(map[POSTING_DATE] != null),
        assert(map[VOTING_DEADLINE_DATE] != null),
        assert(map[ANSWERS] != null),
        name = map[NAME],
        originatingPersonId = map[ORIGINATING_PERSON_ID],
        answers = map[ANSWERS],
        postingDate = map[POSTING_DATE],
        votingDeadlineDate = map[VOTING_DEADLINE_DATE];

  Poll.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.reference);

  @override
  String toString() => "Poll<${reference.id}, name=$name, answers=$answers>";

  static Future<String> create(
      {required String name,
      required String originatingPersonId,
      required List<String> answers,
      required DateTime deadline}) async {
    final doc = FirebaseFirestore.instance.collection(COLLECTION_NAME).doc();
    final Map<String, dynamic> map = {};
    map[NAME] = name;
    map[POSTING_DATE] = DateTime.now();
    map[ORIGINATING_PERSON_ID] = originatingPersonId;
    map[VOTING_DEADLINE_DATE] = deadline;
    map[ANSWERS] = answers;
    await doc.set(map);
    return doc.id;
  }
}
