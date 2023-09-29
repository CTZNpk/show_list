import 'package:flutter/material.dart';
import 'package:show_list/features/auth/screens/auth_screen.dart';
import 'package:show_list/features/auth/screens/email_password_sign_in.dart';
import 'package:show_list/features/auth/screens/register_email_password.dart';
import 'package:show_list/features/auth/screens/user_information_screen.dart';
import 'package:show_list/features/main_layout/screens/main_layout.dart';
import 'package:show_list/features/profile_page/screens/profile_screen.dart';
import 'package:show_list/features/search_page/widgets/display_filters.dart';
import 'package:show_list/features/search_page/widgets/display_search_results.dart';
import 'package:show_list/shared/enums/show_type.dart';
import 'package:show_list/shared/info_screens/add_to_watchlist_prompt.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';
import 'package:show_list/shared/info_screens/rating_prompt.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainLayout.routeName:
      return MaterialPageRoute(
        builder: (context) => const MainLayout(),
      );
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      );
    case EmailAndPasswordSignIn.routeName:
      return MaterialPageRoute(
        builder: (context) => const EmailAndPasswordSignIn(),
      );

    case EmailAndPasswordRegister.routeName:
      return MaterialPageRoute(
        builder: (context) => const EmailAndPasswordRegister(),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case ProfileScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => ProfileScreen(
          uid: args[0],
        ),
      );

    case DisplayFilters.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => DisplayFilters(
          filterSearch: args[0] as FilterSearchWrapper,
          close: args[1] as Function,
          showType: args[2] as ShowType,
        ),
      );

    case MovieScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => MovieScreen(
          tmdbID: args[0],
          showType: args[1],
          planType: args[2],
        ),
      );
    case AnimeScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => AnimeScreen(
          malID: args[0],
          planType: args[1],
        ),
      );
    case ShowAddToWatchlistPrompt.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => ShowAddToWatchlistPrompt(
          showType: args[0],
          data: args[1],
        ),
      );
    case RatePrompt.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => RatePrompt(
          data: args[0],
          showType: args[1],
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('This Page Does not Exist'),
          ),
        ),
      );
  }
}
