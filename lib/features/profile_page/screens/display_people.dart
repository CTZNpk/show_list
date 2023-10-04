import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/features/profile_page/repository/user_information_repository.dart';
import 'package:show_list/features/profile_page/screens/profile_screen.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/enums/list_type.dart';
import 'package:show_list/shared/loading.dart';
import 'package:show_list/shared/model/profile_model.dart';

class DisplayPeople extends ConsumerStatefulWidget {
  static const routeName = '/display-people';
  const DisplayPeople({
    super.key,
    required this.people,
    required this.title,
    required this.listType,
  });
  final List<String> people;
  final String title;
  final ListType listType;

  @override
  ConsumerState<DisplayPeople> createState() => _DisplayPeopleState();
}

class _DisplayPeopleState extends ConsumerState<DisplayPeople> {
  bool loading = true;
  List<ProfileDataModel> peopleData = [];

  void getPeopleData() async {
    for (String uid in widget.people) {
      final data = await ref
          .read(profileControllerProvider)
          .getProfileDataFromFirebase(uid);
      peopleData.add(data);
    }
    setState(() {
      loading = false;
    });
  }

  Future unfollowPerson(ProfileDataModel user) async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).unfollowPerson(user);
    setState(() {
      loading = false;
    });
  }

  Future removeFollower(ProfileDataModel user) async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).removeFollower(user);
    setState(() {
      loading = false;
    });
  }

  Future acceptRequest(ProfileDataModel user) async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).acceptRequest(user);
    setState(() {
      loading = false;
    });
  }

  Future rejectRequest(ProfileDataModel user) async {
    setState(() {
      loading = true;
    });
    await ref.read(profileControllerProvider).rejectRequest(user);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getPeopleData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(userInformationRepositoryProvider).addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    });
    super.initState();
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
            appBar: AppBar(
              title: Text(
                widget.title,
                style: myTheme.textTheme.displayLarge,
              ),
            ),
            body: widget.people.isEmpty
                ? Center(
                    child: Text(
                      'No one to see here',
                      style: myTheme.textTheme.displayLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: peopleData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            peopleData[index].profilePic,
                          ),
                        ),
                        title: Text(
                          peopleData[index].userName,
                          style: myTheme.textTheme.displayMedium,
                        ),
                        trailing: widget.listType == ListType.followingList
                            ? InkWell(
                                onTap: () => unfollowPerson(peopleData[index]),
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: const Center(
                                    child: Text('Unfollow'),
                                  ),
                                ),
                              )
                            : widget.listType == ListType.followersList
                                ? InkWell(
                                    onTap: () =>
                                        removeFollower(peopleData[index]),
                                    child: Container(
                                      height: 35,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.red[900],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: const Center(
                                        child: Text('Remove'),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 35,
                                    width: 170,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              acceptRequest(peopleData[index]),
                                          child: Container(
                                            height: 35,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[700],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: const Center(
                                              child: Text('Accept'),
                                            ),
                                          ),
                                        ),
                                        const HorizontalSpacing(10),
                                        InkWell(
                                          onTap: () =>
                                              rejectRequest(peopleData[index]),
                                          child: Container(
                                            height: 35,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.red[900],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: const Center(
                                              child: Text('Reject'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                        tileColor: index % 2 == 1
                            ? myTheme.scaffoldBackgroundColor
                            : myTheme.colorScheme.secondary,
                        onTap: () => Navigator.popAndPushNamed(
                            context, ProfileScreen.routeName,
                            arguments: [peopleData[index].uid]),
                      );
                    },
                  ),
          );
  }
}
