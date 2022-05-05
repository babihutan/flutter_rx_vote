import 'package:flutter/material.dart';
import 'poll_results_list.dart';
import 'polls_bloc.dart';
import 'polls_list.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({Key? key}) : super(key: key);
  @override
  createState() => _PollsPageState();
} 

class _PollsPageState extends State<PollsPage> {

  late PollsBloc _pollsBloc;

  @override
  void initState() {
    super.initState();
    _pollsBloc = PollsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pollsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PollsList(_pollsBloc.allPolls, title: 'All polls'),
            PollResultsList(_pollsBloc.allPollResults, title: 'All poll results'),
            PollsList(_pollsBloc.activePolls, title: 'Active polls'),
            PollsList(_pollsBloc.completedPolls, title: 'Completed Polls'),
            PollsList(_pollsBloc.pollsIVotedIn, title: 'Polls I have voted in'),
            PollsList(_pollsBloc.pollsIHaveNoteVotedIn,
                title: 'Polls I have not voted in'),
          ],
        ),
      ),
    );
  }
}
