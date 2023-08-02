import 'dart:convert';

import 'package:http/http.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';

abstract class MalAnimeData {
  final String apiUrl = 'https://api.myanimelist.net/v2/';
  final String fields =
      'fields=id,title,main_picture,alternative_titles,start_date,synopsis,end_date,mean,rank,popularity,status,genres,num_episodes';
  final String clientId = '351028ea7ff2dbfd3e168810a70e7b90';

  Future getData();

  Future<List<MalAnimeDataModel>> getFromUrl(String completeUrl) async {
    final Map<String, String> headers = {
      'X-MAL-ClIENT-ID': '351028ea7ff2dbfd3e168810a70e7b90',
    };

    try {
      final response = await get(Uri.parse(completeUrl), headers: headers);
      List<MalAnimeDataModel> highestRatedAnime = [];
      Map data = jsonDecode(response.body);
      for (Map<String, dynamic> datum in data['data']) {
        highestRatedAnime.add(
          MalAnimeDataModel.fromMap(
            datum['node'],
          ),
        );
      }
      return highestRatedAnime;
    } catch (e) {
      rethrow;
    }
  }
}

class GetAnimeFromRanking extends MalAnimeData {
  @override
  Future<List<MalAnimeDataModel>> getData() async {
    String getRankingUrl = 'anime/ranking?$fields&ranking_type=all&limit=50';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}
class GetMostPopularAnime extends MalAnimeData {
  @override
  Future<List<MalAnimeDataModel>> getData() async {
    String getRankingUrl = 'anime/ranking?$fields&ranking_type=bypopularity&limit=50';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}

class GetAiringAnime extends MalAnimeData {
  @override
  Future<List<MalAnimeDataModel>> getData() async {
    String getRankingUrl = 'anime/ranking?$fields&ranking_type=airing&limit=30';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}
class GetUpcomingAnime extends MalAnimeData {
  @override
  Future<List<MalAnimeDataModel>> getData() async {
    String getRankingUrl = 'anime/ranking?$fields&ranking_type=upcoming&limit=30';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}
