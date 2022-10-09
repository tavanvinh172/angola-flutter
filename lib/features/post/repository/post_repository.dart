// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/repository/common_firebase_storage_repository.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/models/notify.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class PostRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  PostRepository({
    required this.auth,
    required this.firestore,
  });

  void uploadImagePost(
      {required BuildContext context,
      required File? image,
      required String? description,
      required String? profImage,
      required String username,
      required ProviderRef ref,
      required StatusEnum statusEnum}) async {
    try {
      var timeUpload = DateTime.now();
      var postId = const Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'posts/${statusEnum.type}/${auth.currentUser!.uid}/$postId',
            image!,
          );
      Notify notify = Notify(
        uid: auth.currentUser!.uid,
        notifyId: postId,
        datePublished: timeUpload,
        message: "$username uploads a post",
      );
      Post post = Post(
        uid: auth.currentUser!.uid,
        description: description!,
        likes: [],
        username: username,
        postId: postId,
        type: statusEnum,
        datePublished: timeUpload,
        postUrl: imageUrl,
        profImage: profImage!,
      );
      await firestore
          .collection('notification')
          .doc(postId)
          .set(notify.toMap());
      await firestore.collection('posts').doc(postId).set(post.toMap());
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void uploadStatusPost({
    required BuildContext context,
    required String? description,
    required String? profImage,
    required String username,
    required ProviderRef ref,
  }) async {
    try {
      var timeUpload = DateTime.now();
      var postId = const Uuid().v1();
      Notify notify = Notify(
        uid: auth.currentUser!.uid,
        notifyId: postId,
        datePublished: timeUpload,
        message: "$username uploads a status",
      );
      Post post = Post(
        uid: auth.currentUser!.uid,
        description: description!,
        likes: [],
        username: username,
        postId: postId,
        type: StatusEnum.text,
        datePublished: timeUpload,
        postUrl: '',
        profImage: profImage!,
      );
      await firestore
          .collection('notification')
          .doc(postId)
          .set(notify.toMap());

      await firestore.collection('posts').doc(postId).set(post.toMap());
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
