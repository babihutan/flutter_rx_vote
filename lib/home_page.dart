import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/color_search_page.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/person_data.dart';
import 'package:flutter_rx_vote/polls_bloc.dart';
import 'package:flutter_rx_vote/polls_list.dart';
import 'package:flutter_rx_vote/signup_page.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final PollsBloc _pollsBloc = PollsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<Person?>(
              stream: dbService.me,
              builder: (context, meSnap) {
                if (!meSnap.hasData || meSnap.data == null) {
                  return const Text('No data');
                }
                return Text('Me: ${meSnap.data!.name}');
              },
            ),
            StreamBuilder<List<Person>>(
              stream: dbService.persons,
              builder: (context, personsSnap) {
                if (!personsSnap.hasData) {
                  return const Text('No data');
                }
                return Text('${personsSnap.data!.length} persons');
              },
            ),
            PollsList(_pollsBloc.allPolls, title: 'All polls'),
            PollsList(_pollsBloc.activePolls, title: 'Active polls'),
            PollsList(_pollsBloc.completedPolls, title: 'Completed Polls'),
            PollsList(_pollsBloc.pollsIVotedIn, title: 'Polls I have voted in'),
            PollsList(_pollsBloc.pollsIHaveNoteVotedIn,
                title: 'Polls I have not voted in'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(),
                  ),
                );
              },
              child: const Text('Add Person'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ColorSearchPage(),
                  ),
                );
              },
              child: const Text('Color Search'),
            )
          ],
        ),
      ),
    );
  }
}
