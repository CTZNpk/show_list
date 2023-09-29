import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/repository/user_information_repository.dart';
import 'package:show_list/shared/model/profile_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_profile_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';
import 'package:show_list/shared/utils/utils.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      firebaseStorage: FirebaseStorage.instance),
);

class ProfileRepository {
  ProfileRepository({
    required this.auth,
    required this.firestore,
    required this.firebaseStorage,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  Future savingData(
      {required BuildContext context,
      required String name,
      required File? profilePic,
      required String about,
      required List<ShortTMDBDataModel> topShows,
      required List<ShortTMDBDataModel> topMovies,
      required List<ShortMalData> topAnime,
      required List<String> followersList,
      required List<String> followingList,
      required ProviderRef ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          await storingFileAndReturnDownloadUrl('profilePic/$uid', profilePic);

      var userInfo = ProfileDataModel(
        uid: uid,
        userName: name,
        profilePic: photoUrl,
        about: about == ''
            ? 'New To Show List'
            : about, //TODO AppName Change What you get
        topShows: topShows,
        topAnime: topAnime,
        topMovies: topMovies,
        followersList: followersList,
        followingList: followingList,
      );

      await firestore.collection('users').doc(uid).set(userInfo.toMap());
      ref.read(userInformationRepositoryProvider).setProfileData(userInfo);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<String> storingFileAndReturnDownloadUrl(
      String storageLocation, File? file) async {
    if (file == null) {
      return 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
    }
    UploadTask uploadTask =
        firebaseStorage.ref().child(storageLocation).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
