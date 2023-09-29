import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';

class ShortTMDBDataModel {
  ShortTMDBDataModel({
    required this.tmdbID,
    required this.poster,
    required this.title,
    required this.planType,
    required this.showType,
    required this.rating,
    required this.episodesWatched,
    required this.numOfEpisodes,
    this.userRating,
    this.watchedTime,
    this.imdbID,
  });

  factory ShortTMDBDataModel.fromMap(
      Map<dynamic, dynamic> map, ShowType showType) {
    String? posterImage;
    if (map['poster_path'] != null) {
      posterImage = 'https://image.tmdb.org/t/p/w500/${map['poster_path']}';
    }

    return ShortTMDBDataModel(
      tmdbID: map['id'].toString(),
      poster: posterImage,
      title: map['title'] ?? map['name'],
      planType: map['plan_type'] == null
          ? null
          : PlanType.fromString(map['plan_type']),
      rating: map['vote_average'].toString(),
      showType: showType,
      episodesWatched: map['watched_episodes'] ?? 0,
      numOfEpisodes: map['number_of_episodes'] ?? 1,
      userRating: map['user_rating'],
      watchedTime: map['watched_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['watched_time'])
          : null,
    );
  }

  final String tmdbID;
  final String? poster;
  final String title;
  final String? rating;
  int episodesWatched;
  int? userRating;
  String? imdbID;
  DateTime? watchedTime;
  PlanType? planType;
  int numOfEpisodes;
  ShowType showType;

  Map<String, dynamic> toMap() {
    return {
      'id': tmdbID,
      'imdb_id': imdbID,
      'poster_path': poster,
      'title': title,
      'vote_average': rating,
      'plan_type': planType == null ? null : planType!.type,
      'number_of_episodes': numOfEpisodes,
      'watched_time':
          watchedTime != null ? watchedTime!.millisecondsSinceEpoch : null,
      'watched_episodes': episodesWatched,
      'user_rating': userRating,
    };
  }
}
