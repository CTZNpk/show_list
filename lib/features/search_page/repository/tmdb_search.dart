import 'package:show_list/features/home_page/repository/tmdb_data.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/enums/show_type.dart';

class TmdbSearchMovie extends TMDBData {
  TmdbSearchMovie({required this.query});
  String query;

  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
        Uri.parse(
          '$url/search/movie?query=$query&include_adult=false&language=en-US&page=${pageNumber.toString()}',
        ),
        ShowType.movie);
  }
}

class TmdbSearchShow extends TMDBData {
  TmdbSearchShow({required this.query});
  String query;

  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
        '$url/search/tv?query=$query&include_adult=false&language=en-US&page=${pageNumber.toString()}',
      ),
      ShowType.show,
    );
  }
}

class TmdbSearchMovieWithFilters extends TMDBData {
  TmdbSearchMovieWithFilters({required this.filterSearch});
  FilterSearchWrapper filterSearch;

  @override
  Future getData(int pageNumber) async {
    String genreString = '';
    if (filterSearch.genres != null) {
      genreString = '&with_genres=';
      int index = 0;
      for (String genre in filterSearch.genres!) {
        if (index != 0) {
          genreString += '%2C';
        }
        genreString += genre;
        index++;
      }
    }

    return await getListOfShortTMDBDataModel(
      Uri.parse(
        '$url/discover/movie?include_adult=false&include_video=false&language=en-US&page=${pageNumber.toString()}&primary_release_date.gte=${filterSearch.startDate}-01-01&primary_release_date.lte=${filterSearch.endDate}-12-31&sort_by=vote_count.desc$genreString',
      ),
      ShowType.movie,
    );
  }
}

class TmdbSearchShowWithFilters extends TMDBData {
  TmdbSearchShowWithFilters({required this.filterSearch});
  FilterSearchWrapper filterSearch;

  @override
  Future getData(int pageNumber) async {
    String genreString = '';
    if (filterSearch.genres != null) {
      genreString = '&with_genres=';
      int index = 0;
      for (String genre in filterSearch.genres!) {
        if (index != 0) {
          genreString += '%2C';
        }
        genreString += genre;
        index++;
      }
    }
    print('https://api.themoviedb.org/3/discover/tv?first_air_date.gte=${filterSearch.startDate}-01-01&first_air_date.lte=${filterSearch.endDate}-12-31&include_adult=false&include_null_first_air_dates=false&language=en-US&page=${pageNumber.toString()}&sort_by=vote_count.desc$genreString');

    return await getListOfShortTMDBDataModel(
      Uri.parse(
      'https://api.themoviedb.org/3/discover/tv?first_air_date.gte=${filterSearch.startDate}-01-01&first_air_date.lte=${filterSearch.endDate}-12-31&include_adult=false&include_null_first_air_dates=false&language=en-US&page=${pageNumber.toString()}&sort_by=vote_count.desc$genreString',
      ),
      ShowType.show,
    );
  }
}
