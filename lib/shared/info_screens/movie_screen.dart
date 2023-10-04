import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/genres.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/add_to_watchlist_prompt.dart';
import 'package:show_list/shared/loading.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const routeName = '/movie-screen';
  const MovieScreen({
    super.key,
    required this.tmdbID,
    required this.showType,
    required this.planType,
  });

  final String tmdbID;
  final ShowType showType;
  final PlanType? planType;

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  late YoutubePlayerController _controller;
  final ScrollController _scrollController = ScrollController();

  Future gettingImdbRating(TMDBDataModel tmdbData) async {
    if (tmdbData.imdbRating != null) {
      return tmdbData.imdbRating;
    }
    if (tmdbData.imdbID != null) {
      tmdbData.imdbRating = await ref
          .read(homeScreenControllerProvider)
          .getImdbRating(tmdbData.imdbID!);
      return tmdbData.imdbRating;
    } else {
      return null;
    }
  }

  Future gettingData() async {
    final tmdbData = await ref
        .read(homeScreenControllerProvider)
        .getTmdbData(widget.tmdbID, widget.showType);

    if (tmdbData?.trailer != null) {
      final videoID = tmdbData?.trailer;
      _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
          controlsVisibleAtStart: true,
        ),
      );
    }
    return tmdbData;
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: gettingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            snapshot.data!.planType = widget.planType;
            return Container(
              color: myTheme.scaffoldBackgroundColor,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: size.width * 0.5,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          snapshot.data!.backDropImage,
                        ),
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 30.0,
                                right: 12.0,
                              ),
                              child: Image.network(
                                snapshot.data.poster,
                                fit: BoxFit.fill,
                                height: 200,
                                width: 140,
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.title,
                                    style: myTheme.textTheme.displayLarge,
                                  ),
                                  const VerticalSpacing(5),
                                  Row(
                                    children: [
                                      Text(
                                        'tmdbRating : ${snapshot.data.rating}',
                                        style: myTheme.textTheme.displayMedium,
                                      ),
                                      const HorizontalSpacing(10),
                                      const Icon(
                                        Icons.people,
                                        size: 13,
                                      ),
                                      Text(
                                        snapshot.data.numberOfRatings,
                                        style: myTheme.textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                  const VerticalSpacing(2),
                                  FutureBuilder(
                                    future: gettingImdbRating(
                                      snapshot.data!,
                                    ),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.connectionState ==
                                          ConnectionState.done) {
                                        return Text(
                                          'ImdbRating: ${snapshot2.data}',
                                          style:
                                              myTheme.textTheme.displayMedium,
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  const VerticalSpacing(2),
                                  Text(
                                    'Status : ${snapshot.data.status}',
                                    style: myTheme.textTheme.displayMedium,
                                  ),
                                  const VerticalSpacing(2),
                                  widget.showType != ShowType.show
                                      ? Text(
                                          'RunTime : ${snapshot.data.runTime}m',
                                          style:
                                              myTheme.textTheme.displayMedium,
                                        )
                                      : const SizedBox.shrink(),
                                  const VerticalSpacing(2),
                                  Text(
                                    snapshot.data.endDate == null
                                        ? 'Date : ${snapshot.data.startDate}'
                                        : 'Date : ${snapshot.data.startDate} - ${snapshot.data.endDate}',
                                    style: myTheme.textTheme.displayMedium,
                                  ),
                                  const VerticalSpacing(2),
                                  snapshot.data.numOfSeasons != null
                                      ? Text(
                                          'Number Of Seasons : ${snapshot.data.numOfSeasons}',
                                          style:
                                              myTheme.textTheme.displayMedium,
                                        )
                                      : const SizedBox.shrink(),
                                  const VerticalSpacing(2),
                                  snapshot.data.numOfEpisodes != null
                                      ? Text(
                                          'Number Of Episodes : ${snapshot.data.numOfEpisodes}',
                                          style:
                                              myTheme.textTheme.displayMedium,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )
                          ],
                        ),
                        const VerticalSpacing(10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${snapshot.data.tagLine}',
                            style: myTheme.textTheme.displayLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const VerticalSpacing(10),
                        snapshot.data.planType != null
                            ? SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data.planType.type,
                                      style: myTheme.textTheme.labelLarge,
                                    ),
                                    Icon(
                                      Icons.done,
                                      color: myTheme.colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                              )
                            : MyElevatedButton(
                                label: 'Add To WatchList',
                                labelIcon: Icons.list,
                                imageUrl: null,
                                backgroundColor: Colors.indigo[900]!,
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    ShowAddToWatchlistPrompt.routeName,
                                    arguments: [
                                      widget.showType,
                                      snapshot.data,
                                    ],
                                  );
                                },
                              ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            itemCount: snapshot.data.genres.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.showType == ShowType.movie
                                            ? GenresMovie.fromID(
                                                    snapshot.data.genres[index])
                                                .name
                                            : GenresShows.fromID(
                                                    snapshot.data.genres[index])
                                                .name,
                                        style: myTheme.textTheme.displayMedium!
                                            .copyWith(
                                                color: myTheme
                                                    .scaffoldBackgroundColor),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const VerticalSpacing(8),
                        Text('Trailer : ',
                            style: myTheme.textTheme.displayLarge),
                        const VerticalSpacing(10),
                        snapshot.data.trailer != null
                            ? YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        'Not Available',
                                        style: myTheme.textTheme.displayLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const VerticalSpacing(10),
                        Text(
                          'Overview : ',
                          style: myTheme.textTheme.displayLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data.overView,
                              style: myTheme.textTheme.displayMedium),
                        ),
                        Text(
                          'Similar Recommeded : ',
                          style: myTheme.textTheme.displayLarge,
                        ),
                        _DisplayRecommendations(
                          showType: snapshot.data.showType,
                          tmdbID: snapshot.data.tmdbID,
                          controller: _scrollController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}

class _DisplayRecommendations extends ConsumerStatefulWidget {
  const _DisplayRecommendations(
      {required this.showType, required this.tmdbID, required this.controller});
  final ShowType showType;
  final String tmdbID;
  final ScrollController controller;

  @override
  ConsumerState<_DisplayRecommendations> createState() =>
      _DisplayRecommendationsState();
}

class _DisplayRecommendationsState
    extends ConsumerState<_DisplayRecommendations>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> dataList = [];
  int pageNumber = 1;
  bool noMoreResults = false;

  Future fetchDataFromFunction() async {
    List<ShortTMDBDataModel>? listOfResults;
    if (widget.showType == ShowType.show) {
      listOfResults = await ref
          .read(homeScreenControllerProvider)
          .getRecommendedShows(widget.tmdbID, pageNumber);
    } else {
      listOfResults = await ref
          .read(homeScreenControllerProvider)
          .getRecommendedMovies(widget.tmdbID, pageNumber);
    }
    if (listOfResults!.isEmpty) {
      noMoreResults = true;
    } else {
      if (pageNumber != 1) {
        listOfResults.removeAt(0);
      }
      dataList = [...dataList, ...listOfResults];
    }
    setState(() {});
  }

  void lookingUpDataListener() {
    if (noMoreResults == false &&
        widget.controller.offset >=
            widget.controller.position.maxScrollExtent - 150) {
      pageNumber++;
      fetchDataFromFunction();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFunction();
    widget.controller.addListener(lookingUpDataListener);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return GridView.builder(
      controller: ScrollController(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 7 / 8,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return DisplayPosterGrid(
          showData: dataList[index],
          showType: widget.showType,
        );
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(lookingUpDataListener);
    super.dispose();
  }
}
