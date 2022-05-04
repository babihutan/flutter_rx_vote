import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/poll.dart';

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
          return Text('Loading $title ...');
        }
        return Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            for(Poll poll in pollListSnap.data!) Text(poll.name),
          ]
        );
      },
    );
  }
}
