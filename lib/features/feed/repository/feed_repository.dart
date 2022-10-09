// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/models/comment.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class FeedRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  FeedRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<List<Post>> getPostStream() {
    return firestore
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .asyncMap(
      (event) async {
        List<Post> post = [];
        for (var document in event.docs) {
          post.add(Post.fromMap(document.data()));
        }
        return post;
      },
    );
  }

  Stream<List<Comment>> getCommentStream(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<Comment> comments = [];
      for (var document in event.docs) {
        comments.add(Comment.fromMap(document.data()));
      }
      return comments;
    });
  }

  void processLike(
      BuildContext context, String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void processComment(
    String messageComment,
    String postID,
    String profilePic,
    BuildContext context,
    String uid,
    String name,
  ) async {
    try {
      final commentId = const Uuid().v1();
      Comment comment = Comment(
        commentId: commentId,
        text: messageComment,
        uid: uid,
        name: name,
        datePublished: DateTime.now(),
        profilePic: profilePic,
      );
      await firestore
          .collection('posts')
          .doc(postID)
          .collection('comments')
          .doc(commentId)
          .set(
            comment.toMap(),
          );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
