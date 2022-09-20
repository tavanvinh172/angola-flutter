// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/profile/controllers/profile_controller.dart';
import 'package:flutter_angola/features/profile/widgets/follow_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/common/widgets/custom_button.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/post/widgets/video_player_item.dart';
import 'package:flutter_angola/features/profile/widgets/build_stat_column.dart';
import 'package:flutter_angola/models/user.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    required this.uid,
    Key? key,
  }) : super(key: key);
  final String uid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String uid = '';
  String email = '';
  String profilePic = '';
  String phoneNumber = '';
  int postLens = 0;
  var userData = {};
  bool isFollowing = false;
  int following = 0;
  int followers = 0;

  UserModel getUserData() {
    ref.read(specifyUserDataAuthProvider(widget.uid)).whenData((value) {
      uid = value!.uid;
      email = value.email;
      profilePic = value.profilePic;
      phoneNumber = value.phoneNumber;
    });
    setState(() {});
    return UserModel(
      uid: uid,
      email: email,
      profilePic: profilePic,
      isOnline: true,
      phoneNumber: phoneNumber,
      groupId: [],
      followers: [],
      following: [],
    );
  }

  void getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLens = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void signOutUser(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider).signOut(context);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = getUserData();
    print('uid: ${widget.uid}');
    print('isFollowing $isFollowing');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          userModel.email.replaceAll('@gmail.com', ''),
        ),
        actions: [
          IconButton(
              onPressed: () => signOutUser(ref, context),
              icon: const Icon(Icons.login))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundImage: NetworkImage(userModel.profilePic),
                ),
                buildStatColumn(postLens, 'posts'),
                buildStatColumn(followers, 'followers'),
                buildStatColumn(following, 'following'),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                userModel.email.replaceAll('@gmail.com', ''),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            userModel.uid == FirebaseAuth.instance.currentUser!.uid
                ? Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                    child: customButton(
                      onPressed: () {},
                      text: const Text('Edit your profile'),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isFollowing
                          ? FollowButton(
                              text: 'Unfollow',
                              backgroundColor: appBarColor,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              function: () async {
                                ref
                                    .watch(profileControllerProvider)
                                    .processUserFollow(
                                      widget.uid,
                                      FirebaseAuth.instance.currentUser!.uid,
                                    );
                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            )
                          : FollowButton(
                              text: 'Follow',
                              backgroundColor: appBarColor,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              function: () async {
                                ref
                                    .watch(profileControllerProvider)
                                    .processUserFollow(
                                      widget.uid,
                                      FirebaseAuth.instance.currentUser!.uid,
                                    );
                                setState(() {
                                  isFollowing = true;
                                  followers++;
                                });
                              },
                            ),
                      FollowButton(
                        text: 'Contact',
                        backgroundColor: appBarColor,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        function: () {},
                      ),
                      FollowButton(
                        text: 'Call',
                        backgroundColor: appBarColor,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        function: () {},
                      ),
                    ],
                  ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: userModel.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Loader(),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorScreen(error: snapshot.error.toString());
                  }
                  return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        final posts = snapshot.data!.docs[index];
                        if (posts['type'] == 'image') {
                          return Image(
                            image: NetworkImage(posts['postUrl']),
                          );
                        } else {
                          return VideoPlayerItem(stringUrl: posts['postUrl']);
                        }
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
