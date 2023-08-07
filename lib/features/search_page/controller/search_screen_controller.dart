import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/search_page/repository/search_screen_repository.dart';
import 'package:show_list/shared/enums/show_type.dart';

final searchScreenControllerProvider = Provider(
  (ref) {
    final searchScreenRepository = ref.read(searchScreenRepositoryProvider);
    return SearchScreenController(
        searchScreenRepository: searchScreenRepository);
  },
);

class SearchScreenController {
  SearchScreenController({required this.searchScreenRepository});

  final SearchScreenRepository searchScreenRepository;

  Future searchMoviesAndShowsResults(String query, ShowType showType) async {
    return await searchScreenRepository.searchMovieAndShowsResults(query, showType);
  }
  Future searchAnimeResults(String query) async {
    return await searchScreenRepository.searchAnimeShowResults(query);
  }
}
