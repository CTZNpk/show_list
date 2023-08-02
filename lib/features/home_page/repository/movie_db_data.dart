import 'dart:convert';

import 'package:http/http.dart';

abstract class MovieDbData {
  MovieDbData({
    required this.imdbID,
  });

  final String apiUrl = 'https://moviesdatabase.p.rapidapi.com/titles/';
  final String imdbID;

  Future<String> getData();
}

class GetImdbRating extends MovieDbData {
  GetImdbRating({required super.imdbID});

  @override
  Future<String> getData() async {
   try {
      final completeUrl = Uri.parse('$apiUrl$imdbID/ratings');
      Response response = await get(completeUrl, headers: {
        'X-RapidAPI-Key': '22851e0332msh3161178955f86dcp1bdc54jsn3be80cfd6082',
        'X-RapidAPI-Host': 'moviesdatabase.p.rapidapi.com'
      });
      Map data = jsonDecode(response.body);
      return data['results']['averageRating'].toString();
    } catch (e) {
      rethrow;
    }
  }
}
