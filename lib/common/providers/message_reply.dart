// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final StatusEnum messageEnum;
  MessageReply(
    this.message,
    this.isMe,
    this.messageEnum,
  );
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) {
  return;
});
