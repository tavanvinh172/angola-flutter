// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/features/post/repository/post_repository.dart';

final postConotrllerProvider = Provider<PostController>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostController(postRepository: postRepository, ref: ref);
});

class PostController {
  final PostRepository postRepository;
  final ProviderRef ref;
  PostController({
    required this.postRepository,
    required this.ref,
  });

  void uploadImagePost(BuildContext context, File? image, String? description,
      String profImage, String username, StatusEnum statusEnum) {
    ref.read(postRepositoryProvider).uploadImagePost(
          context: context,
          image: image,
          description: description,
          profImage: profImage,
          username: username,
          ref: ref,
          statusEnum: statusEnum,
        );
  }
}
