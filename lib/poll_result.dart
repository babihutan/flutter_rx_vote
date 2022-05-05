import 'poll.dart';

class PollResult implements Comparable<PollResult> {
  final Poll poll;
  List<String> get answers => poll.answers;
  final List<int> voteCounts;
  PollResult(this.poll, this.voteCounts);
  @override
  int compareTo(PollResult pr) {
    return poll.compareTo(pr.poll);
  }
}
