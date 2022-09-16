import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';

class PostCardPreview extends StatelessWidget {
  const PostCardPreview({
    Key? key,
    required this.profileImage,
    required this.username,
    required this.onPressed,
    required this.userChooseFile,
    required this.description,
  }) : super(key: key);
  final String? profileImage;
  final String? description;
  final String username;
  final VoidCallback onPressed;
  final File? userChooseFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: profileImage != null
              ? CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(profileImage!),
                )
              : null,
          title: Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          // subtitle: Text(description!),

          trailing: IconButton(
            icon: const Icon(
              Icons.more_vert_sharp,
              color: appBarColor,
              size: 29,
            ),
            onPressed: onPressed,
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Image(
              image: FileImage(userChooseFile!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: appBarColor,
                size: 29,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.comment,
                color: appBarColor,
                size: 29,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: appBarColor,
                size: 29,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.markunread_mailbox_outlined,
                color: appBarColor,
                size: 29,
              ),
            )
          ],
        )
      ],
    );
  }
}
