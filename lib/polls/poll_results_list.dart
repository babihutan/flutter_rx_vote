import 'package:flutter/material.dart';
import 'poll_result.dart';

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
          return Text('Loading $title ...');
        }
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (resultsListSnap.data!.isEmpty) const Text('No poll results'),
              for (PollResult pr in resultsListSnap.data!)
                Column(
                  children: [
                    Text(pr.poll.name),
                    for (int i = 0; i < pr.poll.answers.length; i++)
                      Text('${pr.poll.answers[i]}: ${pr.voteCounts[i]}'),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
