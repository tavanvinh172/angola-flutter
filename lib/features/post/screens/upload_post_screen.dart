import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/post/controllers/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadPostScreen extends ConsumerStatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends ConsumerState<UploadPostScreen> {
  final statusController = TextEditingController();
  File? image;
  bool isSelectImage = false;
  @override
  void dispose() {
    super.dispose();
    statusController.dispose();
  }

  void postFile(String profImage, String username) async {
    StatusEnum typeEnum = StatusEnum.text;
    if (isSelectImage) {
      typeEnum = StatusEnum.image;
    }
    ref.read(postConotrllerProvider).uploadImagePost(
          context,
          image,
          statusController.text,
          profImage,
          username,
          typeEnum,
        );
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
  }

  void uploadPost() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: ref.read(userDataAuthProvider).when(
            data: (user) {
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
                              user!.profilePic,
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
                                        String username = user.email
                                            .replaceAll('@gmail.com', '');

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
                              image = await pickImageFromGallery(context);
                              setState(() {
                                if (image != null) {
                                  isSelectImage = true;
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
                      if (image != null)
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: Image(
                            image: FileImage(image!),
                          ),
                        )
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
