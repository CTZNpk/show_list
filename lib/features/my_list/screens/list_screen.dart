import 'package:flutter/material.dart';
import 'package:show_list/features/my_list/widgets/display_list_tabs.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context).copyWith(primaryColor: Colors.teal[400]);
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            indicatorColor: myTheme.primaryColor,
            labelColor: myTheme.primaryColor,
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
            controller: _controller,
              children: const [
                DisplayListTabs(
                  showType: ShowType.movie,
                ),
                DisplayListTabs(
                  showType: ShowType.show,
                ),
                DisplayListTabs(
                  showType: ShowType.anime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
