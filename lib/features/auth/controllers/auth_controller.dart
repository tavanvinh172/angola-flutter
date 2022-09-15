// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(
    repository: repository,
    ref: ref,
  );
});

class AuthController {
  final AuthRepository repository;
  final ProviderRef ref;
  AuthController({
    required this.repository,
    required this.ref,
  });

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
}
