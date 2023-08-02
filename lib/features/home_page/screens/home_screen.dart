import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/features/home_page/widgets/horizontal_list_anime.dart';
import 'package:show_list/features/home_page/widgets/horizontal_list_movie.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Theme(
      data: myTheme.copyWith(
        colorScheme: ColorScheme.light(primary: Colors.lime[900]!),
      ),
      child: Scaffold(
        body: ListView(
          children: [
            const _HomePageHeading(heading: 'Trending Movies'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                isAnime: false,
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTrendingMovies,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Movies'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularMovies,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(heading: 'Box Office Movies'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getBoxOfficeMovies,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(
                heading: 'Most Watched Movies In The Past Week'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getMostWatchedMovies,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(heading: 'Trending TV Shows'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTrendingShows,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Shows'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularShows,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(
                heading: 'Most Watched TV Shows In The Past Week'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getMostWatchedShows,
                isAnime: false,
              ),
            ),
            const _HomePageHeading(heading: 'Highest Rated Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction: ref
                    .read(homeScreenControllerProvider)
                    .getHighestRankedAnime,
                isAnime: true,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularAnime,
                isAnime: true,
              ),
            ),
            const _HomePageHeading(heading: 'Top Airing Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTopAiringAnime,
                isAnime: true,
              ),
            ),
            const _HomePageHeading(heading: 'Upcoming Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: _ReturnAnimeOrMovieHorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getUpcomingAnime,
                isAnime: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePageHeading extends StatelessWidget {
  const _HomePageHeading({required this.heading});

  final String heading;
  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Text(
        heading,
        style: myTheme.textTheme.displayLarge
            ?.copyWith(color: myTheme.colorScheme.primary),
      ),
    );
  }
}

class _ReturnAnimeOrMovieHorizontalList extends StatelessWidget {
  _ReturnAnimeOrMovieHorizontalList({
    required this.isAnime,
    required this.dataFunction,
  });

  final Function dataFunction;
  final bool isAnime;

  late var data = dataFunction();

  @override
  Widget build(BuildContext context) {
    return isAnime
        ? HorizontalListAnime(
            data: data,
          )
        : HorizontalListMovie(
            data: data,
          );
  }
}
