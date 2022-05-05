import 'package:flutter/material.dart';

/*
From ReactiveX / rxdart,  commit 5c766c53f1b17abb272ce7bd423c610d31aecc31
https://github.com/ReactiveX/rxdart/tree/master/example/flutter/github_search/lib
*/

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      child: const CircularProgressIndicator(),
    );
  }
}