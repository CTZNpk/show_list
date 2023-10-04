import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:show_list/features/auth/screens/auth_screen.dart';
import 'package:show_list/features/main_layout/screens/main_layout.dart';
import 'package:show_list/features/profile_page/repository/user_information_repository.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(userInformationRepositoryProvider).addListener(
            () => setState(() {}),
          );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? const AuthScreen()
        : const MainLayout();
  }
}
