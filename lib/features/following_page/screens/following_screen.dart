import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/following_page/controller/following_page_controller.dart';
import 'package:show_list/features/following_page/screens/people_search_page.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  const FollowingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  Future<String?> showSearchDelegate() async {
    final searchText = await showSearch(
      context: context,
      delegate: PeopleSearchPage(ref: ref),
    );
    return searchText;
  }

  List<FollowingStringModel> followingData = [];

  @override
  void initState() {
    ref
        .read(followingPageControllerProvider)
        .getFollowingDataFromSql()
        .then((value) {
      setState(() {
        followingData = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          MyElevatedButton(
            label: 'Search For People',
            labelIcon: Icons.search,
            imageUrl: null,
            backgroundColor: Colors.cyan[900]!,
            onPressed: () => showSearchDelegate(),
          ),
          const VerticalSpacing(10),
          Expanded(
            child: ListView.builder(
              itemCount: followingData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                    color: Colors.grey[800]!,
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(followingData[index].followingData),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
