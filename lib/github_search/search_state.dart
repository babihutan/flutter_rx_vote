import 'github_api.dart';

/*
From ReactiveX / rxdart,  commit 5c766c53f1b17abb272ce7bd423c610d31aecc31
https://github.com/ReactiveX/rxdart/tree/master/example/flutter/github_search/lib
*/


// The State represents the data the View requires. The View consumes a Stream
// of States. The view rebuilds every time the Stream emits a new State!
//
// The State Stream will emit new States depending on the situation: The
// initial state, loading states, the list of results, and any errors that
// happen.
//
// The State Stream responds to input from the View by accepting a
// Stream<String>. We call this Stream the onTextChanged "intent".
abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {}

class SearchNoTerm extends SearchState {}

class SearchPopulated extends SearchState {
  final SearchResult result;
  SearchPopulated(this.result);
}

class SearchEmpty extends SearchState {}
