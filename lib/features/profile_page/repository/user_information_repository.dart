import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/profile_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_profile_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';

final userInformationRepositoryProvider = ChangeNotifierProvider(
  (ref) => UserInformationRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class UserInformationRepository with ChangeNotifier {
  UserInformationRepository({required this.auth, required this.firestore});

  FirebaseAuth auth;
  FirebaseFirestore firestore;
  ProfileDataModel? profileData;

  Future getProfileData(String uid) async {
    if (profileData != null && uid == auth.currentUser!.uid) {
      return profileData;
    }
    final response = await firestore.collection('users').doc(uid).get();
    Map data = response.data()!;
    if (uid == auth.currentUser!.uid) {
      if(data == {}){
        return null;
      }
      profileData = ProfileDataModel.fromMap(data);
      notifyListeners();
    }

    return ProfileDataModel.fromMap(data);
  }

  Future addToTopList(
      {ShortTMDBDataModel? tmdbData,
      ShortMalData? animeData,
      required ShowType showType}) async {
    List<Map> data = [];
    if (showType == ShowType.anime) {
      print('FINE TILL NOW');
      profileData!.topAnime.add(animeData!);
      print('PROFILE IS NOT NULL HAHAHA');
      for (var movie in profileData!.topAnime) {
        data.add(movie.toMap());
      }
      await firestore
          .collection('users')
          .doc(profileData!.uid)
          .update({'topAnime': data});
    } else if (showType == ShowType.show) {
      profileData!.topShows.add(tmdbData!);
      for (var movie in profileData!.topShows) {
        data.add(movie.toMap());
      }
      await firestore
          .collection('users')
          .doc(profileData!.uid)
          .update({'topShows': data});
    } else {
      profileData!.topMovies.add(tmdbData!);
      for (var movie in profileData!.topMovies) {
        data.add(movie.toMap());
      }
      await firestore
          .collection('users')
          .doc(profileData!.uid)
          .update({'topMovies': data});
    }

    notifyListeners();
  }

  Future removeFollower(ProfileDataModel follower) async {
    follower.followersCount--;
    follower.followersList.remove(profileData!.uid);

    await firestore.collection('users').doc(follower.uid).update(
      {
        'followers_count': follower.followersCount,
        'followers_list': follower.followersList,
      },
    );
  }

  Future removeFollowing(ShortProfileModel following) async {
    profileData!.followingCount--;
    profileData!.followingList.remove(following.uid);

    notifyListeners();
    await firestore.collection('users').doc(profileData!.uid).update(
      {
        'following_count': profileData!.followingCount,
        'following_list': profileData!.followingList,
      },
    );
  }

  Future addToFollower(ProfileDataModel follower) async {
    follower.followersCount++;
    follower.followersList.add(profileData!.uid);

    await firestore.collection('users').doc(follower.uid).update(
      {
        'followers_count': follower.followersCount,
        'followers_list': follower.followersList,
      },
    );
  }

  Future addFollowing(ShortProfileModel following) async {
    profileData!.followingCount++;
    profileData!.followingList.add(following.uid);

    notifyListeners();
    await firestore.collection('users').doc(profileData!.uid).update(
      {
        'following_count': profileData!.followingCount,
        'following_list': profileData!.followingList,
      },
    );
  }

  void setProfileData(ProfileDataModel profile) {
    profileData = profile;
    notifyListeners();
  }
}
