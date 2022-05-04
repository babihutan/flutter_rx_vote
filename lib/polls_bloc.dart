import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/poll.dart';
import 'package:flutter_rx_vote/vote.dart';
import 'package:rxdart/rxdart.dart';

class PollsBloc {
  PollsBloc() {
    debugPrint('[polls_bloc] ctor');
    allPolls.listen((polls) {
      for (Poll poll in polls) {
        dbService.fetchVotes(pollId: poll.id);
      }
    });
  }
  Stream<List<Poll>> get allPolls => dbService.polls;

  Stream<List<Poll>> get activePolls => allPolls.map(
        (polls) {
          final List<Poll> list = [];
          for (Poll poll in polls) {
            if (poll.votingDeadlineDate.isAfter(DateTime.now())) {
              list.add(poll);
            }
          }
          return list;
        },
      );

  Stream<List<Poll>> get completedPolls => allPolls.map(
        (polls) {
          final List<Poll> list = [];
          for (Poll poll in polls) {
            if (poll.votingDeadlineDate.isBefore(DateTime.now())) {
              list.add(poll);
            }
          }
          return list;
        },
      );

  Stream<List<Poll>> get pollsIVotedIn => Rx.combineLatest3(
        allPolls,
        dbService.votesMap,
        dbService.myPersonId,
        (List<Poll> polls, Map<String, List<Vote>> votesMap, String meId) {
          final List<Poll> list = [];
          for (Poll poll in polls) {
            final votes = votesMap[poll.pollId];
            if (votes != null) {
              for (Vote vote in votes) {
                if (vote.votingPersonId == meId) {
                  list.add(poll);
                  break;
                }
              }
            }
          }
          list.sort();
          return list;
        },
      );

  Stream<List<Poll>> get pollsIHaveNoteVotedIn => Rx.combineLatest3(
        allPolls,
        dbService.votesMap,
        dbService.myPersonId,
        (List<Poll> polls, Map<String, List<Vote>> votesMap, String meId) {
          final List<Poll> list = [];
          list.addAll(polls);
          for (Poll poll in polls) {
            final votes = votesMap[poll.pollId];
            if (votes != null) {
              for (Vote vote in votes) {
                if (vote.votingPersonId == meId) {
                  list.remove(poll);
                  break;
                }
              }
            }
          }
          list.sort();
          return list;
        },
      );
}
