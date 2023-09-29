import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/auth/controller/auth_controller.dart';
import 'package:show_list/features/auth/screens/email_password_sign_in.dart';
import 'package:show_list/features/auth/screens/user_information_screen.dart';
import 'package:show_list/features/profile_page/controller/profile_controller.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class AuthScreen extends ConsumerWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({
    super.key,
  });

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    await ref
        .read(authControllerProvider)
        .signInUserWithGoogle(context: context);
    try {
      await ref
          .read(profileControllerProvider)
          .getProfileDataFromFirebase(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamed(context, UserInformationScreen.routeName);
      }
    }

    //TODO Navigate to The screen after google sign in
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sign In To Access the following feature',
            style: myTheme.textTheme.displayLarge,
          ),
          VerticalSpacing(size.height * 0.3),
          MyElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              EmailAndPasswordSignIn.routeName,
            ),
            backgroundColor: Colors.indigo[900]!,
            label: 'Sign In With Email',
            labelIcon: Icons.email,
            imageUrl: null,
          ),
          const VerticalSpacing(20),
          MyElevatedButton(
            onPressed: () => signInWithGoogle(ref, context),
            backgroundColor: Colors.indigo[900]!,
            label: 'Sign In With Google',
            labelIcon: null,
            imageUrl: 'http://pngimg.com/uploads/google/google_PNG19635.png',
          ),
          VerticalSpacing(size.height * 0.10),
        ],
      ),
    );
  }
}
