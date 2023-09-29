import 'package:dialogs/dialogs/choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/features/main_layout/repository/main_layout_repository.dart';
import 'package:show_list/features/my_list/controller/my_list_controller.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/info_screens/rating_prompt.dart';
import 'package:show_list/shared/loading.dart';

class DisplayListTabs extends ConsumerStatefulWidget {
  const DisplayListTabs({super.key, required this.showType});
  final ShowType showType;

  @override
  ConsumerState<DisplayListTabs> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<DisplayListTabs>
    with TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    tabBarController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context).copyWith(primaryColor: Colors.teal[400]);
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: tabBarController,
            labelColor: myTheme.colorScheme.onSurface,
            unselectedLabelColor: myTheme.colorScheme.onSurface,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: myTheme.primaryColor),
            tabs: const [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.watch_later),
                      Text("To Watch"),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.remove_red_eye),
                      Text("Watching"),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.done),
                      Text("Finished"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const VerticalSpacing(10),
          Expanded(
            child: TabBarView(
              controller: tabBarController,
              children: [
                _ListDisplay(
                    planType: PlanType.planToWatch, showType: widget.showType),
                _ListDisplay(
                    planType: PlanType.watching, showType: widget.showType),
                _ListDisplay(
                    planType: PlanType.finished, showType: widget.showType),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListDisplay extends ConsumerStatefulWidget {
  const _ListDisplay({required this.planType, required this.showType});
  final ShowType showType;
  final PlanType planType;

  @override
  ConsumerState<_ListDisplay> createState() => __ListDisplayState();
}

class __ListDisplayState extends ConsumerState<_ListDisplay> {
  Future<Map<String, dynamic>> getData() async {
    return ref
        .watch(mainLayoutControllerProvider)
        .getDataFromAPlanType(widget.showType, widget.planType);
  }

  void rebuildingWidget() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(mainLayoutRepositoryProvider).addListener(rebuildingWidget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const LoadingScreen();
        }
        List entryList = snapshot.data!.values.toList();
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemCount: entryList.length,
            itemBuilder: (context, index) {
              return _DisplayTile(
                data: entryList[index],
                showType: widget.showType,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    ref.watch(mainLayoutRepositoryProvider).removeListener(rebuildingWidget);
    super.dispose();
  }
}

class _DisplayTile extends ConsumerStatefulWidget {
  const _DisplayTile({
    required this.data,
    required this.showType,
  });

  final dynamic data;
  final ShowType showType;

  @override
  ConsumerState<_DisplayTile> createState() => _DisplayTileState();
}

class _DisplayTileState extends ConsumerState<_DisplayTile> {
  late ChoiceDialog choiceDialog;

  void changingState() {
    setState(() {});
  }

  void showDialogeWhenPlanTypeChanges(
      BuildContext context, PlanType planType, int changeIfOk) async {
    choiceDialog = ChoiceDialog(
      title:
          'Do you want to move ${widget.data.title} to ${planType.name} list?',
      titleColor: Theme.of(context).colorScheme.onSurface,
      message:
          'Click OK if you want to move ${widget.data.title} to ${planType.name}',
      messageColor: Theme.of(context).colorScheme.onSurface,
      dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      buttonOkOnPressed: () =>
          changePlanAndAddToWatchedEpisodes(planType, changeIfOk, true),
      buttonCancelOnPressed: () =>
          changePlanAndAddToWatchedEpisodes(widget.data.planType, 0, false),
      buttonOkColor: Theme.of(context).colorScheme.primary,
    );
    choiceDialog.show(context);
  }

  void changePlanAndAddToWatchedEpisodes(
      PlanType planType, int epAdd, bool ok) async {
    widget.data.episodesWatched += epAdd;
    widget.data.planType = planType;
    if (ok) {
      if (widget.data.planType == PlanType.finished) {
        await Navigator.pushNamed(
          context,
          RatePrompt.routeName,
          arguments: [widget.data, widget.showType],
        );
      } else {
        if (widget.showType == ShowType.anime) {
          ref
              .read(myListControllerProvider)
              .addToWatchList(animeData: widget.data);
        } else {
          ref
              .read(myListControllerProvider)
              .addToWatchList(movieShowData: widget.data);
        }
      }
    }
    ref
        .read(mainLayoutControllerProvider)
        .changeDataAndNotify(widget.data, widget.showType);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void increaseWatchedEpisodes() async {
    if (widget.data.episodesWatched < widget.data.numOfEpisodes) {
      if (widget.data.episodesWatched == widget.data.numOfEpisodes - 1) {
        showDialogeWhenPlanTypeChanges(context, PlanType.finished, 1);
      } else if (widget.data.episodesWatched == 0 &&
          widget.data.numOfEpisodes != 1) {
        showDialogeWhenPlanTypeChanges(context, PlanType.watching, 1);
      } else {
        widget.data.episodesWatched++;
        ref
            .read(mainLayoutControllerProvider)
            .changeDataAndNotify(widget.data, widget.showType);
      }
    }
  }

  void decreaseWatchedEpisodes() {
    if (widget.data.episodesWatched > 0) {
      if (widget.data.episodesWatched == 1) {
        showDialogeWhenPlanTypeChanges(context, PlanType.planToWatch, -1);
      } else if (widget.data.episodesWatched == widget.data.numOfEpisodes) {
        showDialogeWhenPlanTypeChanges(context, PlanType.watching, -1);
      } else {
        widget.data.episodesWatched--;
      }
      ref
          .read(mainLayoutControllerProvider)
          .changeDataAndNotify(widget.data, widget.showType);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    String planTypeString;
    widget.data.planType == PlanType.planToWatch
        ? planTypeString = 'Plan To Watch'
        : widget.data.planType == PlanType.watching
            ? planTypeString = 'Watching'
            : planTypeString = 'Finished';

    int ratingCount = widget.data.userRating != null
        ? (widget.data.userRating / 2).round().toInt()
        : 0;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: InkWell(
                onTap: () {
                  if (widget.showType == ShowType.anime) {
                    Navigator.pushNamed(
                      context,
                      AnimeScreen.routeName,
                      arguments: [
                        widget.data.malID,
                        widget.data.planType,
                      ],
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      MovieScreen.routeName,
                      arguments: [
                        widget.data.tmdbID,
                        widget.data.showType,
                        widget.data.planType,
                      ],
                    );
                  }
                },
                child: ListTile(
                  leading: Image.network(widget.data.poster),
                  title: SizedBox(
                    child: Text(
                      widget.data.title,
                      style: myTheme.textTheme.labelLarge,
                    ),
                  ),
                  visualDensity: const VisualDensity(vertical: 4),
                  dense: false,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: myTheme.textTheme.labelSmall,
                      ),
                      const VerticalSpacing(3),
                      Row(
                        children: [
                          SizedBox(
                            height: 12,
                            width: size.width * 0.375,
                            child: FAProgressBar(
                              currentValue:
                                  widget.data.episodesWatched.toDouble(),
                              maxValue: widget.data.numOfEpisodes.toDouble(),
                              direction: Axis.horizontal,
                              progressColor: Colors.teal,
                              backgroundColor: Colors.grey[800]!,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          const HorizontalSpacing(8),
                          Text(
                            '${widget.data.episodesWatched}/${widget.data.numOfEpisodes}',
                            style: myTheme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.125,
              child: widget.data.planType == PlanType.planToWatch
                  ? InkWell(
                      onTap: increaseWatchedEpisodes,
                      child: Container(
                        height: 90,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    )
                  : widget.data.planType == PlanType.watching
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: increaseWatchedEpisodes,
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            const VerticalSpacing(6),
                            InkWell(
                              onTap: decreaseWatchedEpisodes,
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: const Icon(Icons.remove),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const VerticalSpacing(40),
                            Text(
                              '${widget.data.userRating} / 10',
                              style: myTheme.textTheme.displayMedium,
                            ),
                            const VerticalSpacing(5),
                            SizedBox(
                              height: 25,
                              width: size.width * 0.12,
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
                        ),
            ),
          ],
        ),
        const VerticalSpacing(10),
        Text(
          'Added To $planTypeString on : ${widget.data.watchedTime.day}-${widget.data.watchedTime.month}-${widget.data.watchedTime.year}',
          style: myTheme.textTheme.displayMedium,
        ),
        const VerticalSpacing(9),
        Divider(color: myTheme.colorScheme.onSurface),
      ],
    );
  }
}
