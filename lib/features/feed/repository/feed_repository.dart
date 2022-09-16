// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}