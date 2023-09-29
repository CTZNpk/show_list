import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/auth/controller/auth_controller.dart';
import 'package:show_list/features/auth/screens/user_information_screen.dart';
import 'package:show_list/features/auth/widgets/my_text_form_fields.dart';
import 'package:show_list/shared/constants.dart';
import 'package:show_list/shared/widgets/my_elevated_button.dart';

class EmailAndPasswordRegister extends ConsumerStatefulWidget {
  static const routeName = '/email-password-register';
  const EmailAndPasswordRegister({super.key});

  @override
  ConsumerState<EmailAndPasswordRegister> createState() =>
      _EmailAndPasswordSignInState();
}

class _EmailAndPasswordSignInState
    extends ConsumerState<EmailAndPasswordRegister> {
  final TextEditingController _controllerForEmail = TextEditingController();
  final TextEditingController _controllerForPassword = TextEditingController();
  final TextEditingController _controllerForConfirmPassword =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider).creatingUserWithEmailAndPassword(
            email: _controllerForEmail.text.trim(),
            password: _controllerForPassword.text.trim(),
            context: context,
          );
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          UserInformationScreen.routeName,
          arguments: _controllerForEmail.text.trim(),
        );
      }
    }
  }

  @override
  void dispose() {
    _controllerForEmail.dispose();
    _controllerForPassword.dispose();
    _controllerForConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: myTheme.scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [
          VerticalSpacing(size.height * 0.03),
          Center(
            child: Text(
              'Enter your Email And Password ',
              style: myTheme.textTheme.displayLarge,
            ),
          ),
          VerticalSpacing(size.height * 0.05),
          Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextFormFields(
                  validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                  controller: _controllerForEmail,
                  obscureText: false,
                  label: 'Email',
                ),
                VerticalSpacing(size.height * 0.05),
                MyTextFormFields(
                  validator: (val) => val!.isEmpty
                      ? 'Password should be greater than 6 characters'
                      : null,
                  controller: _controllerForPassword,
                  obscureText: true,
                  label: 'Password',
                ),
                VerticalSpacing(size.height * 0.05),
                MyTextFormFields(
                  validator: (value) =>
                      value != _controllerForPassword.text.trim()
                          ? 'Confirm Password does not match your password'
                          : null,
                  controller: _controllerForConfirmPassword,
                  obscureText: true,
                  label: 'Confirm Password',
                ),
                VerticalSpacing(size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? Click here to ',
                      style: myTheme.textTheme.displayMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                VerticalSpacing(size.height * 0.05),
                MyElevatedButton(
                  onPressed: registerWithEmail,
                  backgroundColor: Colors.indigo[900]!,
                  label: 'Sign Up',
                  imageUrl: null,
                  labelIcon: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
