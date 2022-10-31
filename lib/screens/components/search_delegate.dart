import 'package:flutter/material.dart';
import 'package:petani_film_v2/screens/search_screen/search_screen.dart';
import 'package:petani_film_v2/services/hive_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    String hintText = "Cari Film / Series",
  }) : super(
          searchFieldLabel: hintText,
          searchFieldDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              color: Constants.whiteColor.withOpacity(0.7),
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        color: Constants.blackColor,
        elevation: 0,
      ),
    );
  }

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty) return close(context, null);
    saveSearchHistory(query);
    super.showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        color: Constants.whiteColor,
        onPressed: () {
          if (query.isEmpty) return close(context, null);
          showResults(context);
        },
        icon: const Icon(
          Icons.search,
          color: Constants.whiteColor,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        color: Constants.whiteColor,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchScreen(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];
    List<String> suggestionList = query.isEmpty
        ? suggestions
        : suggestions
            .where((p) => p.contains(RegExp(query, caseSensitive: false)))
            .toList();
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
          future: getSearchSuggestion(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              suggestions = snapshot.data ?? [];
              suggestionList = query.isEmpty
                  ? suggestions
                  : suggestions
                      .where((p) =>
                          p.contains(RegExp(query, caseSensitive: false)))
                      .toList();
            }
            return ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(suggestionList[index]),
                  onTap: () {
                    query = suggestionList[index];
                    showResults(context);
                  },
                  trailing: IconButton(
                      color: Constants.whiteColor,
                      icon: const Icon(Icons.highlight_remove_rounded),
                      onPressed: () {
                        suggestionList.removeAt(index);
                        deleteSearchHistory(suggestionList.length - index);
                        setState(() {});
                      }),
                );
              },
            );
          });
    });
  }

  Future<List<String>> getSearchSuggestion() async {
    return List<String>.from(await HiveService().getBoxValues('search_history'))
        .reversed
        .toList();
  }

  Future<void> saveSearchHistory(item) async {
    try {
      await HiveService().addBoxes(items: [item], boxName: 'search_history');
    } catch (_) {}
  }

  Future<void> deleteSearchHistory(index) async {
    try {
      await HiveService().deleteIndex(index: index, boxName: 'search_history');
    } catch (_) {}
  }
}
