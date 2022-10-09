import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/features/post/widgets/video_player_item.dart';

class DisplayOtherType extends StatelessWidget {
  const DisplayOtherType(
      {super.key, required this.type, required this.message});
  final StatusEnum type;
  final String message;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return type == StatusEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == StatusEnum.image
            ? CachedNetworkImage(
                imageUrl: message,
                width: size.width * 1 / 2,
              )
            : VideoPlayerItem(stringUrl: message);
  }
}
