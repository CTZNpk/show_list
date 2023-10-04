import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_profile_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';

class ProfileDataModel {
  ProfileDataModel({
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.about,
    required this.followersList,
    required this.followingList,
    required this.followingRequestList,
    required this.requestedPeople,
    this.followingCount = 0,
    this.followersCount = 0,
    required this.topMovies,
    required this.topShows,
    required this.topAnime,
  });

  factory ProfileDataModel.fromMap(Map data) {
    List<ShortTMDBDataModel> movies = [];
    List<ShortTMDBDataModel> shows = [];
    List<ShortMalData> anime = [];
    List<String> followersLists = [];
    List<String> followingLists = [];
    List<String> followingreqLists = [];
    List<String> requestedPeople = [];

    for (var items in data['topMovies']) {
      movies.add(ShortTMDBDataModel.fromMap(items, ShowType.movie));
    }

    for (var items in data['topShows']) {
      shows.add(ShortTMDBDataModel.fromMap(items, ShowType.show));
    }

    for (var items in data['topAnime']) {
      anime.add(ShortMalData.fromMap(items));
    }

    for (var items in data['followers_list']) {
      followersLists.add(items);
    }
    for (var items in data['following_list']) {
      followingLists.add(items);
    }

    for (var items in data['following_request_list']) {
      followingreqLists.add(items);
    }

    for (var items in data['requested_people']) {
      requestedPeople.add(items);
    }

    return ProfileDataModel(
      uid: data['uid'],
      userName: data['userName'],
      profilePic: data['profilePic'],
      about: data['about'],
      followingCount: data['following_count'],
      followersCount: data['followers_count'],
      followersList: followersLists,
      followingList: followingLists,
      followingRequestList: followingreqLists,
      requestedPeople: requestedPeople,
      topMovies: movies,
      topShows: shows,
      topAnime: anime,
    );
  }

  String uid;
  String userName;
  String profilePic;
  String about;
  int followingCount;
  int followersCount;
  List<String> followersList;
  List<String> followingList;
  List<String> followingRequestList;
  List<String> requestedPeople;
  List<ShortTMDBDataModel> topMovies;
  List<ShortTMDBDataModel> topShows;
  List<ShortMalData> topAnime;

  Map<String, dynamic> toMap() {
    List<Map<dynamic, dynamic>> movies = [];
    List<Map<dynamic, dynamic>> shows = [];
    List<Map<dynamic, dynamic>> animes = [];

    for (var movie in topMovies) {
      movies.add(movie.toMap());
    }

    for (var show in topShows) {
      shows.add(show.toMap());
    }

    for (var anime in topAnime) {
      animes.add(anime.toMap());
    }

    return {
      'uid': uid,
      'userName': userName,
      'profilePic': profilePic,
      'about': about,
      'following_count': followingCount,
      'followers_count': followersCount,
      'followers_list': followersList,
      'following_list': followingList,
      'following_request_list': followingRequestList,
      'requested_people': requestedPeople,
      'topMovies': movies,
      'topShows': shows,
      'topAnime': animes,
    };
  }

  ShortProfileModel toShortProfileData() {
    return ShortProfileModel(
      uid: uid,
      profilePic: profilePic,
      followersCount: followersCount,
      userName: userName,
    );
  }
}
