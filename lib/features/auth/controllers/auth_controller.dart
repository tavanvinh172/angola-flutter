// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(
    repository: repository,
    ref: ref,
  );
});

final userDataAuthProvider = FutureProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

final specifyUserDataAuthProvider =
    FutureProvider.family<UserModel?, String>((ref, uid) {
  final authController = ref.watch(authControllerProvider);
  return authController.getSpecificUserData(uid);
});

class AuthController {
  final AuthRepository repository;
  final ProviderRef ref;
  AuthController({
    required this.repository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await repository.getCurrentUserData();
    return user;
  }

  Future<UserModel?> getSpecificUserData(String uid) async {
    UserModel? user = await repository.getSpecificUserData(uid);
    return user;
  }

  Future<void> signUpWithEmailAndPassword(
      BuildContext context, String email, String password, File? profilePic) {
    return repository.signUpWithEmailAndPassword(
      context: context,
      email: email,
      password: password,
      profilePic: profilePic,
      ref: ref,
    );
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) {
    return repository.signInWithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  void signOut(BuildContext context) {
    repository.signOut(context);
  }
}
