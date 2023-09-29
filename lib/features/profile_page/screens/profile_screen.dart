import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/shared/constants.dart';
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
      });
    });
    super.initState();
  }

  Future followPerson() async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).followPerson(profileData!);
    setState(() {
      weFollow = true;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return loading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                const VerticalSpacing(20),
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
                const VerticalSpacing(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                  ],
                ),
                //TODO edit profile button
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
