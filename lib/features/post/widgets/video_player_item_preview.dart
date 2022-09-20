import 'dart:io';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItemPreview extends StatefulWidget {
  const VideoPlayerItemPreview({Key? key, required this.file})
      : super(key: key);
  final File file;
  @override
  State<VideoPlayerItemPreview> createState() => _VideoPlayerItemPreviewState();
}

class _VideoPlayerItemPreviewState extends State<VideoPlayerItemPreview> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.file(widget.file)
      ..initialize().then(
        (value) => videoPlayerController.setVolume(1),
      );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(
            videoPlayerController,
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: Icon(
                isPlay ? Icons.pause_circle : Icons.play_circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
