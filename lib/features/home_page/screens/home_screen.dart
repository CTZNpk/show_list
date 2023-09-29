import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/home_page/controller/home_screen_controller.dart';
import 'package:show_list/features/home_page/widgets/horizontal_list_movie.dart';
import 'package:show_list/shared/enums/show_type.dart';

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
              child: HorizontalList(
                showType: ShowType.movie,
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTrendingMovies,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Movies'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularMovies,
                showType: ShowType.movie,
              ),
            ),
            const _HomePageHeading(heading: 'Box Office Movies'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getBoxOfficeMovies,
                showType: ShowType.movie,
              ),
            ),
            const _HomePageHeading(
                heading: 'Top Rated Movies '),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTopRatedMovies,
                showType: ShowType.movie,
              ),
            ),
            const _HomePageHeading(heading: 'Trending TV Shows'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTrendingShows,
                showType: ShowType.show,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Shows'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularShows,
                showType: ShowType.show,
              ),
            ),
            const _HomePageHeading(
                heading: 'Top Rated TV Shows'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTopRatedShows,
                showType: ShowType.show,
              ),
            ),
            const _HomePageHeading(heading: 'Highest Rated Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction: ref
                    .read(homeScreenControllerProvider)
                    .getHighestRankedAnime,
                showType: ShowType.anime,
              ),
            ),
            const _HomePageHeading(heading: 'Popular Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getPopularAnime,
                showType: ShowType.anime,
              ),
            ),
            const _HomePageHeading(heading: 'Top Airing Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getTopAiringAnime,
                showType: ShowType.anime,
              ),
            ),
            const _HomePageHeading(heading: 'Upcoming Anime'),
            SizedBox(
              height: size.height * 0.30 + 20,
              child: HorizontalList(
                dataFunction:
                    ref.read(homeScreenControllerProvider).getUpcomingAnime,
                showType: ShowType.anime,
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
