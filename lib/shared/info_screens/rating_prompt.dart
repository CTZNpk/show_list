import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/features/my_list/controller/my_list_controller.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/add_to_watchlist_prompt.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class RatePrompt extends ConsumerStatefulWidget {
  static const routeName = '/rate-prompt';

  const RatePrompt({
    super.key,
    required this.data,
    required this.showType,
  });

  final dynamic data;
  final ShowType showType;

  @override
  ConsumerState<RatePrompt> createState() => _RatePrompt();
}

class _RatePrompt extends ConsumerState<RatePrompt> {
  late PageController _pageController;
  int ratingNow = 1;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0, // Start with the middle rating (5).
      viewportFraction: 0.25, // Adjust this value for spacing between ratings.
    );
    _pageController.addListener(() {
      setState(() {
        widget.data.userRating = ratingNow = _pageController.page!.round() + 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Rate ${widget.data.title}',
        style: myTheme.textTheme.displayMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: size.width * 0.66,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: const CustomPageViewScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final rating = index + 1;
                return Center(
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: ratingNow == rating
                          ? myTheme.colorScheme.primary
                          : Colors.grey[700],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        rating.toString(),
                        style: TextStyle(
                          color:
                              ratingNow == rating ? Colors.white : Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const VerticalSpacing(20),
          Text(
            'Rating : $ratingNow ',
            style: myTheme.textTheme.labelLarge,
          ),
        ],
      ),
      actions: [
        MyElevatedButton(
          label: 'DONE',
          labelIcon: Icons.done,
          imageUrl: null,
          backgroundColor: Colors.indigo[900]!,
          onPressed: () {
            if (widget.showType == ShowType.anime) {
              ref
                  .read(myListControllerProvider)
                  .addToWatchList(animeData: widget.data);
            } else {
              ref
                  .read(myListControllerProvider)
                  .addToWatchList(movieShowData: widget.data);
            }
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
