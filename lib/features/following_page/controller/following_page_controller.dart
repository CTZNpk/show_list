import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/following_page/respository/following_data.dart';
import 'package:show_list/features/following_page/respository/following_page_repository.dart';

final followingPageControllerProvider = Provider((ref) {
  final followingPageRepository = ref.read(followingPageRepositoryProvider);
  final followingDataRepository = ref.read(followingDataRepositoryProvider);
  return FollowingPageController(
    followingPageRepository: followingPageRepository,
    followingDataRepository: followingDataRepository,
  );
});

class FollowingPageController {
  FollowingPageController({
    required this.followingPageRepository,
    required this.followingDataRepository,
  });

  final FollowingPageRepository followingPageRepository;
  final FollowingData followingDataRepository;

  Future searchPeople(String query) async {
    return await followingPageRepository.searchPeople(query);
  }

  Future getFollowingDataFromSql() async {
    return await followingDataRepository.getFollowingDataFromSql();
  }
}
