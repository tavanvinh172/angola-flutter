import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/feed/repository/feed_repository.dart';
import 'package:flutter_angola/models/comment.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedControllerProvider = Provider<FeedController>((ref) {
  final feedRepository = ref.watch(feedRepositoryProvider);
  return FeedController(feedRepository: feedRepository, ref: ref);
});

final getCommentStreamProvider =
    StreamProvider.family<List<Comment>, String>((ref, postId) {
  final feedRepository = ref.watch(feedRepositoryProvider);
  return feedRepository.getCommentStream(postId);
});

class FeedController {
  final FeedRepository feedRepository;
  final ProviderRef ref;
  FeedController({
    required this.feedRepository,
    required this.ref,
  });

  Stream<List<Post>> getPostStream() {
    return feedRepository.getPostStream();
  }

  Stream<List<Comment>> getCommentStream(String postId) {
    return feedRepository.getCommentStream(postId);
  }

  void likeController(
    BuildContext context,
    String postId,
    List likes,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      feedRepository.processLike(
        context,
        value!.uid,
        postId,
        likes,
      );
    });
  }

  void processComment(
    String messageComment,
    String postID,
    String profilePic,
    BuildContext context,
    String uid,
    String name,
  ) {
    feedRepository.processComment(
      messageComment,
      postID,
      profilePic,
      context,
      uid,
      name,
    );
  }
}
