import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/shared/model/short_profile_model.dart';

final followingPageRepositoryProvider = Provider(
  (ref) => FollowingPageRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class FollowingPageRepository {
  FollowingPageRepository({required this.firestore});

  final FirebaseFirestore firestore;

  Future searchPeople(String query) async {
    final response = await firestore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: query)
        .where('userName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    List<ShortProfileModel> results = [];

    for (var document in response.docs) {
      final data = ShortProfileModel.fromMap(
        document.data(),
      );
      if (data.uid != FirebaseAuth.instance.currentUser!.uid) {
        results.add(data);
      }
    }

    return results;
  }
}
