class MalAnimeDataModel {
  MalAnimeDataModel({
    required this.malId,
    required this.title,
    required this.mainPicture,
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
  });

  factory MalAnimeDataModel.fromMap(Map<dynamic,dynamic> map){


    List<String> altTitles = [];
    for(String name in map['alternative_titles']['synonyms']){
    altTitles.add(name);
    }
    altTitles.add(map['alternative_titles']['en']?? '');
    altTitles.add(map['alternative_titles']['ja'] ?? '');


    List<String> genresSub = [];
    for(var gen in map['genres']){
      genresSub.add(gen['name']);
    }
    double? rating = map['mean'] == null? null: map['mean'] is double ? map['mean']: map['mean'].toDouble();

    return MalAnimeDataModel(
      malId : map['id'].toString(),
      title: map['title'],
      mainPicture: map['main_picture']['medium']?? map['main_picture']['large'],
      alternativeTitle: altTitles,
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      rating: rating,
      rank: map['rank'],
      popularity: map['popularity'],
      status: map['status'] ?? '',
      genres: genresSub,
      numOfEpisodes: map['num_episodes'] ?? 0,
      overview: map['synopsis'],
    );

  }

  final String malId;
  final String title;
  final String mainPicture;
  final List<String> alternativeTitle;
  final String startDate;
  final String endDate;
  final double? rating;
  final int? rank;
  final int? popularity;
  final String status;
  final List<String> genres;
  final int numOfEpisodes;
  final String overview;
}
