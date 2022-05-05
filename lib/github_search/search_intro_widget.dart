import 'package:flutter/material.dart';

/*
From ReactiveX / rxdart,  commit 5c766c53f1b17abb272ce7bd423c610d31aecc31
https://github.com/ReactiveX/rxdart/tree/master/example/flutter/github_search/lib
*/

class SearchIntro extends StatelessWidget {
  const SearchIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.info, color: Colors.green[200], size: 80.0),
          Container(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Enter a search term to begin',
              style: TextStyle(
                color: Colors.green[100],
              ),
            ),
          )
        ],
      ),
    );
  }
}