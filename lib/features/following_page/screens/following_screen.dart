import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/following_page/controller/following_page_controller.dart';
import 'package:show_list/features/following_page/screens/people_search_page.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  const FollowingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  late DateTime nowTime;
  List<FollowingStringModel> followingData = [];

  Future<String?> showSearchDelegate() async {
    final searchText = await showSearch(
      context: context,
      delegate: PeopleSearchPage(ref: ref),
    );
    return searchText;
  }

  String toDisplayString(
      DateTime time, PlanType planType, String userName, String title) {
    String difference;
    String start;
    int durationDiff = time.difference(nowTime).inDays;
    if (durationDiff > -1) {
      difference = 'Today';
    } else if (durationDiff > -2) {
      difference = 'Yesterday';
    } else if (durationDiff > -7) {
      durationDiff = -durationDiff;
      difference = '$durationDiff days ago';
    } else {
      difference = 'more than week ago';
    }
    if (planType == PlanType.planToWatch) {
      start = '$userName planned to watch $title';
    } else if (planType == PlanType.watching) {
      start = '$userName started watching $title';
    } else {
      start = '$userName watched $title';
    }
    return '$start $difference';
  }

  @override
  void initState() {
    nowTime = DateTime.now();
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
              reverse: true,
              itemCount: followingData.length,
              itemBuilder: (context, index) {
                int ratingCount = followingData[index].userRating != null
                    ? (followingData[index].userRating! / 2).round().toInt()
                    : 0;
                String toDisplay = toDisplayString(
                    followingData[index].dataDate,
                    followingData[index].planType,
                    followingData[index].userName,
                    followingData[index].title);
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: const Color.fromRGBO(1, 63, 66, 1),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            toDisplay,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        followingData[index].planType == PlanType.finished
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${followingData[index].userRating} / 10',
                                  ),
                                  const HorizontalSpacing(10),
                                  SizedBox(
                                    height: 25,
                                    width: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: ratingCount,
                                      itemBuilder: (context, index) {
                                        return Icon(
                                          Icons.star,
                                          size: 10,
                                          color: Colors.lime[900],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
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
