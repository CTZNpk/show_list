enum GenresMovie {
  action('28'),
  adventure('12'),
  animation('16'),
  comedy('35'),
  crime('80'),
  documentary('99'),
  drama('18'),
  family('10751'),
  fantasy('14'),
  history('36'),
  horror('27'),
  music('10402'),
  mystery('9648'),
  romance('10749'),
  scienceFiction('878'),
  tvMovie('10770'),
  thriller('53'),
  war('10752'),
  western('37');

  final String type;
  const GenresMovie(this.type);

  factory GenresMovie.fromID(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}

enum GenresShows{
  actionAndadventure('10759'),
  animation('16'),
  comedy('35'),
  crime('80'),
  documentary('99'),
  drama('18'),
  family('10751'),
  kids('10762'),
  news('10763'),
  reality('10764'),
  sciFiAndFantasy('10765'),
  soap('10766'),
  talk('10767'),
  warAndPolitics('10768'),
  mystery('9648'),
  western('37');

  final String type;
  const GenresShows(this.type);

  factory GenresShows.fromID(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}
