import 'package:flutter/material.dart';
import '../data/poll.dart';

class PollsList extends StatelessWidget {
  final Stream<List<Poll>> pollsStream;
  final String title;
  const PollsList(this.pollsStream, {required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Poll>>(
      stream: pollsStream,
      builder: (context, pollListSnap) {
        if (!pollListSnap.hasData) {
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
          child: Column(children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (pollListSnap.data!.isEmpty) const Text('No polls'),
            for (Poll poll in pollListSnap.data!) Text(poll.name),
          ]),
        );
      },
    );
  }
}
