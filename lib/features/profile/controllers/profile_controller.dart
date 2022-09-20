// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/features/profile/repository/profile_repository.dart';

final profileControllerProvider = Provider<ProfileController>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileController(repository, ref);
});

class ProfileController {
  final ProfileRepository repository;
  final ProviderRef ref;

  ProfileController(
    this.repository,
    this.ref,
  );

  Future<void> processUserFollow(
    String followId,
    String uid,
  ) async {
    repository.processUserFollow(followId, uid);
  }
}
