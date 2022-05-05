import 'package:flutter/material.dart';
import 'data/db_service.dart';
import 'data/person.dart';
import 'signup/signup_page.dart';
import 'github_search/github_api.dart';
import 'polls/polls_page.dart';
import 'github_search/search_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RxDart Fun'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Me:'),
            StreamBuilder<Person?>(
              stream: dbService.me,
              builder: (context, meSnap) {
                if (!meSnap.hasData || meSnap.data == null) {
                  return const Text('No data');
                }
                return Text(meSnap.data!.name);
              },
            ),
            const Text('Everyone:'),
            StreamBuilder<List<Person>>(
              stream: dbService.persons,
              builder: (context, personsSnap) {
                if (!personsSnap.hasData) {
                  return const Text('No data');
                }
                return Column(
                  children: [
                    for(Person p in personsSnap.data!) Text(p.name),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupPage(),
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
                    builder: (context) => const PollsPage(),
                  ),
                );
              },
              child: const Text('Polls'),
            ),
            TextButton(
              onPressed: () {
                final api = GithubApi();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(api: api),
                  ),
                );
              },
              child: const Text('Github search'),
            )
          ],
        ),
      ),
    );
  }
}
