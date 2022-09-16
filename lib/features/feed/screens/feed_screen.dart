import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/feed/controllers/feed_controller.dart';
import 'package:flutter_angola/features/post/widgets/post_card.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Post>>(
        stream: ref.read(feedControllerProvider).getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Loader(),
            );
          }
          if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error.toString());
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final snap = snapshot.data![index];
                return PostCard(
                  snap: snap,
                );
              });
        });
  }
}
