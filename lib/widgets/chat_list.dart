import 'package:flutter/material.dart';
import 'package:flutter_angola/infor.dart';
import 'package:flutter_angola/widgets/my_message_card.dart';
import 'package:flutter_angola/widgets/sender_message_card.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] as bool) {
          return MyMessageCard(
              message: messages[index]['text'] as String,
              date: messages[index]['time'] as String);
        } else {
          return SenderMessageCard(
              message: messages[index]['text'] as String,
              date: messages[index]['time'] as String);
        }
      },
      itemCount: messages.length,
    );
  }
}
