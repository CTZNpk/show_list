import 'package:flutter/material.dart';
import 'package:show_list/features/search_page/widgets/display_filters.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/enums/genres.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class SearchBarScreen extends SearchDelegate<String> {
  SearchBarScreen({
    super.searchFieldLabel,
    required this.onSearchChanged,
    required this.showType,
    required this.filterSearch,
  });

  final Function onSearchChanged;
  final ShowType showType;
  FilterSearchWrapper filterSearch;
  List<String> _oldFilters = const [];
  List<GenresMovie> selectedGenres = [];

  void openFilterDialogue(
      BuildContext context, FilterSearchWrapper filterSearch) async {
    Navigator.pushNamed(
      context,
      DisplayFilters.routeName,
      arguments: [filterSearch, close, showType],
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myTheme = Theme.of(context);
    return Column(
      children: [
        showType != ShowType.anime
            ? MyElevatedButton(
                backgroundColor: Colors.indigo[900]!,
                label: 'Custom Filters',
                labelIcon: Icons.filter_alt,
                imageUrl: null,
                onPressed: () => openFilterDialogue(context, filterSearch),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: FutureBuilder<List<String>>(
            future: onSearchChanged(query, showType),
            builder: (context, snapshot) {
              if (snapshot.hasData) _oldFilters = snapshot.data!;
              return ListView.builder(
                itemCount: _oldFilters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.restore),
                    title: Text(
                      _oldFilters[index],
                      style: myTheme.textTheme.displayMedium,
                    ),
                    tileColor: index % 2 == 1
                        ? myTheme.scaffoldBackgroundColor
                        : myTheme.colorScheme.secondary,
                    onTap: () => close(context, _oldFilters[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
