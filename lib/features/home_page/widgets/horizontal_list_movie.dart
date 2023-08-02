import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';
import 'package:uuid/uuid.dart';

class HorizontalListMovie extends ConsumerStatefulWidget {
  const HorizontalListMovie({super.key, required this.data});
  final Future<List<TraktDataModel>?> data;

  @override
  ConsumerState<HorizontalListMovie> createState() => _HorizontaListMovie();
}

class _HorizontaListMovie extends ConsumerState<HorizontalListMovie>
    with AutomaticKeepAliveClientMixin {
  Map<String, OmdbDataModel?> omdbDataMap = {};
  Map<String, String?> movieDbRating = {};

  Future<OmdbDataModel?> callAPIIfNotInList(
      BuildContext context, String imdbID) async {
    if (omdbDataMap[imdbID] == null) {
      omdbDataMap[imdbID] = await ref
          .read(homeScreenControllerProvider)
          .getOmdbData(imdbID);
      if (omdbDataMap[imdbID]?.rating != []) {
        for (var rating in (omdbDataMap[imdbID]?.rating)!) {
          if (rating.isIMDb) {
            movieDbRating[imdbID] = rating.value.substring(0, 3);
          }
        }
      }
    }
    return omdbDataMap[imdbID];
  }

  Future<String?> callAPIIfRatingNotFound(
      BuildContext context, String imdbID) async {
    if (movieDbRating[imdbID] == null) {
      movieDbRating[imdbID] = await ref
          .read(homeScreenControllerProvider)
          .getImdbRating(imdbID);
      omdbDataMap[imdbID]?.rating.add(
            Rating(
              source: 'IMDb',
              value: movieDbRating[imdbID]!,
              isIMDb: true,
            ),
          );
    }
    return movieDbRating[imdbID];
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    super.build(context);
    return FutureBuilder<List<TraktDataModel>?>(
      future: widget.data,
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.done &&
            snapshot1.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot1.data!.length,
            itemBuilder: (context, index) {
              final omdbData =
                  callAPIIfNotInList(context, snapshot1.data![index].imdbID!);
              final ratingData = callAPIIfRatingNotFound(
                  context, snapshot1.data![index].imdbID!);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        FutureBuilder<OmdbDataModel?>(
                          future: omdbData,
                          builder: (context, snapshot2) {
                            final specificUid = const Uuid().v4();
                            if (snapshot2.connectionState ==
                                    ConnectionState.done &&
                                snapshot2.hasData) {
                              return InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  MovieScreen.routeName,
                                  arguments: [
                                    snapshot1.data![index],
                                    snapshot2.data!,
                                    specificUid,
                                  ],
                                ),
                                child: Hero(
                                  tag: specificUid,
                                  child: Image.network(
                                    snapshot2.data!.poster,
                                    height: size.height * 0.25,
                                    width: size.width * 0.30,
                                  ),
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
                        FutureBuilder<String?>(
                          future: ratingData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Positioned(
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
                                    child: Center(
                                      child: Text(
                                        snapshot.data!,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                      width: size.width * 0.30,
                      child: Center(
                        child: Text(
                          snapshot1.data![index].title,
                          style: myTheme.textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
