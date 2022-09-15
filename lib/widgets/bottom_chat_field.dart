import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({Key? key}) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final chatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: chatController,
            autofocus: false,
            cursorColor: Colors.grey[800],
            decoration: InputDecoration(
              filled: true,
              fillColor: appBarColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  Icons.emoji_emotions,
                  color: Colors.grey[800],
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Colors.grey[800],
                  ),
                  Icon(
                    Icons.access_alarm_sharp,
                    color: Colors.grey[800],
                  ),
                ],
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey[900],
          radius: 25,
          child: const Icon(Icons.send),
        )
      ],
    );
  }
}
