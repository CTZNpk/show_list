
import 'package:show_list/features/home_page/repository/mal_anime_data.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';

class GetAnimeFromSearch extends MalAnimeData {
  GetAnimeFromSearch({required this.query});
  final String query;
  @override
  Future<List<MalAnimeDataModel>> getData() async {
    String getRankingUrl = 'anime?q=$query&$fields&limit=15';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}
