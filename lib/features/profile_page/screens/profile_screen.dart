import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/features/profile_page/repository/user_information_repository.dart';
import 'package:show_list/features/profile_page/screens/display_people.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/list_type.dart';
import 'package:show_list/shared/loading.dart';
import 'package:show_list/shared/model/profile_model.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'profile-screen';
  const ProfileScreen({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  ProfileDataModel? profileData;
  bool weFollow = false;
  bool weRequested = false;
  bool loading = true;

  @override
  void initState() {
    ref
        .read(profileControllerProvider)
        .getProfileDataFromFirebase(widget.uid)
        .then((value) {
      setState(() {
        profileData = value;
        loading = false;
        weFollow = profileData!.followersList.any((element) =>
            element ==
            ref.read(profileControllerProvider).getProfileData()!.uid);
        weRequested = profileData!.followingRequestList.any((element) =>
            element ==
            ref.read(profileControllerProvider).getProfileData()!.uid);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(userInformationRepositoryProvider).addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    });
    super.initState();
  }

  Future followPerson() async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).followRequest(profileData!);
    setState(() {
      weRequested = true;
      loading = false;
    });
  }

  Future unfollowPerson() async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).unfollowPerson(profileData!);
    setState(() {
      weFollow = false;
      loading = false;
    });
  }

  @override
  void dispose() {
    ref.watch(userInformationRepositoryProvider).removeListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return loading
        ? const LoadingScreen()
        : Scaffold(
            body: ListView(
              children: [
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? const SizedBox.shrink()
                    : AppBar(),
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UnconstrainedBox(
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                DisplayPeople.routeName,
                                arguments: [
                                  profileData!.followingRequestList,
                                  'Requests',
                                  ListType.requestList,
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color:
                                          myTheme.colorScheme.primaryContainer,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      border: Border.all(
                                        color: Colors.purple[900]!,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.people),
                                    ),
                                  ),
                                  profileData!.followingRequestList.isEmpty
                                      ? const SizedBox.shrink()
                                      : Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.purple[900],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              profileData!
                                                  .followingRequestList.length
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const VerticalSpacing(10),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.purple[900],
                    radius: 105,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(profileData!.profilePic),
                    ),
                  ),
                ),
                const VerticalSpacing(20),
                Center(
                  child: Text(
                    profileData!.userName,
                    style: myTheme.textTheme.displayLarge,
                  ),
                ),
                const VerticalSpacing(30),
                Text(
                  profileData!.about,
                  style: myTheme.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const VerticalSpacing(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, DisplayPeople.routeName,
                            arguments: [
                              profileData!.followersList,
                              'Followers',
                              ListType.followersList,
                            ]),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: myTheme.colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            border: Border.all(color: Colors.purple[900]!),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Followers',
                                style: myTheme.textTheme.displayLarge,
                              ),
                              Text(
                                profileData!.followersCount.toString(),
                                style: myTheme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, DisplayPeople.routeName,
                            arguments: [
                              profileData!.followingList,
                              'Following',
                              ListType.followingList,
                            ]),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: myTheme.colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            border: Border.all(color: Colors.purple[900]!),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Following',
                                style: myTheme.textTheme.displayLarge,
                              ),
                              Text(
                                profileData!.followingCount.toString(),
                                style: myTheme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const VerticalSpacing(20),
                const VerticalSpacing(30),
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? const SizedBox.shrink()
                    : weFollow
                        ? MyElevatedButton(
                            label: 'Unfollow',
                            labelIcon: null,
                            imageUrl: null,
                            backgroundColor: Colors.purple[900]!,
                            onPressed: unfollowPerson,
                          )
                        : weRequested
                            ? Center(
                                child: Text(
                                  'Requested',
                                  style: myTheme.textTheme.displayLarge,
                                ),
                              )
                            : MyElevatedButton(
                                label: 'Follow',
                                labelIcon: null,
                                imageUrl: null,
                                backgroundColor: Colors.purple[900]!,
                                onPressed: followPerson,
                              ),
                profileData!.topMovies.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Top Movies',
                          style: myTheme.textTheme.displayLarge!
                              .copyWith(color: Colors.purple[900]),
                        ),
                      )
                    : const SizedBox.shrink(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileData!.topMovies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading: Image.network(
                            profileData!.topMovies[index].poster!),
                        title: SizedBox(
                          child: Text(
                            profileData!.topMovies[index].title,
                            style: myTheme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                profileData!.topShows.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Top Shows',
                          style: myTheme.textTheme.displayLarge!
                              .copyWith(color: Colors.purple[900]),
                        ),
                      )
                    : const SizedBox.shrink(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileData!.topShows.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading:
                            Image.network(profileData!.topShows[index].poster!),
                        title: SizedBox(
                          child: Text(
                            profileData!.topShows[index].title,
                            style: myTheme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                profileData!.topAnime.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Top Anime',
                          style: myTheme.textTheme.displayLarge!
                              .copyWith(color: Colors.purple[900]),
                        ),
                      )
                    : const SizedBox.shrink(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileData!.topAnime.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading:
                            Image.network(profileData!.topAnime[index].poster!),
                        title: SizedBox(
                          child: Text(
                            profileData!.topAnime[index].title,
                            style: myTheme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
