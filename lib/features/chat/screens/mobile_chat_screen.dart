import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/chat/widgets/bottom_chat_field.dart';
import 'package:flutter_angola/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({
    Key? key,
    required this.uid,
    required this.email,
    required this.profilePic,
  }) : super(key: key);
  final String uid;
  final String email;
  final String profilePic;
  static const String routeName = '/mobile-chat-screen';

  void choosingTheme(BuildContext context) async {
    pickImageFromGallery(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email.replaceAll('@gmail.com', '')),
        backgroundColor: appBarColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(uid: uid),
          ),
          // TextField(),
          BottomChatField(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}
