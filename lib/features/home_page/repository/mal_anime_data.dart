import 'dart:convert';

import 'package:http/http.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';

abstract class MalAnimeData {
  final String apiUrl = 'https://api.myanimelist.net/v2/';
  String fields = 'fields=id,title,main_picture,mean,num_episodes,';
  //'fields=id,title,main_picture,related_anime,alternative_titles,start_date,synopsis,end_date,mean,rank,popularity,status,genres,num_episodes';
  final String clientId = '351028ea7ff2dbfd3e168810a70e7b90';

  Future getData(int pageNumber);

  Future getFromUrl(String completeUrl) async {
    final Map<String, String> headers = {
      'X-MAL-ClIENT-ID': '351028ea7ff2dbfd3e168810a70e7b90',
    };

    try {
      final response = await get(Uri.parse(completeUrl), headers: headers);
      List<ShortMalData> highestRatedAnime = [];
      Map data = jsonDecode(response.body);
      for (Map<String, dynamic> datum in data['data']) {
        highestRatedAnime.add(
          ShortMalData.fromMap(
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
  Future<List<ShortMalData>> getData(int pageNumber) async {
    int offsetNumber = (pageNumber - 1) * 20;
    String getRankingUrl =
        'anime/ranking?$fields&ranking_type=all&limit=20&offset=${offsetNumber.toString()}';
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
  Future<List<ShortMalData>> getData(int pageNumber) async {
    int offsetNumber = (pageNumber - 1) * 20;
    String getRankingUrl =
        'anime/ranking?$fields&ranking_type=bypopularity&limit=20&offset=${offsetNumber.toString()}';
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
  Future<List<ShortMalData>> getData(int pageNumber) async {
    int offsetNumber = (pageNumber - 1) * 20;
    String getRankingUrl =
        'anime/ranking?$fields&ranking_type=airing&limit=20&offset=${offsetNumber.toString()}';
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
  Future<List<ShortMalData>> getData(int pageNumber) async {
    int offsetNumber = (pageNumber - 1) * 20;
    String getRankingUrl =
        'anime/ranking?$fields&ranking_type=upcoming&limit=20&offset=${offsetNumber.toString()}';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await super.getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }
}

class GetAnimeDataFromID extends MalAnimeData {
  GetAnimeDataFromID({required this.malID});

  final String malID;
  @override
  Future<MalAnimeDataModel> getData(int pageNumber) async {
    fields =
        'fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,status,genres,num_episodes,related_anime';
    String getRankingUrl = 'anime/$malID?$fields';
    String completeUrl = '$apiUrl$getRankingUrl';

    try {
      return await getFromUrl(completeUrl);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getFromUrl(String completeUrl) async {
    final Map<String, String> headers = {
      'X-MAL-ClIENT-ID': '351028ea7ff2dbfd3e168810a70e7b90',
    };

    try {
      final response = await get(Uri.parse(completeUrl), headers: headers);
      Map data = jsonDecode(response.body);


      return MalAnimeDataModel.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }
}
