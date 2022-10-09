import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/chat/controllers/chat_controller.dart';
// import 'package:flutter_angola/features/chat/controllers/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({Key? key, required this.receiverUserId})
      : super(key: key);
  final String receiverUserId;
  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final chatController = TextEditingController();

  File? file;
  bool isChooseImage = false;
  bool isChooseVideo = false;
  void sendText() {
    // ref.read(chatControllerProvider).sendTextMessage(
    //     context, chatController.text.trim(), widget.receiverUserId);
    // setState(() {
    //   chatController.text = "";
    // });
    ref.read(chatControllerProvider).sendTextMessage(
          context,
          chatController.text,
          widget.receiverUserId,
        );
    setState(() {
      chatController.text = "";
    });
  }

  void sendFileMessage() {
    if (file != null) {
      if (isChooseImage) {
        ref.read(chatControllerProvider).sendFileMessage(
              context,
              file!,
              widget.receiverUserId,
              StatusEnum.image,
            );
      } else if (isChooseVideo) {
        ref.read(chatControllerProvider).sendFileMessage(
              context,
              file!,
              widget.receiverUserId,
              StatusEnum.video,
            );
      }
    }
    setState(() {
      chatController.text = "";
    });
  }

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
                  GestureDetector(
                    onTap: () async {
                      file = await pickImageFromGallery(context);
                      if (file != null) {
                        setState(() {
                          isChooseImage = true;
                          isChooseVideo = false;
                        });
                        sendFileMessage();
                      }
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      file = await pickVideoFromGallery(context);
                      if (file != null) {
                        setState(() {
                          isChooseImage = false;
                          isChooseVideo = true;
                        });
                        sendFileMessage();
                      }
                    },
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.grey[800],
                    ),
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
        InkWell(
          onTap: sendText,
          child: CircleAvatar(
            backgroundColor: Colors.grey[900],
            radius: 25,
            child: const Icon(Icons.send),
          ),
        )
      ],
    );
  }
}
