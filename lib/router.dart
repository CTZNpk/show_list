import 'package:flutter/material.dart';
import 'package:show_list/features/auth/screens/auth_screen.dart';
import 'package:show_list/features/auth/screens/email_password_sign_in.dart';
import 'package:show_list/features/auth/screens/register_email_password.dart';
import 'package:show_list/features/auth/screens/verify_email_screen.dart';
import 'package:show_list/shared/info_screens/anime_screen.dart';
import 'package:show_list/shared/info_screens/movie_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
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

    case VerifyEmailScreen.routeName:
      String email = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => VerifyEmailScreen(
          email: email,
        ),
      );

    case MovieScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => MovieScreen(
          traktData: args[0],
          omdbData: args[1],
          heroUid: args[2],
        ),
      );
    case AnimeScreen.routeName:
      List<dynamic> args = settings.arguments as List<dynamic>;

      return MaterialPageRoute(
        builder: (context) => AnimeScreen(
          animeData: args[0],
          heroUid: args[1],
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
