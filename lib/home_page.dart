import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/db_service.dart';
import 'package:flutter_rx_vote/person_data.dart';
import 'package:flutter_rx_vote/signup_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
                    builder: (context) => SignupPage(),
                  ),
                );
              },
              child: const Text('Add Person'),
            )
          ],
        ),
      ),
    );
  }
}
