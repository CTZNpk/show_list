import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/repository/profile_repository.dart';
import 'package:show_list/features/profile_page/repository/user_information_repository.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/model/profile_model.dart';
import 'package:show_list/shared/model/short_mal_data_model.dart';
import 'package:show_list/shared/model/short_tmdb_datamodel.dart';

final profileControllerProvider = Provider((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  final userInformationRepository = ref.read(userInformationRepositoryProvider);
  return ProfileController(
      ref: ref,
      profileRepository: profileRepository,
      userInformationRepository: userInformationRepository);
});

class ProfileController {
  ProfileController({
    required this.profileRepository,
    required this.ref,
    required this.userInformationRepository,
  });

  ProfileRepository profileRepository;
  UserInformationRepository userInformationRepository;
  ProviderRef ref;

  Future savingData(
    BuildContext context,
    String name,
    File? profilePic,
    String about,
    List<ShortTMDBDataModel> topMovies,
    List<ShortTMDBDataModel> topShows,
    List<ShortMalData> topAnime,
    List<String> followersList,
    List<String> followingList,
  ) async {
    await profileRepository.savingData(
      context: context,
      name: name,
      profilePic: profilePic,
      about: about,
      topMovies: topMovies,
      topShows: topShows,
      topAnime: topAnime,
      followersList: followersList,
      followingList: followingList,
      ref: ref,
    );
  }

  Future addToTopList(
      {required ShowType showType,
      ShortTMDBDataModel? tmdbData,
      ShortMalData? animeData}) async {
    await userInformationRepository.addToTopList(
        showType: showType, tmdbData: tmdbData, animeData: animeData);
  }

  Future removeFollower(ProfileDataModel profileData) async {
    await userInformationRepository.deleteFollower(profileData);
  }

  Future acceptRequest(ProfileDataModel profileData) async {
    await userInformationRepository.addFollowing(profileData);
    await userInformationRepository.addToFollower(profileData);
  }

  Future rejectRequest(ProfileDataModel follower) async {
    await userInformationRepository.rejectRequest(follower);
  }

  Future followRequest(ProfileDataModel profileData) async {
    await userInformationRepository
        .addtoFollowRequestList(profileData.toShortProfileData());
    await userInformationRepository.addToFollowerRequest(profileData);
  }

  Future unfollowPerson(ProfileDataModel profileData) async {
    await userInformationRepository
        .removeFollowing(profileData.toShortProfileData());
    await userInformationRepository.removeFollower(profileData);
  }

  Future getProfileDataFromFirebase(String uid) async {
    return await userInformationRepository.getProfileData(uid);
  }

  void removeProfile() {
    userInformationRepository.removeProfile();
  }

  ProfileDataModel? getProfileData() {
    return userInformationRepository.profileData;
  }
}
