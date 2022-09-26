import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/features/feed/repository/feed_repository.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedControllerProvider = Provider<FeedController>((ref) {
  final feedRepository = ref.watch(feedRepositoryProvider);
  return FeedController(feedRepository: feedRepository);
});

class FeedController {
  final FeedRepository feedRepository;
  FeedController({
    required this.feedRepository,
  });

  Stream<List<Post>> getPostStream() {
    return feedRepository.getPostStream();
  }

  void processLike(
    BuildContext context,
    String uid,
    String postId,
    List likes,
  ) {
    feedRepository.processLike(
      context,
      uid,
      postId,
      likes,
    );
  }
}
