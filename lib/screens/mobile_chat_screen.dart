import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/infor.dart';
import 'package:flutter_angola/widgets/bottom_chat_field.dart';
import 'package:flutter_angola/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({Key? key}) : super(key: key);
  static const String routeName = '/mobile-chat-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info[0]['name'] as String),
        backgroundColor: appBarColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call))
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: ChatList(),
          ),
          // TextField(),
          BottomChatField(),
        ],
      ),
    );
  }
}
