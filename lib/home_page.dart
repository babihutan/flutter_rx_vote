import 'package:flutter/material.dart';
import 'db_service.dart';
import 'person_data.dart';
import 'signup_page.dart';
import 'github_api.dart';
import 'polls_page.dart';
import 'search_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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