import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/chat/controllers/chat_controller.dart';
import 'package:flutter_angola/features/chat/widgets/my_message_card.dart';
import 'package:flutter_angola/features/chat/widgets/sender_message_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerWidget {
  const ChatList({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(messageContactProvider(uid)).when(data: (messages) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1548777123-c2ae4fe3e3b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHRoZW1lfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final message = messages[index];
            if (message.senderId != uid) {
              return MyMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                type: message.type,
              );
            } else {
              return SenderMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                type: message.type,
              );
            }
          },
          itemCount: messages.length,
        ),
      );
    }, error: (error, stackTrace) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      return const Center(child: Loader());
    });
  }
}
