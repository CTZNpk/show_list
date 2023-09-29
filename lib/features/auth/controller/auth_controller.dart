import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:show_list/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  AuthController({
    required this.authRepository,
  });

  final AuthRepository authRepository;

  Future creatingUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await authRepository.creatingUserWithEmailAndPassword(
        email: email, password: password, context: context);
  }

  Future signingInUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await authRepository.signingInUserWithEmailAndPassword(
        email: email, password: password, context: context);
  }

  Future signInUserWithGoogle({required BuildContext context}) async {
    await authRepository.signingInUserWithGoogle(context: context);
  }


  Future signOut() async {
    await authRepository.signingOut();
  }
}
