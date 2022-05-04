import 'package:flutter/material.dart';

class ColorSearchService {
  final _colors = [
    ColorInfo(Colors.red, "red"),
    ColorInfo(Colors.blue, "blue"),
    ColorInfo(Colors.indigo, "indigo blue"),
    ColorInfo(Colors.pink, 'pink'),
    ColorInfo(Colors.pinkAccent, 'nice pink')
  ];

  Stream<List<ColorInfo>> search(String searchTerm) async* {
    debugPrint('[color_search_service] search entry, search=$searchTerm');
    final List<ColorInfo> results = [];
    for (ColorInfo ci in _colors) {
      if (ci.colorName.toLowerCase().contains(searchTerm.toLowerCase())) {
        results.add(ci);
      }
    }
    if (searchTerm.toLowerCase().contains('pi')) {
      await Future.delayed(const Duration(milliseconds: 4000));
    } else if (searchTerm.toLowerCase().contains('blue')) {
      await Future.delayed(const Duration(milliseconds: 2000));
    } else {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    debugPrint(
        '[color_search_service] found ${results.length} results for search term $searchTerm');
    yield results;
  }
}

class ColorInfo {
  final Color color;
  final String colorName;
  ColorInfo(this.color, this.colorName);
}
