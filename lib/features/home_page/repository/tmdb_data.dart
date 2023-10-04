import 'dart:convert';
import 'package:http/http.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';

abstract class TMDBData {
  final String url = 'https://api.themoviedb.org/3';
  final String apiUrl = '<TMDB Api Key>';
  final String accept = 'application/json';

  Future getData(int pageNumber);

  Future getListOfShortTMDBDataModel(Uri getUrl, ShowType showType) async {
    Response response = await get(
      getUrl,
      headers: {
        'Authorization': 'Bearer $apiUrl',
        'accept': accept,
      },
    );
    List<ShortTMDBDataModel> moviesID = [];
    Map listOfMovies = jsonDecode(response.body);
    for (var movies in listOfMovies['results']) {
      moviesID.add(
        ShortTMDBDataModel.fromMap(movies, showType),
      );
    }
    return moviesID;
  }
}

class PopularMovies extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/movie/popular?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.movie,
    );
  }
}

class TopRatedMovies extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/movie/top_rated?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.movie,
    );
  }
}

class NowPlayingMovies extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/movie/now_playing?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.movie,
    );
  }
}

class TrendingMovies extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/trending/movie/day?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.movie,
    );
  }
}

class TrendingShows extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/trending/tv/day?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.show,
    );
  }
}

class PopularShow extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/tv/popular?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.show,
    );
  }
}

class TopRatedShow extends TMDBData {
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/tv/top_rated?language=en-US&vote_count.gte=100&page=${pageNumber.toString()}'),
      ShowType.show,
    );
  }
}

class RecommendedMovie extends TMDBData {
  RecommendedMovie({required this.movieID});
  String movieID;
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/movie/$movieID/recommendations?language=en-US&page=${pageNumber.toString()}'),
      ShowType.movie,
    );
  }
}

class RecommendedShow extends TMDBData {
  RecommendedShow({required this.showID});
  String showID;
  @override
  Future getData(int pageNumber) async {
    return await getListOfShortTMDBDataModel(
      Uri.parse(
          '$url/tv/$showID/recommendations?language=en-US&page=${pageNumber.toString()}'),
      ShowType.show,
    );
  }
}

class GetIMDBID extends TMDBData {
  GetIMDBID({
    required this.tmdbID,
    required this.showType,
  });

  final String tmdbID;
  final ShowType showType;

  @override
  Future getData(int pageNumber) async {
    Map data;
    if (showType == ShowType.movie) {
      final response = await get(
        Uri.parse('$url/movie/$tmdbID/external_ids'),
        headers: {
          'Authorization': 'Bearer $apiUrl',
          'accept': accept,
        },
      );
      data = jsonDecode(response.body);
    } else {
      final response = await get(
        Uri.parse('$url/tv/$tmdbID/external_ids'),
        headers: {
          'Authorization': 'Bearer $apiUrl',
          'accept': accept,
        },
      );
      data = jsonDecode(response.body);
    }
    return data['imdb_id'];
  }
}

class GetTMDBData extends TMDBData {
  GetTMDBData({
    required this.tmdbID,
    required this.showType,
  });

  final String tmdbID;
  final ShowType showType;

  @override
  Future getData(int pageNumber) async {
    Map data;
    if (showType == ShowType.movie) {
      final response = await get(
        Uri.parse(
            '$url/movie/$tmdbID?language=en-US&append_to_response=videos'),
        headers: {
          'Authorization': 'Bearer $apiUrl',
          'accept': accept,
        },
      );
      data = jsonDecode(response.body);
    } else {
      final response = await get(
        Uri.parse(
            '$url/tv/$tmdbID?language=en-US&append_to_response=videos,external_ids'),
        headers: {
          'Authorization': 'Bearer $apiUrl',
          'accept': accept,
        },
      );
      data = jsonDecode(response.body);
    }
    return TMDBDataModel.fromMap(data, showType);
  }
}
