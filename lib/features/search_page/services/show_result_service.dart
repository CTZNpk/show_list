import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_list/features/search_page/services/search_bar_screen.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/enums/show_type.dart';

class ShowResultService {
  ShowResultService({
    required this.context,
    required this.ref,
  });

  BuildContext context;
  WidgetRef ref;

  Future<String?> showSearchDelegate({
    required ShowType showType,
    required ScrollController controller,
   required FilterSearchWrapper filterSearch, 
  }) async {
    controller.jumpTo(0);
    final searchText = await showSearch(
      context: context,
      delegate: SearchBarScreen(
        onSearchChanged: _getRecentSearchesLike,
        showType: showType,
        filterSearch: filterSearch,
      ),
    );
    if(filterSearch.isFilterSearch){
      return  searchText;
    }
    _saveToRecentSearches(searchText, showType);
    return searchText;
  }

  Future<List<String>> _getRecentSearchesLike(
      String query, ShowType showType) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches =
        pref.getStringList('recentSearches${showType.toString()}');
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future _saveToRecentSearches(String? searchText, ShowType showType) async {
    if (searchText == null) return;
    final pref = await SharedPreferences.getInstance();

    Set<String> allSearches =
        pref.getStringList('recentSearches${showType.toString()}')?.toSet() ??
            {};

    allSearches = {searchText, ...allSearches};
    pref.setStringList(
      "recentSearches${showType.toString()}",
      allSearches.toList(),
    );
  }
}
