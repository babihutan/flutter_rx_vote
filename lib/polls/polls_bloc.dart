import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../data/db_service.dart';
import '../data/person.dart';
import '../data/poll.dart';
import '../data/poll_result.dart';
import '../data/vote.dart';

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

  //Alternatively we can use activePolls and all polls and 
  //use sets to get the outer
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

  //Alternatively we can use activePolls and polls i have voted in and 
  //use sets to get the outer
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
          debugPrint('[polls_bloc] polls i have not voted in entry');
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

  Stream<List<PollResult>> get allPollResults => Rx.combineLatest3(
        allPolls,
        dbService.votesMap,
        dbService.personsMap,
        (List<Poll> polls, Map<String, List<Vote>> votesMap,
            Map<String, Person> personsMap) {
          debugPrint('[polls_bloc] all poll results entry');
          final List<PollResult> list = [];
          for (Poll poll in polls) {
            final voteList = votesMap[poll.pollId];
            final votes = List.generate(
                poll.answers.length, (i) => List<Person>.empty(growable: true));
            if (voteList != null) {
              for (Vote vote in voteList) {
                final person = personsMap[vote.votingPersonId];
                if (person != null) {
                  final list = votes[vote.answerIndex];
                  list.add(person);
                  votes[vote.answerIndex] = list;
                }
              }
            }
            list.add(PollResult(poll, votes));
          }
          list.sort();
          return list;
        },
      );

  dispose() {
    debugPrint('[polls_bloc] dispose');
  }
}
