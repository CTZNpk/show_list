import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/auth/controller/auth_controller.dart';
import 'package:show_list/features/auth/screens/auth_screen.dart';
import 'package:show_list/features/following_page/screens/following_screen.dart';
import 'package:show_list/features/home_page/screens/home_screen.dart';
import 'package:show_list/features/main_layout/controller/main_layout_controller.dart';
import 'package:show_list/features/my_list/screens/list_screen.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/features/profile_page/screens/profile_screen.dart';
import 'package:show_list/features/search_page/screens/search_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  static const routeName = '/main-layout';
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout>
    with TickerProviderStateMixin {
  int selectedPosition = 0;
  late CircularBottomNavigationController tabBarController;

  void updateBodyWithSetState(int selectedPos) {
    setState(() {
      selectedPosition = selectedPos;
    });
  }

  void signOut() async {
    await ref.read(authControllerProvider).signOut();
    setState(() {});
  }

  @override
  void initState() {
    tabBarController = CircularBottomNavigationController(selectedPosition);
    ref.read(mainLayoutControllerProvider).requestDataFromLocalSql();
    ref
        .read(profileControllerProvider)
        .getProfileDataFromFirebase(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person_2,
          ), //TODO Change this with the profile pic of the user
          onPressed: () {},
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: signOut,
                child: Text(
                  'Sign Out',
                  style: myTheme.textTheme.displayMedium,
                ),
              )
            ],
          ),
        ],
      ),
      body: _BodyDisplay(
        selectedPosition: selectedPosition,
      ),
      bottomNavigationBar: _BottomBarDisplay(
        updateSelectedPositonWithSetState: updateBodyWithSetState,
        navController: tabBarController,
      ),
    );
  }

  @override
  void dispose() {
    tabBarController.dispose();
    super.dispose();
  }
}

class _BodyDisplay extends StatelessWidget {
  _BodyDisplay({required this.selectedPosition});

  final int selectedPosition;

  @override
  Widget build(BuildContext context) {
    switch (selectedPosition) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const ListScreen();
      case 3:
        return FirebaseAuth.instance.currentUser == null
            ? const AuthScreen()
            : const FollowingScreen();
      default:
        return FirebaseAuth.instance.currentUser == null
            ? const AuthScreen() //TODO Auth Screen does not automatically change when we sign in
            : ProfileScreen(
                uid: FirebaseAuth.instance.currentUser!.uid,
              );
    }
  }
}

class _BottomBarDisplay extends StatelessWidget {
  const _BottomBarDisplay(
      {required this.updateSelectedPositonWithSetState,
      required this.navController});

  final Function updateSelectedPositonWithSetState;
  final CircularBottomNavigationController navController;

  List<TabItem> returnTabItems(BuildContext context) {
    final myTheme = Theme.of(context);
    return [
      TabItem(
        Icons.home,
        'Home',
        Colors.lime[900]!,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface),
      ),
      TabItem(
        Icons.search,
        'Search',
        myTheme.colorScheme.primary,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface),
      ),
      TabItem(
        Icons.list,
        'MyList',
        Colors.teal[400]!,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface),
      ),
      TabItem(
        Icons.feed,
        'Following',
        Colors.cyan[900]!,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface),
      ),
      TabItem(
        Icons.person,
        'Profile',
        Colors.purple[900]!,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    return CircularBottomNavigation(
      returnTabItems(context),
      controller: navController,
      barBackgroundColor: myTheme.scaffoldBackgroundColor,
      circleStrokeWidth: 0,
      backgroundBoxShadow: [BoxShadow(color: myTheme.scaffoldBackgroundColor)],
      selectedCallback: (selectedPos) =>
          updateSelectedPositonWithSetState(selectedPos),
      barHeight: 48,
    );
  }
}
