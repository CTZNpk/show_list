import 'package:show_list/shared/enums/plan_type.dart';

class ShortMalData {
  ShortMalData({
    required this.malID,
    required this.poster,
    required this.title,
    required this.planType,
    required this.rating,
    required this.numOfEpisodes,
    required this.episodesWatched,
    this.userRating,
    this.watchedTime,
  });

  factory ShortMalData.fromMap(Map<dynamic, dynamic> map) {
    String? rating = map['mean'].toString();
    bool mainPicIsNull = false;
    if (map['main_picture'] == null) {
      mainPicIsNull = true;
    }

    bool notAired = map['status'] == 'not_yet_aired';
    return ShortMalData(
      malID: map['id'].toString(),
      poster: mainPicIsNull
          ? map['poster']
          : map['main_picture']['medium'] ?? map['main_picture']['large'],
      title: map['title'],
      planType: map['plan_type'] == null
          ? null
          : PlanType.fromString(map['plan_type']),
      rating: rating != 'null' ? rating : null,
      numOfEpisodes: map['num_episodes'] == 0
          ? notAired
              ? 0
              : 100000
          : map['num_episodes'],
      watchedTime: map['watched_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['watched_time'])
          : null,
      episodesWatched: map['num_episodes_watched'] ?? 0,
      userRating: map['user_rating'],
    );
  }

  final String? malID;
  final String? poster;
  final String title;
  final String? rating;
  PlanType? planType;
  int? numOfEpisodes;
  DateTime? watchedTime;
  int episodesWatched;
  int? userRating;

  Map<String, dynamic> toMap() {
    return {
      'id': malID,
      'poster': poster,
      'title': title,
      'mean': rating,
      'plan_type': planType == null ? null : planType!.type,
      'num_episodes': numOfEpisodes,
      'watched_time':
          watchedTime != null ? watchedTime!.millisecondsSinceEpoch : null,
      'num_episodes_watched': episodesWatched,
      'user_rating': userRating,
    };
  }
}
