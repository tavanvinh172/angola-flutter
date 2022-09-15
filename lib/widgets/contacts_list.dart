import 'package:flutter/material.dart';
import 'package:flutter_angola/infor.dart';
import 'package:flutter_angola/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 229, 240, 249),
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MobileChatScreen())),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(info[index]['profilePic'] as String),
                    radius: 30,
                  ),
                  title: Text(
                    info[index]['name'] as String,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    info[index]['message'] as String,
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: Text(
                    info[index]['time'] as String,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Divider()
              ],
            );
          }),
    );
  }
}
