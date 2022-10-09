import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/chat/controllers/chat_controller.dart';
import 'package:flutter_angola/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(chatContactProvider).when(data: (contacts) {
      return Container(
          color: const Color.fromARGB(255, 229, 240, 249),
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MobileChatScreen(
                                    uid: contact.contactId,
                                    email: contact.name
                                        .replaceAll("@gmail.com", ""),
                                    profilePic: contact.profilePic,
                                  ))),
                      leading: contact.profilePic != ''
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(contact.profilePic),
                              radius: 30,
                            )
                          : const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://plus.unsplash.com/premium_photo-1664267831831-e56a2dc35871?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=600&q=60',
                              ),
                              radius: 30,
                            ),
                      title: Text(
                        contact.name.replaceAll("@gmail.com", ""),
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        contact.lastMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: Text(
                        DateFormat.Hm().format(contact.timeSent),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const Divider()
                  ],
                );
              }));
    }, error: (err, stacktrace) {
      return ErrorScreen(
        error: err.toString(),
      );
    }, loading: () {
      return const Center(
        child: Loader(),
      );
    });
  }
}
