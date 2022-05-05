import 'package:flutter_rx_vote/data/person.dart';
import '../data/poll.dart';

class PollResult implements Comparable<PollResult> {
//class PollResult  {
  final Poll poll;
  List<String> get answers => poll.answers;
  final List<List<Person>> votes;
  PollResult(this.poll, this.votes);

  @override
  int compareTo(PollResult pr) {
    return poll.compareTo(pr.poll);
  }

}
