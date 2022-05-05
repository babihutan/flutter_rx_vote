import 'package:flutter/material.dart';
import '../data/person.dart';
import '../data/poll_result.dart';

class PollResultsList extends StatelessWidget {
  final Stream<List<PollResult>> resultsStream;
  final String title;
  const PollResultsList(this.resultsStream, {required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PollResult>>(
      stream: resultsStream,
      builder: (context, resultsListSnap) {
        if (!resultsListSnap.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 16),
            child: Text(
              'Loading $title ...',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.only(top: 16),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (resultsListSnap.data!.isEmpty) const Text('No poll results'),
              for (PollResult pr in resultsListSnap.data!)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pr.poll.name,
                          style: TextStyle(fontWeight: FontWeight.w600, color:Theme.of(context).colorScheme.primary)),
                      for (int i = 0; i < pr.poll.answers.length; i++)
                        PollResultAnswer(pr.poll.answers[i], pr.votes[i]),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PollResultAnswer extends StatelessWidget {
  final List<Person> voters;
  final String answer;
  const PollResultAnswer(this.answer, this.voters, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 16, child: Text('${voters.length}')),
                Text(answer),
              ],
            ),
            for (Person voter in voters)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width:16),
                  const SizedBox(width:16, child:Text("\u2022 ")),
                  Text(voter.name),
                ],
              ),
          ]),
    );
  }
}
