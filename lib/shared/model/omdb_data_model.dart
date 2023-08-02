class OmdbDataModel {
  OmdbDataModel({
    required this.year,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.awards,
    required this.rating,
  });

  factory OmdbDataModel.fromMap(Map<dynamic, dynamic> map) {
    List<Rating> ratings = [];
    for (var rating in map['Ratings']) {
      final isIMDb = rating['Source'] == 'Internet Movie Database';
      if(isIMDb) continue;
      ratings.add(
        Rating(
          source: isIMDb ? 'IMDb' : rating['Source'] ?? '',
          value: rating['Value'] ?? '',
          isIMDb: isIMDb,
        ),
      );
    }

    return OmdbDataModel(
      year: map['Year'] ?? '',
      genre: map['Genre'] ?? '',
      director: map['Director'] ?? '',
      writer: map['Writer'] ?? '',
      actors: map['Actors'] ?? '',
      plot: map['Plot'] ?? '',
      poster: map['Poster'] ?? '',
      awards: map['Awards'] ?? '',
      rating: ratings,
    );
  }

  final String year;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String poster;
  final String awards;
  final List<Rating> rating;
}

class Rating {
  Rating({
    required this.source,
    required this.value,
    required this.isIMDb,
  });

  final String source;
  final String value;
  final bool isIMDb;
}
