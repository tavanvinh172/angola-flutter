// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/repository/common_firebase_storage_repository.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/auth/screens/login_screen.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_angola/screens/mobile_layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<UserModel?> getSpecificUserData(String uid) async {
    var userData = await firestore.collection('users').doc(uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(
        userData.data()!,
      );
    }
    return user;
  }

  Future<void> signUpWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required File? profilePic,
    required ProviderRef ref,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl =
            'https://images.unsplash.com/photo-1662852907138-210529b06b99?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60';
        if (profilePic != null) {
          photoUrl = await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                'profilePic/${credential.user!.uid}',
                profilePic,
              );
        }
        UserModel user = UserModel(
          uid: credential.user!.uid,
          email: email,
          profilePic: photoUrl,
          isOnline: false,
          phoneNumber: '',
          groupId: [],
          followers: [],
          following: [],
        );
        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toMap());
        Navigator.pushNamedAndRemoveUntil(
            context, MobileLayoutScreen.routeName, (route) => false);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      Navigator.pushNamedAndRemoveUntil(
          context, MobileLayoutScreen.routeName, (route) => false);
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }
}
