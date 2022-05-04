import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/poll.dart';

class Vote {
  static const String ANSWER_INDEX = 'answerIndex';
  static const String VOTE_DATE = 'voteCDate';
  static const String SUB_COLLECTION_NAME = 'votes';

  final int answerIndex;
  final DateTime voteDate;
  final String pollId;
  String get votingPersonId => reference.id;
  final DocumentReference reference;

  Vote.fromMap(Map<String, dynamic> map, this.reference, {required this.pollId})
      : assert(map[ANSWER_INDEX] != null),
        assert(map[VOTE_DATE] != null),
        answerIndex = map[ANSWER_INDEX],
        voteDate = map[VOTE_DATE];

  Vote.fromSnapshot(DocumentSnapshot snapshot, {required pollId})
      : this.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.reference,
            pollId: pollId);

  @override
  String toString() =>
      "Vote<personId=$votingPersonId, pollId=$pollId, answer=$answerIndex>";

  static Future<void> create(
      {required int answerIndex,
      required String votingPersonId,
      required String pollId}) async {
    final doc = FirebaseFirestore.instance
        .doc('${Poll.COLLECTION_NAME}/$pollId/$SUB_COLLECTION_NAME/$votingPersonId');
    final Map<String, dynamic> map = {};
    map[VOTE_DATE] = DateTime.now();
    map[ANSWER_INDEX] = answerIndex;
    await doc.set(map);
    debugPrint('[vote] created vote for poll $pollId and voter $votingPersonId with $map');
    return;
  }
}
