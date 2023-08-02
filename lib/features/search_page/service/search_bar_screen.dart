import 'package:flutter/material.dart';
import 'package:show_list/shared/enums/show_type.dart';

class SearchBarScreen extends SearchDelegate<String> {
  static const routeName = '/search-bar-screen';

  SearchBarScreen({
    super.searchFieldLabel,
    required this.onSearchChanged,
    required this.showType,
  });

  final Function onSearchChanged;
  final ShowType showType;
  List<String> _oldFilters = const [];

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
    return FutureBuilder<List<String>>(
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
              tileColor: index % 2 == 1? myTheme.scaffoldBackgroundColor: myTheme.colorScheme.secondary,
              onTap: () => close(context, _oldFilters[index]),
            );
          },
        );
      },
    );
  }
}
