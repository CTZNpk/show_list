import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/add_to_watchlist_prompt.dart';
import 'package:show_list/shared/loading.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class AnimeScreen extends ConsumerStatefulWidget {
  static const routeName = '/anime-screen';
  const AnimeScreen({
    super.key,
    required this.malID,
    required this.planType,
  });

  final String malID;
  final PlanType? planType;

  @override
  ConsumerState<AnimeScreen> createState() => _AnimeScreen();
}

class _AnimeScreen extends ConsumerState<AnimeScreen> {
  Future<MalAnimeDataModel?> gettingAnimeData() async {
    return await ref
        .read(homeScreenControllerProvider)
        .getAnimeDataFromID(widget.malID);
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return FutureBuilder<MalAnimeDataModel?>(
      future: gettingAnimeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          snapshot.data!.planType = widget.planType;
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 12.0,
                        ),
                        child: Image.network(
                          snapshot.data!.poster ??
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                          height: size.height * 0.25,
                          width: size.width * 0.30,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 23.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.title,
                                style: myTheme.textTheme.displayLarge,
                              ),
                              Text(
                                '${snapshot.data!.startDate} - ${snapshot.data!.endDate}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                              const VerticalSpacing(2),
                              Text(
                                'Number of Episodes : ${(snapshot.data!.numOfEpisodes == 0 || snapshot.data!.numOfEpisodes == 100000) ? 'N/A' : snapshot.data!.numOfEpisodes}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                              const VerticalSpacing(8),
                              Text(
                                'Rating : ${snapshot.data!.rating}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                              Text(
                                'Rank : ${snapshot.data!.rank}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                              Text(
                                'Popularity : ${snapshot.data!.popularity}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                              Text(
                                'Status : ${snapshot.data!.status}',
                                style: myTheme.textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: snapshot.data!.planType != null
                      ? SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.planType!.type,
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
                          onPressed: () => Navigator.pushNamed(
                            context,
                            ShowAddToWatchlistPrompt.routeName,
                            arguments: [
                              ShowType.anime,
                              snapshot.data,
                            ],
                          ),
                        ),
                ),
                Text(
                  'Genres ',
                  style: myTheme.textTheme.displayLarge,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    itemCount: snapshot.data!.genres.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data!.genres[index],
                              style: myTheme.textTheme.displayMedium!.copyWith(
                                  color: myTheme.scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalSpacing(8),
                Text(
                  'Overview ',
                  style: myTheme.textTheme.displayLarge,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data!.overview,
                    style: myTheme.textTheme.displayMedium,
                  ),
                ),
                const VerticalSpacing(8),
                Text(
                  'Alternative Titles',
                  style: myTheme.textTheme.displayLarge,
                ),
                SizedBox(
                  height: size.height * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.alternativeTitle.length,
                      itemBuilder: (context, index) {
                        return Text(
                          snapshot.data!.alternativeTitle[index],
                          style: myTheme.textTheme.displayMedium,
                        );
                      },
                    ),
                  ),
                ),
                const VerticalSpacing(8),
                _DisplayRecommendations(
                    recommendedAnime: snapshot.data!.relatedAnime!),
              ],
            ),
          );
        }
        return const LoadingScreen();
      },
    );
  }
}

class _DisplayRecommendations extends ConsumerStatefulWidget {
  const _DisplayRecommendations({required this.recommendedAnime});

  final List<ShortMalData> recommendedAnime;

  @override
  ConsumerState<_DisplayRecommendations> createState() =>
      _DisplayRecommendationsState();
}

class _DisplayRecommendationsState
    extends ConsumerState<_DisplayRecommendations>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 7 / 8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: widget.recommendedAnime.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                DisplayPosterGrid(
                  showData: widget.recommendedAnime[index],
                  showType: ShowType.anime,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
