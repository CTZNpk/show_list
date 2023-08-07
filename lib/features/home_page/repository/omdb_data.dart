import 'dart:convert';
import 'package:http/http.dart';
import 'package:show_list/shared/model/omdb_data_model.dart';

abstract class OmdbData {
  OmdbData({
    required this.imdbID,
  });

  final String apiKey = 'fabf02c6';
  final String apiUrl = 'http://www.omdbapi.com/?i=';
  final String imdbID;

  Future<OmdbDataModel> getData();
}

class GetShowData extends OmdbData {
  GetShowData({required super.imdbID});

  @override
  Future<OmdbDataModel> getData() async {
    final completeUrl = Uri.parse('$apiUrl$imdbID&apikey=$apiKey');
    try {
      Response response = await get(completeUrl);
      Map data = jsonDecode(response.body);
      if (data['response'] == 'False') {
        throw 'The Omdb Data was not found for $imdbID';
      }
      final omdbData = OmdbDataModel.fromMap(data);
      return omdbData;
    } catch (e) {
      rethrow;
    }
  }
}
