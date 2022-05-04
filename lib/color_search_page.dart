import 'package:flutter/material.dart';
import 'package:flutter_rx_vote/color_search_bloc.dart';

class ColorSearchPage extends StatelessWidget {
  ColorSearchPage({Key? key}) : super(key: key);
  final ColorSearchBloc _colorSearchBloc = ColorSearchBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Search'),
      ),
      body: Column(
        children: [
          _searchText(context),
        ],
      ),
    );
  }

  Widget _searchText(BuildContext context) {
        return StreamBuilder(
      stream: _colorSearchBloc.searchText,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _colorSearchBloc.changeSearchText,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Blue',
            labelText: 'Search Text',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
          ),
        );
      },
    );
  }
}
