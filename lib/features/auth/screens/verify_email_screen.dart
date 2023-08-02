import 'package:flutter/material.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class VerifyEmailScreen extends StatelessWidget {
  static const routeName = '/verify-email';
  const VerifyEmailScreen({super.key, required this.email});

//TODO Add Timer and Move to Screen after verify
//TODO Also add logic to show when user is signed in but not verified
// TODO Also add resend logic

  final String email;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return Scaffold(
      body: ListView(
        children: [
          VerticalSpacing(size.height * 0.03),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'An email with a verification link has been sent to $email. Please check your email to verify',
              style: myTheme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          VerticalSpacing(size.height * 0.05),
          MyElevatedButton(
            label: 'Resend Email',
            labelIcon: Icons.email,
            imageUrl: null,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
