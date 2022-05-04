import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/color_search_service.dart';
import 'package:rxdart/rxdart.dart';

class ColorSearchBloc {
  final ColorSearchService _colorSearchService = ColorSearchService();

  ColorSearchBloc() {
    debugPrint('[color_search_bloc] ctor');

    //searchText.switchMap((i) => TimerStream(i, const Duration(seconds: 2))).listen(debugPrint);

    // searchText.switchMap((query) async* {
    //   debugPrint('searching: $query');
    //   yield await _colorSearchService.search(query);
    // });

    // searchText.debounce((String search) =>
    //     TimerStream(true, const Duration(milliseconds: 500)).switchMap((value) {
    //       debugPrint('debounc=>switchmap, str=$search');
    //     }));

    // _searchTextSubject.debounce(Duration(milliseconds: 500)).switchMap((filter) async* {
    //   yield await _colorSearchService.search(searchTerm);
    // }).listen((event) { })

    _results = _searchTextSubject
        // If the text has not changed, do not perform a new search
        //.distinct()
        // Wait for the user to stop typing for 250ms before running a search
        //.debounceTime(const Duration(milliseconds: 250))
        // Call the Github api with the given search term and convert it to a
        // State. If another search term is entered, switchMap will ensure
        // the previous search is discarded so we don't deliver stale results
        // to the View.
        .switchMap((String term) => _colorSearchService.search(term));


    // _results = _searchTextSubject.debounce((_) {
    //   debugPrint('debounce');
    //   return TimerStream(true, const Duration(milliseconds: 500));
    // }).switchMap((search) async* {
    //   yield await _colorSearchService.search(search);
    // });
    // _searchTextSubject.stream.listen((event) {
    //   debugPrint('[color_search_bloc] term=$event');
    // });
  }

  final _searchTextSubject = PublishSubject<String>();

  Stream<String> get searchText => _searchTextSubject.stream;

  Function(String) get changeSearchText => _searchTextSubject.sink.add;

  late Stream<List<ColorInfo>> _results;
  Stream<List<ColorInfo>> get results => _results;

  dispose() {
    debugPrint('[color_search_bloc] dispose');
    _searchTextSubject.close();
  }
}
