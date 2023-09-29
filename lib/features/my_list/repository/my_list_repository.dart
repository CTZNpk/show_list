import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/shared/enums/plan_type.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/mal_anime_data_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/model/tmdb_datamodel.dart';
import 'package:uuid/uuid.dart';

final myListRepositoryProvider = Provider(
  (ref) => MyListRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);

class MyListRepository {
  MyListRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  Future storeToWatch({
    MalAnimeDataModel? animeData,
    TMDBDataModel? movieShowData,
  }) async {
    if (animeData == null && movieShowData == null) {
      debugPrint(
          'Error In Storing to database as both animeData and MovieShowData cannot be null');
      return;
    }
    if (auth.currentUser != null) {
      final followerUid = const Uuid().v4();
      if (animeData != null) {
        animeData.watchedTime = DateTime.now();
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('anime')
            .doc(animeData.malId)
            .set(animeData.toShortMalData().toMap());

        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('followers')
            .doc(followerUid)
            .set(
          {
            'info': animeData.planType != PlanType.finished
                ? '${ref.read(profileControllerProvider).getProfileData()!.userName} added ${animeData.title} to ${animeData.planType!.type} on ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'
                : '${ref.read(profileControllerProvider).getProfileData()!.userName} added ${animeData.title} to ${animeData.planType!.type} on ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} with rating ${animeData.userRating}',
            'time': animeData.watchedTime!.millisecondsSinceEpoch,
          },
        );
        if (animeData.planType == PlanType.finished &&
            animeData.userRating! >= 9) {
          ref.read(profileControllerProvider).addToTopList(
              showType: ShowType.anime, animeData: animeData.toShortMalData());
        }
      } else {
        movieShowData!.watchedTime = DateTime.now();
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection(movieShowData.showType.name)
            .doc(movieShowData.tmdbID)
            .set(movieShowData.toShortTMDBDataModel().toMap());
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('followers')
            .doc(followerUid)
            .set(
          {
            'info': movieShowData.planType != PlanType.finished
                ? '${ref.read(profileControllerProvider).getProfileData()!.userName} added ${movieShowData.title} to ${movieShowData.planType!.type} on ${movieShowData.watchedTime!.day}-${movieShowData.watchedTime!.month}-${movieShowData.watchedTime!.year}'
                : '${ref.read(profileControllerProvider).getProfileData()!.userName} added ${movieShowData.title} to ${movieShowData.planType!.type} on ${movieShowData.watchedTime!.day}-${movieShowData.watchedTime!.month}-${movieShowData.watchedTime!.year} with rating ${movieShowData.userRating}',
            'time': movieShowData.watchedTime!.millisecondsSinceEpoch,
          },
        );
        if (movieShowData.planType == PlanType.finished &&
            movieShowData.userRating! >= 9) {
          await ref.read(profileControllerProvider).addToTopList(
                showType: movieShowData.showType,
                tmdbData: movieShowData.toShortTMDBDataModel(),
              );
        }
      }
    }
  }

  Future getShowTypeDataFromFirebase(ShowType showType) async {
    if (auth.currentUser != null) {
      Map<String, ShortTMDBDataModel> movieList = {};
      final listOfMovieData = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection(showType.name)
          .get();
      for (var doc in listOfMovieData.docs) {
        ShortTMDBDataModel data = ShortTMDBDataModel.fromMap(
          doc.data(),
          showType,
        );
        movieList[data.tmdbID] = data;
      }
      return movieList;
    }
    return null;
  }

  Future getAnimeData() async {
    if (auth.currentUser != null) {
      Map<String, ShortMalData> animeList = {};
      final listOfAnimeData = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('anime')
          .get();
      for (var doc in listOfAnimeData.docs) {
        ShortMalData data = ShortMalData.fromMap(
          doc.data(),
        );
        animeList[data.malID!] = data;
      }
      return animeList;
    }
    return null;
  }

  Future getDataFromFirebaseFromID(String dataID, ShowType showType) async {
    if (auth.currentUser != null) {
      if (showType == ShowType.anime) {
        final animeDataMap = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('anime')
            .doc(dataID)
            .get();
        if (animeDataMap.data() != null) {
          return MalAnimeDataModel.fromMap(animeDataMap.data()!);
        }
      } else {
        final movieShowDataMap = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection(showType.name)
            .doc(dataID)
            .get();
        if (movieShowDataMap.data() != null) {
          final showData =
              TMDBDataModel.fromMap(movieShowDataMap.data()!, showType);
          return showData;
        }
      }
    }
    return null;
  }
}
