import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/feed/controllers/feed_controller.dart';
import 'package:flutter_angola/features/post/widgets/comment_card.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentScreen extends ConsumerStatefulWidget {
  const CommentScreen({
    Key? key,
    required this.postID,
  }) : super(key: key);
  final postID;

  static const String routeName = '/comment-screen';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  String uid = '';
  String email = '';
  String profilePic = '';
  bool isOnline = false;
  String phoneNumber = '';
  List<String> groupId = [];
  List<String> followers = [];
  List<String> following = [];
  UserModel getCurrentUser() {
    ref.read(userDataAuthProvider).whenData((value) {
      uid = value!.uid;
      email = value.email;
      profilePic = value.profilePic;
      isOnline = value.isOnline;
      phoneNumber = value.phoneNumber;
      groupId = value.groupId;
      followers = value.followers;
      following = value.following;
    });
    UserModel user = UserModel(
      uid: uid,
      email: email,
      profilePic: profilePic,
      isOnline: isOnline,
      phoneNumber: phoneNumber,
      groupId: groupId,
      followers: followers,
      following: following,
    );
    return user;
  }

  final TextEditingController messageComment = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageComment.dispose();
  }

  void postComment(String uid, String name, String profilePic) {
    ref.read(feedControllerProvider).processComment(
          messageComment.text,
          widget.postID,
          profilePic,
          context,
          uid,
          name,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      body: ref.watch(getCommentStreamProvider(widget.postID)).when(
            data: (commentData) {
              return ListView.separated(
                  itemCount: commentData.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    final data = commentData[index];
                    return CommentCard(commentData: data);
                  });
            },
            error: (err, stackTrace) {
              return Center(
                child: ErrorScreen(
                  error: err.toString(),
                ),
              );
            },
            loading: () => const Center(
              child: Loader(),
            ),
          ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profilePic),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: messageComment,
                    decoration: InputDecoration(
                      hintText:
                          'Comment as ${email.replaceAll('@gmail.com', '')}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  uid,
                  email.replaceAll('@gmail.com', ''),
                  profilePic,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
