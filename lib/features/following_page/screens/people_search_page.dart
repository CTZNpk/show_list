import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/following_page/controller/following_page_controller.dart';
import 'package:show_list/features/profile_page/screens/profile_screen.dart';
import 'package:show_list/shared/model/short_profile_model.dart';

class PeopleSearchPage extends SearchDelegate<String> {
  PeopleSearchPage({required this.ref});

  WidgetRef ref;

  List<ShortProfileModel> _oldFilters = const [];

  Future<List<ShortProfileModel>> getResults() async {
    final response =
        await ref.read(followingPageControllerProvider).searchPeople(query);
    return response;
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
        Expanded(
          child: FutureBuilder<List<ShortProfileModel>>(
            future: getResults(),
            builder: (context, snapshot) {
              if (snapshot.hasData) _oldFilters = snapshot.data!;
              return ListView.builder(
                itemCount: _oldFilters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        _oldFilters[index].profilePic,
                      ),
                    ),
                    title: Text(
                      _oldFilters[index].userName,
                      style: myTheme.textTheme.displayMedium,
                    ),
                    tileColor: index % 2 == 1
                        ? myTheme.scaffoldBackgroundColor
                        : myTheme.colorScheme.secondary,
                    onTap: () => Navigator.popAndPushNamed(
                        context, ProfileScreen.routeName,
                        arguments: [_oldFilters[index].uid]),
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
