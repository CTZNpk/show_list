import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class ShowAddToWatchlistPrompt extends ConsumerStatefulWidget {
  static const routeName = '/show-add-to-watchlist-prompt';

  const ShowAddToWatchlistPrompt({
    super.key,
    required this.showType,
    required this.data,
  });

  final ShowType showType;
  final dynamic data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowAddToWatchlistPromptState();
}

class _ShowAddToWatchlistPromptState
    extends ConsumerState<ShowAddToWatchlistPrompt>
    with TickerProviderStateMixin {
  late TabController _tabBarController;

  @override
  void initState() {
    _tabBarController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(
        child: Text(
          'Select a list ',
          style: myTheme.textTheme.displayLarge,
        ),
      ),
      content: SizedBox(
        height: 250,
        width: size.width * 0.6,
        child: Column(
          children: [
            TabBar(
              controller: _tabBarController,
              indicatorColor: myTheme.colorScheme.primary,
              labelColor: myTheme.colorScheme.primary,
              unselectedLabelColor: myTheme.colorScheme.onSurface,
              tabs: const [
                Tab(
                  icon: Icon(Icons.watch_later),
                ),
                Tab(
                  icon: Icon(Icons.remove_red_eye),
                ),
                Tab(
                  icon: Icon(Icons.done),
                )
              ],
            ),
            const VerticalSpacing(20),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabBarController,
                children: [
                  _PlanToWatch(data: widget.data),
                  _Watching(data: widget.data),
                  _Finished(data: widget.data),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        MyElevatedButton(
          label: 'OK ',
          labelIcon: Icons.done,
          backgroundColor: Colors.indigo[900]!,
          imageUrl: null,
          onPressed: () {
            _tabBarController.index == 0
                ? widget.data.planType = PlanType.planToWatch
                : _tabBarController.index == 1
                    ? widget.data.planType = PlanType.watching
                    : widget.data.planType = PlanType.finished;
            if (widget.data.planType == PlanType.finished) {
              widget.data.episodesWatched = widget.data.numOfEpisodes;
            }
            if (widget.showType == ShowType.anime) {
              ref
                  .read(mainLayoutControllerProvider)
                  .addToAnimeList(widget.data);
            } else if (widget.showType == ShowType.movie) {
              ref
                  .read(mainLayoutControllerProvider)
                  .addToMovieList(widget.data);
            } else {
              ref.read(mainLayoutControllerProvider).addToShowList(widget.data);
            }
            Navigator.pop(context);
          },
        ),
        MyElevatedButton(
          label: 'Cancel ',
          labelIcon: Icons.cancel,
          backgroundColor: Colors.indigo[900]!,
          imageUrl: null,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }
}

class _PlanToWatch extends StatelessWidget {
  const _PlanToWatch({
    required this.data,
  });

  final dynamic data;
  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Center(
      child: Text(
        'Press OK to add ${data.title} to plan to watch list?',
        style: myTheme.textTheme.displayLarge,
      ),
    );
  }
}

class _Watching extends StatefulWidget {
  const _Watching({
    required this.data,
  });

  final dynamic data;

  @override
  State<_Watching> createState() => _WatchingState();
}

class _WatchingState extends State<_Watching> {
  late PageController _pageController;
  int epsWatched = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0, // Start with the middle rating (5).
      viewportFraction: 0.25, // Adjust this value for spacing between ratings.
    );
    _pageController.addListener(
      () {
        setState(
          () {
            widget.data.episodesWatched =
                epsWatched = _pageController.page!.round() + 1;
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            'Press OK to add ${widget.data.title} to watching list?',
            style: myTheme.textTheme.displayLarge,
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                width: size.width * 0.66,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.data.numOfEpisodes - 1,
                  scrollDirection: Axis.horizontal,
                  physics: const CustomPageViewScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final rating = index + 1;
                    return Center(
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: epsWatched == rating
                              ? myTheme.colorScheme.primary
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            rating.toString(),
                            style: TextStyle(
                              color: epsWatched == rating
                                  ? Colors.white
                                  : Colors.black,
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
                'Episodes Watched : $epsWatched',
                style: myTheme.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 1,
        damping: 100,
      );
}

class _Finished extends StatefulWidget {
  const _Finished({
    required this.data,
  });

  final dynamic data;

  @override
  State<_Finished> createState() => _FinishedState();
}

class _FinishedState extends State<_Finished> {
  late PageController _pageController;
  int userRating = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0, // Start with the middle rating (5).
      viewportFraction: 0.25, // Adjust this value for spacing between ratings.
    );
    _pageController.addListener(
      () {
        if (context.mounted) {
          setState(
            () {
              widget.data.userRating =
                  userRating = _pageController.page!.round() + 1;
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Text(
            'Press OK to add ${widget.data.title} to finished list?',
            style: myTheme.textTheme.displayLarge,
          ),
        ),
        SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          color: userRating == rating
                              ? myTheme.colorScheme.primary
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            rating.toString(),
                            style: TextStyle(
                              color: userRating == rating
                                  ? Colors.white
                                  : Colors.black,
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
                'Rating : $userRating',
                style: myTheme.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
