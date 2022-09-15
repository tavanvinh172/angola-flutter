// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_angola/common/enums/status_enum.dart';

class Post {
  final String uid;
  final String description;
  final List<String> likes;
  final String username;
  final String postId;
  final StatusEnum type;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  Post({
    required this.uid,
    required this.description,
    required this.likes,
    required this.username,
    required this.postId,
    required this.type,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'description': description,
      'likes': likes,
      'username': username,
      'postId': postId,
      'type': type.type,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'postUrl': postUrl,
      'profImage': profImage,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      uid: map['uid'] as String,
      description: map['description'] as String,
      likes: List<String>.from(map['likes']),
      username: map['username'] as String,
      postId: map['postId'] as String,
      type: (map['type'] as String).toEnum(),
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      postUrl: map['postUrl'] as String,
      profImage: map['profImage'] as String,
    );
  }
}
