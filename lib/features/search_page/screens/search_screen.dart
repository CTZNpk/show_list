import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends ConsumerState<SearchScreen>
    with TickerProviderStateMixin {
  late TabController tabBarController;

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
        children: [
          TabBar(
            controller: tabBarController,
            indicatorColor: myTheme.colorScheme.primary,
            labelColor: myTheme.colorScheme.primary,
            unselectedLabelColor: myTheme.colorScheme.onSurface,
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
          const VerticalSpacing(10),
          Expanded(
            child: TabBarView(
              controller: tabBarController,
              children: const [
                DisplaySearchResults(
                  showType: ShowType.movie,
                ),
                DisplaySearchResults(
                  showType: ShowType.show,
                ),
                DisplaySearchResults(
                  showType: ShowType.anime,
                ),
              ],
            ),
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
