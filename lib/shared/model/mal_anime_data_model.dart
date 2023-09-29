import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';

class MalAnimeDataModel {
  MalAnimeDataModel({
    required this.malId,
    required this.title,
    required this.poster,
    required this.alternativeTitle,
    required this.startDate,
    required this.endDate,
    required this.rating,
    required this.rank,
    required this.popularity,
    required this.status,
    required this.genres,
    required this.numOfEpisodes,
    required this.overview,
    required this.episodesWatched,
    this.userRating,
    this.relatedAnime,
    this.watchedTime,
    this.planType,
  });

  factory MalAnimeDataModel.fromMap(Map<dynamic, dynamic> map) {
    List<String> altTitles = [];
    for (String name in map['alternative_titles']['synonyms']) {
      altTitles.add(name);
    }
    altTitles.add(map['alternative_titles']['en'] ?? '');
    altTitles.add(map['alternative_titles']['ja'] ?? '');

    List<String> genresSub = [];
    for (var gen in map['genres']) {
      genresSub.add(gen['name']);
    }

    List<ShortMalData> recommendedAnime = [];

    if (map['related_anime'] != null) {
      for (var node in map['related_anime']) {
        Map<dynamic, dynamic> data = node['node'];
        recommendedAnime.add(ShortMalData.fromMap(data));
      }
    }
    bool mainPicIsNull = false;
    if (map['main_picture'] == null) {
      mainPicIsNull = true;
    }
    bool notAired = map['status'] == 'not_yet_aired';

    return MalAnimeDataModel(
      malId: map['id'].toString(),
      title: map['title'],
      poster: mainPicIsNull
          ? map['poster']
          : map['main_picture']['medium'] ?? map['main_picture']['large'],
      alternativeTitle: altTitles,
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      rating: map['mean'].toString(),
      rank: map['rank'].toString(),
      popularity: map['popularity'].toString(),
      status: map['status'] ?? '',
      genres: genresSub,
      numOfEpisodes: map['num_episodes'] == 0
          ? notAired
              ? 0
              : 100000
          : map['num_episodes'],
      overview: map['synopsis'] ?? '',
      watchedTime: map['watched_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['watched_time'])
          : null,
      planType: map['plan_type'] != null
          ? PlanType.fromString(map['plan_type'])
          : null,
      relatedAnime: recommendedAnime,
      episodesWatched: map['num_episodes_watched'] ?? 0,
      userRating: map['user_rating'],
    );
  }

  final String malId;
  final String title;
  final String? poster;
  final List<String> alternativeTitle;
  final String startDate;
  final String endDate;
  final String? rating;
  final String? rank;
  final String? popularity;
  final String status;
  final List<String> genres;
  final int numOfEpisodes;
  final String overview;
  List<ShortMalData>? relatedAnime;
  DateTime? watchedTime;
  PlanType? planType;
  int episodesWatched;
  int? userRating;

  Map<String, dynamic> toMap() {
    List<Map<String, String>> genMap = [];
    for (var gen in genres) {
      genMap.add({'name': gen});
    }

    List<Map<dynamic, Map<dynamic, dynamic>>> recommendedAnime = [];

    if (relatedAnime != null) {
      for (var shortTMDB in relatedAnime!) {
        recommendedAnime.add({'node': shortTMDB.toMap()});
      }
    }

    return {
      'id': malId,
      'title': title,
      'poster': poster,
      'alternative_titles': {'synonyms': alternativeTitle},
      'start_date': startDate,
      'end_date': endDate,
      'mean': rating,
      'rank': rank,
      'popularity': popularity,
      'status': status,
      'genres': genMap,
      'num_episodes': numOfEpisodes,
      'synopsis': overview,
      'watched_time':
          watchedTime != null ? watchedTime!.millisecondsSinceEpoch : null,
      'plan_type': planType != null ? planType!.name : null,
      'related_anime': recommendedAnime,
      'num_episodes_watched': episodesWatched,
      'user_rating': userRating,
    };
  }

  ShortMalData toShortMalData() {
    return ShortMalData(
      malID: malId,
      title: title,
      planType: planType,
      poster: poster,
      rating: rating,
      numOfEpisodes: numOfEpisodes,
      userRating: userRating,
      watchedTime: watchedTime,
      episodesWatched: episodesWatched,
    );
  }
}
