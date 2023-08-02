import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';
import 'package:trakt_dart/trakt_dart.dart';

abstract class TraktData {
  final traktClientId =
      '2057b666b6245686ebec1af8ce78b6f8479683d218d9ba795edce7f81c650e70';
  final traktClientSecret =
      '9f944baba43a5d2f27e3da5aaedeb4485022ccb3c9d2c74e190409347c84f4ec';

  Future<List<TraktDataModel>> getData();
}

class GetTrendingMovies extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final trendingMovies = await traktManager.movies.getTrendingMovies(
          pagination: RequestPagination( limit: 20),
          extendedFull: true);

      List<TraktDataModel> traktDataList = [];

      for (var trendingMovie in trendingMovies) {
        if(trendingMovie.movie.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: trendingMovie.movie.title,
            imdbID: trendingMovie.movie.ids.imdb,
            trailer: trendingMovie.movie.trailer,
            traktRating: trendingMovie.movie.rating,
            airedEpisodes: null,
            showType: ShowType.movie,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetBoxOfficeMovies extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final movies =
          await traktManager.movies.getBoxOfficeMovies(extendedFull: true);

      List<TraktDataModel> traktDataList = [];

      for (var movie in movies) {
        if(movie.movie.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: movie.movie.title,
            imdbID: movie.movie.ids.imdb,
            trailer: movie.movie.trailer,
            traktRating: movie.movie.rating,
            airedEpisodes: null,
            showType: ShowType.movie,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetMostWatchedMovies extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final movies = await traktManager.movies.getMostWatchedMovies(
        TimePeriod.weekly,
        extendedFull: true,
        pagination: RequestPagination(
          limit: 20,
        ),
      );

      List<TraktDataModel> traktDataList = [];

      for (var movie in movies) {
        if(movie.movie.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: movie.movie.title,
            imdbID: movie.movie.ids.imdb,
            trailer: movie.movie.trailer,
            traktRating: movie.movie.rating,
            airedEpisodes: null,
            showType: ShowType.movie,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetPopularMovies extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final movies = await traktManager.movies.getPopularMovies(
        TimePeriod.weekly,
        extendedFull: true,
        pagination: RequestPagination(limit: 20),
      );

      List<TraktDataModel> traktDataList = [];

      for (var movie in movies) {
        if(movie.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: movie.title,
            imdbID: movie.ids.imdb,
            trailer: movie.trailer,
            traktRating: movie.rating,
            airedEpisodes: null,
            showType: ShowType.movie,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetTrendingShows extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final trendingShows = await traktManager.shows.getTrendingShows(
        extendedFull: true,
        pagination: RequestPagination(limit: 20),
      );

      List<TraktDataModel> traktDataList = [];

      for (var trendingShow in trendingShows) {
        if(trendingShow.show.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: trendingShow.show.title,
            imdbID: trendingShow.show.ids.imdb,
            trailer: trendingShow.show.trailer,
            traktRating: trendingShow.show.rating,
            airedEpisodes: trendingShow.show.airedEpisodes,
            showType: ShowType.show,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetPopularShows extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final shows = await traktManager.shows.getPopularShows(
        extendedFull: true,
        pagination: RequestPagination(limit: 20),
      );

      List<TraktDataModel> traktDataList = [];

      for (var show in shows) {
        if(show.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: show.title,
            imdbID: show.ids.imdb,
            trailer: show.trailer,
            traktRating: show.rating,
            airedEpisodes: show.airedEpisodes,
            showType: ShowType.show,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}

class GetMostWatchedShows extends TraktData {
  @override
  Future<List<TraktDataModel>> getData() async {
    try {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final shows = await traktManager.shows.getMostPlayedShows(
        TimePeriod.weekly,
        extendedFull: true,
        pagination: RequestPagination(limit: 20),
      );

      List<TraktDataModel> traktDataList = [];

      for (var show in shows) {
        if(show.show.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: show.show.title,
            imdbID: show.show.ids.imdb,
            trailer: show.show.trailer,
            traktRating: show.show.rating,
            airedEpisodes: show.show.airedEpisodes,
            showType: ShowType.show,
          ),
        );
      }
      return traktDataList;
    } catch (e) {
      rethrow;
    }
  }
}
