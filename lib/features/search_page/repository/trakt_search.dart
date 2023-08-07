import 'package:show_list/features/home_page/repository/trakt_data.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/trakt_data_model.dart';
import 'package:trakt_dart/trakt_dart.dart';

class TraktSearchMovie extends TraktData{
  TraktSearchMovie({required this.query});
  String query ;

  @override
    Future<List<TraktDataModel>> getData() async {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final searchResults= await traktManager.search.searchTextQuery(
        query,
        [SearchType.movie],
          extendedFull: true,);

      List<TraktDataModel> traktDataList = [];

      for (var searchMovie in searchResults) {
        if(searchMovie.movie!.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: searchMovie.movie!.title,
            imdbID: searchMovie.movie!.ids.imdb,
            trailer: searchMovie.movie!.trailer,
            traktRating: searchMovie.movie!.rating,
            airedEpisodes: null,
            showType: ShowType.movie,
          ),
        );
      }
      return traktDataList;
    }
}

class TraktSearchShow extends TraktData{
  TraktSearchShow({required this.query});
  String query;

  @override
    Future<List<TraktDataModel>> getData() async {
      final traktManager = TraktManager(
          clientId: traktClientId,
          clientSecret: traktClientSecret,
          redirectURI: '');
      final searchResults= await traktManager.search.searchTextQuery(
        query,
        [SearchType.show],
          extendedFull: true,);

      List<TraktDataModel> traktDataList = [];

      for (var searchShow in searchResults) {
        if(searchShow.show!.ids.imdb == null) continue;
        traktDataList.add(
          TraktDataModel(
            title: searchShow.show!.title,
            imdbID: searchShow.show!.ids.imdb,
            trailer: searchShow.show!.trailer,
            traktRating: searchShow.show!.rating,
            airedEpisodes: searchShow.show!.airedEpisodes,
            showType: ShowType.show,
          ),
        );
      }
      return traktDataList;
    }
}
