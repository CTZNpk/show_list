import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:show_list/features/auth/screens/auth_screen.dart';
import 'package:show_list/features/home_page/screens/home_screen.dart';
import 'package:show_list/features/search_page/screens/search_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  int selectedPosition = 0;
  late CircularBottomNavigationController tabBarController;

  void updateBodyWithSetState(int selectedPos) {
    setState(() {
      selectedPosition = selectedPos;
    });
  }

  @override
  void initState() {
    tabBarController = CircularBottomNavigationController(selectedPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person_2,
          ), //TODO Change this with the profile pic of the user
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ), //TODO add search functionality / move to search screen
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ), //TODO add dashboard from the right
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

  final List<Widget> bodyWidgets = [
    const HomeScreen(),
    const SearchScreen(),
    const Scaffold(
      body: Text('MyList'),
    ),
    const AuthScreen(),
    const AuthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return bodyWidgets[selectedPosition];
  }
}

class _BottomBarDisplay extends StatelessWidget {
  const _BottomBarDisplay(
      {required this.updateSelectedPositonWithSetState,
      required this.navController});

  final Function updateSelectedPositonWithSetState;
  final CircularBottomNavigationController navController;


  List<TabItem> returnTabItems(BuildContext context){
    final myTheme = Theme.of(context);
  return 
    [
      TabItem(
        Icons.home,
        'Home',
        Colors.lime[900]!,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface)
      ),
      TabItem(
        Icons.search,
        'Search',
        myTheme.colorScheme.primary,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface)
      ),
      TabItem(
        Icons.list,
        'MyList',
        myTheme.colorScheme.primary,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface)
      ),
      TabItem(
        Icons.feed,
        'Following',
        myTheme.colorScheme.primary,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface)
      ),
      TabItem(
        Icons.person,
        'Profile',
        myTheme.colorScheme.primary,
        labelStyle: TextStyle(color: myTheme.colorScheme.onSurface)
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
