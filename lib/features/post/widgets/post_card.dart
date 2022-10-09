import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/feed/controllers/feed_controller.dart';
import 'package:flutter_angola/features/post/widgets/comment_screen.dart';
import 'package:flutter_angola/features/post/widgets/video_player_item.dart';
import 'package:flutter_angola/features/profile/screens/profile_screen.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PostCard extends ConsumerStatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);
  final snap;
  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  String uid = '';
  String email = '';
  String profilePic = '';
  bool isOnline = false;
  String phoneNumber = '';
  List<String> groupId = [];
  List<String> followers = [];
  List<String> following = [];
  int commentLength = 0;
  int favoriteLength = 0;
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

  void likePost() {
    ref.read(feedControllerProvider).likeController(
          context,
          widget.snap.postId,
          widget.snap.likes,
        );
  }

  void fetCommentLength() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap.postId)
          .collection('comments')
          .get();
      commentLength = snapshot.docs.length;
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void fetchFavoriteLength() async {
    try {} catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  void initState() {
    fetCommentLength();
    getCurrentUser();
    fetchFavoriteLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uid: widget.snap.uid,
                              ))),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.snap.profImage,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.snap.postUrl != '')
            GestureDetector(
              onDoubleTap: () {},
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: widget.snap.type == StatusEnum.video
                        ? VideoPlayerItem(stringUrl: widget.snap.postUrl)
                        : Image.network(
                            widget.snap.postUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
          if (widget.snap.postUrl == '')
            Text(
              widget.snap.description,
              style: const TextStyle(fontSize: 30),
            ),

          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: likePost,
                  child: widget.snap.likes.contains(uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border)),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () => Navigator.pushNamed(
                    context, CommentScreen.routeName,
                    arguments: widget.snap.postId),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: () {}),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: const Icon(Icons.bookmark_border), onPressed: () {}),
              ))
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '$favoriteLength likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.snap.postUrl != '')
                          TextSpan(
                            text: ' ${widget.snap.description}',
                          ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLength comments',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {}),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.snap.datePublished),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            height: 6,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
