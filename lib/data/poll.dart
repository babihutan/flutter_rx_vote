// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'vote.dart';

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
        answers = _toList(map[ANSWERS]),
        postingDate = _toDate(map[POSTING_DATE]),
        votingDeadlineDate = _toDate(map[VOTING_DEADLINE_DATE]);

  Poll.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.reference);

  @override
  String toString() => "Poll<${reference.id}, name=$name, answers=$answers>";

  static List<String> _toList(dynamic values) {
    final List<String> list = [];
    for (Object v in values) {
      list.add(v as String);
    }
    return list;
  }

  static DateTime _toDate(dynamic dt) {
    return Timestamp(dt.seconds, dt.nanoseconds).toDate();
  }

  static Future<String> create({
    required String name,
    required String originatingPersonId,
    required List<String> answers,
    required DateTime deadline,
    DateTime? postDate,
    String? id,
  }) async {
    final pollId =
        id ?? FirebaseFirestore.instance.collection(COLLECTION_NAME).doc().id;
    final doc = FirebaseFirestore.instance.doc('$COLLECTION_NAME/$pollId');
    final Map<String, dynamic> map = {};
    map[NAME] = name;
    map[POSTING_DATE] = postDate ?? DateTime.now();
    map[ORIGINATING_PERSON_ID] = originatingPersonId;
    map[VOTING_DEADLINE_DATE] = deadline;
    map[ANSWERS] = answers;
    await doc.set(map);
    debugPrint('[poll] created poll $pollId with $map');
    return pollId;
  }

  static initPolls() {
    create(
      id: 'poll-1',
      postDate: DateTime.now().add(const Duration(days: -7)),
      name: 'Best summer vacation spot',
      originatingPersonId: 'person-5',
      answers: ['Beach', 'Mountains', 'Europe'],
      deadline: DateTime.now().add(const Duration(days: 7)),
    );
    create(
      id: 'poll-2',
      postDate: DateTime.now().add(const Duration(days: -21)),
      name: 'Best way to NJ by car',
      originatingPersonId: 'person-6',
      answers: ['Holland Tunnel', 'Lincoln Tunnel', 'GWB'],
      deadline: DateTime.now().add(const Duration(days: -14)),
    );
    create(
      id: 'poll-3',
      postDate: DateTime.now().add(const Duration(days: -7)),
      name: 'What I like best about Flutter',
      originatingPersonId: 'person-7',
      answers: ['Hot Reload', '120 fps', 'Dash'],
      deadline: DateTime.now().add(const Duration(days: 7)),
    );

    Vote.create(answerIndex: 0, votingPersonId: 'person-1', pollId: 'poll-1');
    Vote.create(answerIndex: 0, votingPersonId: 'person-2', pollId: 'poll-1');
    Vote.create(answerIndex: 1, votingPersonId: 'person-3', pollId: 'poll-1');
    Vote.create(answerIndex: 0, votingPersonId: 'person-4', pollId: 'poll-1');
    Vote.create(answerIndex: 0, votingPersonId: 'person-5', pollId: 'poll-1');
    Vote.create(answerIndex: 1, votingPersonId: 'person-6', pollId: 'poll-1');
    Vote.create(answerIndex: 1, votingPersonId: 'person-7', pollId: 'poll-1');

    Vote.create(answerIndex: 0, votingPersonId: 'person-1', pollId: 'poll-2');
    Vote.create(answerIndex: 0, votingPersonId: 'person-2', pollId: 'poll-2');
    Vote.create(answerIndex: 1, votingPersonId: 'person-3', pollId: 'poll-2');
    Vote.create(answerIndex: 1, votingPersonId: 'person-4', pollId: 'poll-2');
    Vote.create(answerIndex: 1, votingPersonId: 'person-5', pollId: 'poll-2');
    Vote.create(answerIndex: 1, votingPersonId: 'person-6', pollId: 'poll-2');
    Vote.create(answerIndex: 2, votingPersonId: 'person-7', pollId: 'poll-2');


    Vote.create(answerIndex: 0, votingPersonId: 'person-4', pollId: 'poll-3');
    Vote.create(answerIndex: 1, votingPersonId: 'person-5', pollId: 'poll-3');
    Vote.create(answerIndex: 2, votingPersonId: 'person-6', pollId: 'poll-3');
    Vote.create(answerIndex: 2, votingPersonId: 'person-7', pollId: 'poll-3');
  }
}
