import 'package:flutter/foundation.dart';
import 'package:flutter_rx_vote/color_search_service.dart';
import 'package:rxdart/rxdart.dart';

class ColorSearchBloc {
  final ColorSearchService _colorSearchService = ColorSearchService();

  ColorSearchBloc() {
    debugPrint('[color_search_bloc] ctor');

    //searchText.switchMap((i) => TimerStream(i, const Duration(seconds: 2))).listen(debugPrint);

  searchText.switchMap((query) async* {
    debugPrint('searching: $query');
    yield await _colorSearchService.search(query);
  }); 

    // searchText.debounce((String search) =>
    //     TimerStream(true, const Duration(milliseconds: 500)).switchMap((value) {
    //       debugPrint('debounc=>switchmap, str=$search');
    //     }));

    // _searchTextSubject.debounce(Duration(milliseconds: 500)).switchMap((filter) async* {
    //   yield await _colorSearchService.search(searchTerm);
    // }).listen((event) { })

    // _searchTextSubject
    //     //.debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
    //     .switchMap((search) async* {
    //   debugPrint('[color_search_bloc] post switch map, term=$search');
    //   yield await _colorSearchService.search(search);
    // });
    // _searchTextSubject.stream.listen((event) {
    //   debugPrint('[color_search_bloc] term=$event');
    // });
  }

  final _searchTextSubject = BehaviorSubject<String>();

  Stream<String> get searchText => _searchTextSubject.stream;

  Function(String) get changeSearchText => _searchTextSubject.sink.add;

  late Stream<List<ColorInfo>> _results;
  Stream<List<ColorInfo>> get results => _results;

  dispose() {
    debugPrint('[color_search_bloc] dispose');
    _searchTextSubject.close();
  }
}
