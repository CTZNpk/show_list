import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_list/features/search_page/service/search_bar_screen.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> with TickerProviderStateMixin {
  late TabController tabBarController;

  Future<void> _showSearch(ShowType showType) async {
    final searchText = await showSearch(
      context: context,
      delegate: SearchBarScreen(
        onSearchChanged: _getRecentSearchesLike,
        showType: showType,
      ),
    );
    await _saveToRecentSearches(searchText, showType);
  }

  Future<List<String>> _getRecentSearchesLike(
      String query, ShowType showType) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches =
        pref.getStringList('recentSearches${showType.toString()}');
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToRecentSearches(
      String? searchText, ShowType showType) async {
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

  @override
  void initState() {
    tabBarController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: tabBarController,
            indicatorColor: myTheme.colorScheme.primary,
            labelColor: myTheme.colorScheme.primary,
            unselectedLabelColor: myTheme.colorScheme.onSurface,
            onTap: (value) => print(value),
            tabs: const [
              Tab(
                text: 'Movies',
                icon: Icon(Icons.movie),
              ),
              Tab(
                text: 'Shows',
                icon: Icon(Icons.tv),
              ),
              Tab(
                text: 'Anime',
                icon: Icon(Icons.web),
              ),
            ],
          ),
          const VerticalSpacing(20),
          Text(
            'Search for Movie', //TODO add name according to tab
            style: myTheme.textTheme.displayLarge,
          ),
          const VerticalSpacing(30),
          MyElevatedButton(
            label: 'Search',
            labelIcon: Icons.search,
            imageUrl: null,
            onPressed: () => _showSearch(ShowType.movie),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}
