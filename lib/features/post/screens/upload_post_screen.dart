import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/post/controllers/post_controller.dart';
import 'package:flutter_angola/features/post/widgets/post_card_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadPostScreen extends ConsumerStatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends ConsumerState<UploadPostScreen> {
  final statusController = TextEditingController();
  File? file;
  bool isSelectImage = false;
  bool isSelectVideo = false;
  @override
  void dispose() {
    super.dispose();
    statusController.dispose();
  }

  void postFile(String profImage, String username) async {
    StatusEnum typeEnum = StatusEnum.text;
    if (isSelectImage) {
      typeEnum = StatusEnum.image;
    } else if (isSelectVideo) {
      typeEnum = StatusEnum.video;
    }
    if (file == null) {
      ref.read(postControllerProvider).uploadStatusPost(
            context,
            statusController.text,
            profImage,
            username,
          );
    } else {
      ref.read(postControllerProvider).uploadImagePost(
            context,
            file,
            statusController.text,
            profImage,
            username,
            typeEnum,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ref.read(userDataAuthProvider).when(
            data: (user) {
              String username = user!.email.replaceAll('@gmail.com', '');
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.profilePic,
                            ),
                            radius: 32,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: TextField(
                              controller: statusController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        postFile(
                                          user.profilePic,
                                          username,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.upload,
                                        color: Colors.blue,
                                      )),
                                  hintText: 'What\'s your feeling today?'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              file = await pickImageFromGallery(context);
                              setState(() {
                                if (file != null) {
                                  isSelectImage = true;
                                  isSelectVideo = false;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18.0))),
                                width: size.width * 0.28,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.photo,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Photo')
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () async {
                              file = await pickVideoFromGallery(context);
                              setState(() {
                                if (file != null) {
                                  isSelectVideo = true;
                                  isSelectImage = false;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(18.0))),
                              width: size.width * 0.28,
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.video_call,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('Video')
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18.0))),
                                width: size.width * 0.28,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.photo_album,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Album')
                                  ],
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      const Text(
                        'Your post preview',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      if (file != null)
                        Expanded(
                          child: isSelectImage
                              ? PostCardPreview(
                                  profileImage: user.profilePic,
                                  username: username,
                                  isVideo: false,
                                  onPressed: () {},
                                  userChooseFile: file,
                                  description: statusController.text,
                                )
                              : PostCardPreview(
                                  profileImage: user.profilePic,
                                  username: username,
                                  isVideo: true,
                                  onPressed: () {},
                                  userChooseFile: file,
                                  description: statusController.text,
                                ),
                        ),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorScreen(error: error.toString());
            },
            loading: () => const Loader()));
  }
}
