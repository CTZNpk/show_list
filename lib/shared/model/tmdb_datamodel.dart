import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';

class TMDBDataModel {
  TMDBDataModel({
    required this.tmdbID,
    required this.imdbID,
    required this.poster,
    required this.backDropImage,
    required this.title,
    required this.overView,
    required this.rating,
    required this.numberOfRatings,
    required this.status,
    required this.runTime,
    required this.trailer,
    required this.tagLine,
    required this.startDate,
    required this.endDate,
    required this.genres,
    required this.showType,
    required this.episodesWatched,
    required this.numOfEpisodes,
    this.userRating,
    this.numOfSeasons,
    this.watchedTime,
    this.planType,
    this.imdbRating,
  });

  factory TMDBDataModel.fromMap(Map<dynamic, dynamic> map, ShowType showType) {
    String? trailer;
    List<dynamic> videosList = map['videos']['results'];

    for (var vids in videosList) {
      if (vids['official']) {
        trailer = vids['key'];
        break;
      }
    }

    List<String> genres = [];
    List<dynamic> genresList = map['genres'];

    for (var gen in genresList) {
      genres.add(gen['id'].toString());
    }
    return TMDBDataModel(
      tmdbID: map['id'].toString(),
      imdbID: showType == ShowType.movie
          ? map['imdb_id']
          : map['external_ids']['imdb_id'],
      poster: map['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500/${map['poster_path']}'
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      backDropImage: map['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w500/${map['backdrop_path']}'
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
      title: showType == ShowType.movie ? map['title'] : map['name'],
      overView: map['overview'],
      rating: map['vote_average'].toString(),
      numberOfRatings: map['vote_count'].toString(),
      status: map['status'],
      runTime: map['runtime'].toString(),
      trailer: trailer,
      genres: genres,
      tagLine: map['tagline'],
      showType: showType,
      startDate: showType == ShowType.movie
          ? map['release_date']
          : map['first_air_date'],
      endDate: map['last_air_date'],
      numOfSeasons: map['number_of_seasons'],
      numOfEpisodes: map['number_of_episodes'] ?? 1,
      planType: map['plan_type'] != null
          ? PlanType.fromString(map['plan_type'])
          : null,
      episodesWatched: map['watched_episodes'] ?? 0,
      userRating: map['user_rating'],
      watchedTime: map['watched_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['watched_time'])
          : null,
    );
  }

  final String tmdbID;
  final String? imdbID;
  final String? poster;
  final String? backDropImage;
  final String title;
  final String? overView;
  final String? rating;
  final String? numberOfRatings;
  final String? status;
  final String? runTime;
  final String? tagLine;
  final String? trailer;
  final List<String> genres;
  final ShowType showType;
  final String? startDate;
  final String? endDate;
  String? imdbRating;
  int episodesWatched;
  int? numOfSeasons;
  int numOfEpisodes;
  DateTime? watchedTime;
  PlanType? planType;
  int? userRating;

  Map<String, dynamic> toMap() {
    List<Map<String, String>> genreList = [];
    for (var genre in genres) {
      genreList.add({'id': genre});
    }

    if (showType == ShowType.movie) {
      return {
        'id': tmdbID,
        'imdb_id': imdbID,
        'poster_path': poster,
        'backdrop_path': backDropImage,
        'title': title,
        'overview': overView,
        'vote_average': rating,
        'vote_count': numberOfRatings,
        'status': status,
        'runtime': runTime,
        'videos': {
          'results': [
            {'official': true, 'key': trailer},
          ],
        },
        'genres': genreList,
        'taglineine': tagLine,
        'release_date': startDate,
        'plan_type': planType!.name,
        'watched_episodes': episodesWatched,
        'watched_time':
            watchedTime != null ? watchedTime!.millisecondsSinceEpoch : null,
        'user_rating': userRating,
      };
    } else {
      return {
        'id': tmdbID,
        'external_ids': {'imdb_id': imdbID},
        'poster_path': poster,
        'backdrop_path': backDropImage,
        'name': title,
        'overview': overView,
        'vote_average': rating,
        'vote_count': numberOfRatings,
        'status': status,
        'runtime': runTime,
        'videos': {
          'results': [
            {'official': true, 'key': trailer},
          ],
        },
        'genres': genreList,
        'taglineine': tagLine,
        'first_air_date': startDate,
        'last_air_date': endDate,
        'number_of_seasons': numOfSeasons,
        'number_of_episodes': numOfEpisodes,
        'plan_type': planType!.name,
        'watched_time':
            watchedTime != null ? watchedTime!.millisecondsSinceEpoch : null,
        'watched_episodes': episodesWatched,
        'user_rating': userRating,
      };
    }
  }

  ShortTMDBDataModel toShortTMDBDataModel() {
    return ShortTMDBDataModel(
      tmdbID: tmdbID,
      imdbID: imdbID,
      poster: poster,
      title: title,
      planType: planType,
      showType: showType,
      rating: rating,
      episodesWatched: episodesWatched,
      watchedTime: watchedTime,
      userRating: userRating,
      numOfEpisodes: numOfEpisodes,
    );
  }
}
