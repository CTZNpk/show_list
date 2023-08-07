import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/features/search_page/controller/search_screen_controller.dart';
import 'package:show_list/features/search_page/services/show_result_service.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';
import 'package:uuid/uuid.dart';

class ShowResultsWrapper {
  ShowResultsWrapper({
    required this.resultOfSearch,
    required this.foundSearches,
    required this.imdbRatingMap,
  });

  List<dynamic> resultOfSearch;
  Map<String, dynamic> foundSearches;
  Map<String, String> imdbRatingMap;
}

class DisplaySearchResults extends ConsumerStatefulWidget {
  const DisplaySearchResults({super.key, required this.showType});

  final ShowType showType;

  @override
  ConsumerState<DisplaySearchResults> createState() =>
      _DisplaySearchResultsState();
}

class _DisplaySearchResultsState extends ConsumerState<DisplaySearchResults> {
  late ScrollController _controller;
  ShowResultsWrapper resultWrapper = ShowResultsWrapper(
      resultOfSearch: [], foundSearches: {}, imdbRatingMap: {});
  late ShowResultService showResultService;
  late String showTypeString;

  Future<void> _showSearch(ShowType showType) async {
    await showResultService.getSearchResults(
      showType: showType,
      resultWrapper: resultWrapper,
      controller: _controller,
    );
    setState(() {});
  }

  @override
  void initState() {
    _controller = ScrollController();
    showResultService = ShowResultService(ref: ref, context: context);
    switch (widget.showType) {
      case ShowType.movie:
        showTypeString = 'movie';
        break;
      case ShowType.show:
        showTypeString = 'show';
        break;
      default:
        showTypeString = 'anime';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MyElevatedButton(
          label: 'Search for $showTypeString',
          labelIcon: Icons.search,
          imageUrl: null,
          onPressed: () => _showSearch(widget.showType),
        ),
        const VerticalSpacing(20),
        SizedBox(
          height: size.height * 0.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 7 / 8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            controller: _controller,
            itemCount: resultWrapper.resultOfSearch.length,
            itemBuilder: (context, index) {
              return widget.showType == ShowType.anime
                  ? _DisplayAnime(
                      resultWrapper: resultWrapper,
                      index: index,
                    )
                  : _DisplayMovieAndShows(
                      resultWrapper: resultWrapper,
                      index: index,
                    );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DisplayMovieAndShows extends ConsumerWidget {
  const _DisplayMovieAndShows(
      {required this.resultWrapper, required this.index});

  final ShowResultsWrapper resultWrapper;
  final int index;

  Future<OmdbDataModel?> callApiIfNotAlreadyExists(
      String imdbID, WidgetRef ref) async {
    if (!resultWrapper.foundSearches.containsKey(imdbID)) {
      final result = await getOmdbData(imdbID, ref);
      resultWrapper.foundSearches[imdbID] = result;
    }
    return resultWrapper.foundSearches[imdbID];
  }

  Future<OmdbDataModel?> getOmdbData(String imdbID, WidgetRef ref) async {
    OmdbDataModel? omdbData =
        await ref.read(homeScreenControllerProvider).getOmdbData(imdbID);
    if (omdbData == null) {
      return null;
    }
    for (var rating in omdbData.rating) {
      if (rating.isIMDb) {
        resultWrapper.imdbRatingMap[imdbID] = rating.value;
        return omdbData;
      }
    }
    String? imdbRating =
        await ref.read(homeScreenControllerProvider).getImdbRating(imdbID);
    resultWrapper.imdbRatingMap[imdbID] = imdbRating ?? '0';
    omdbData.rating
        .add(Rating(source: 'IMDb', value: imdbRating ?? '0', isIMDb: true));
    return omdbData;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return Column(
      children: [
        FutureBuilder<OmdbDataModel?>(
          future: callApiIfNotAlreadyExists(
              resultWrapper.resultOfSearch[index].imdbID!, ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final specificUid = const Uuid().v4();
              return InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  MovieScreen.routeName,
                  arguments: [
                    resultWrapper.resultOfSearch[index],
                    snapshot.data!,
                    specificUid,
                  ],
                ),
                child: Stack(
                  children: [
                    Hero(
                      tag: specificUid,
                      child: Image.network(
                        snapshot.data!.poster == 'N/A'
                            ? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                            : snapshot.data!.poster,
                        height: size.height * 0.25,
                        width: size.width * 0.30,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          height: 18,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Text(
                            resultWrapper.imdbRatingMap[resultWrapper
                                    .resultOfSearch[index].imdbID] ??
                                'NA',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              height: size.height * 0.25,
              width: size.width * 0.30,
              child: const Center(
                child: Icon(Icons.movie),
              ),
            );
          },
        ),
        SizedBox(
          height: 30,
          width: size.width * 0.30,
          child: Center(
            child: Text(
              resultWrapper.resultOfSearch[index].title,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _DisplayAnime extends ConsumerWidget {
  const _DisplayAnime({required this.resultWrapper, required this.index});

  final ShowResultsWrapper resultWrapper;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    final specificUid = const Uuid().v4();
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            AnimeScreen.routeName,
            arguments: [
              resultWrapper.resultOfSearch[index],
              specificUid,
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: specificUid,
                child: Image.network(
                  resultWrapper.resultOfSearch[index].mainPicture == 'N/A'
                      ? 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png'
                      : resultWrapper.resultOfSearch[index].mainPicture,
                  height: size.height * 0.25,
                  width: size.width * 0.30,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    height: 18,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      resultWrapper.resultOfSearch[index].rating.toString(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
          width: size.width * 0.30,
          child: Center(
            child: Text(
              resultWrapper.resultOfSearch[index].title,
              style: myTheme.textTheme.displayMedium,
            ),
          ),
        ),
      ],
    );
  }
}
