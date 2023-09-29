import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/shared/model/following_string_model.dart';
import 'package:show_list/shared/model/profile_model.dart';
import 'package:show_list/shared/sql_service/sql_services.dart';

final followingDataRepositoryProvider = ChangeNotifierProvider(
  (ref) => FollowingData(ref: ref, firestore: FirebaseFirestore.instance),
);

class FollowingData with ChangeNotifier {
  FollowingData({
    required this.ref,
    required this.firestore,
  });

  ChangeNotifierProviderRef<Object?> ref;
  FirebaseFirestore firestore;
  List<FollowingStringModel> followingData = [];
  DateTime latestTime = DateTime(2000);

  Future getFollowingDataFromSql() async {
    followingData = await ref.read(sqlHelperProvider).readLocalFollowingData();
    for (var following in followingData) {
      if (following.dataDate.millisecondsSinceEpoch >
          latestTime.millisecondsSinceEpoch) {
        latestTime = following.dataDate;
      }
    }
    await _getFollowingDataFromFirebase();
    return followingData;
  }

  Future _getFollowingDataFromFirebase() async {
    ProfileDataModel profileData =
        ref.read(profileControllerProvider).getProfileData()!;

    DateTime latest = DateTime(2000);

    for (var uids in profileData.followingList) {
      final docs = await firestore
          .collection('users')
          .doc(uids)
          .collection('followers')
          .where(
            'time',
            isGreaterThan: latestTime.millisecondsSinceEpoch,
          )
          .get();
      for (var doc in docs.docs) {
        final data = FollowingStringModel.fromMap(doc.data());
        if (latest.millisecondsSinceEpoch <
            data.dataDate.millisecondsSinceEpoch) {
          latest = data.dataDate;
        }
        await ref.read(sqlHelperProvider).insertIntoLocalFollowingData(data);
        followingData.add(data);
      }
    }
  }

  List getFollowingData() {
    return followingData;
  }
}
