import 'package:show_list/shared/enums/show_type.dart';

class TraktDataModel {
  TraktDataModel({
    required this.title,
    required this.imdbID,
    required this.trailer,
    required this.traktRating,
    required this.airedEpisodes,
    required this.showType,
  });

  final String title;
  final String? imdbID;
  final String? trailer;
  final double? traktRating;
  final int? airedEpisodes;
  final ShowType showType;
}
