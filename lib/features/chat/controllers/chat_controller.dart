// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/providers/message_reply.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/models/chat_contact.dart';
import 'package:flutter_angola/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_angola/features/chat/repository/chat_repository.dart';

final chatControllerProvider = Provider<ChatController>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    repository: chatRepository,
    ref: ref,
  );
});

final chatContactProvider = StreamProvider<List<ChatContact>>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getChatContact();
});

final messageContactProvider =
    StreamProvider.family<List<Message>, String>((ref, receiverId) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return chatRepository.getMessageStream(receiverId);
});

class ChatController {
  final ChatRepository repository;
  final ProviderRef ref;
  ChatController({
    required this.repository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) {
      repository.sendTextMessage(
        context: context,
        text: text,
        receiverUserId: receiverUserId,
        senderUser: value!,
        messageReply: messageReply,
      );
    });
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    StatusEnum messageEnum,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData((value) {
      repository.sendFileMessage(
        context: context,
        file: file,
        receiverUserId: receiverUserId,
        senderUser: value!,
        messageEnum: messageEnum,
        ref: ref,
        messageReply: messageReply,
      );
    });
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  Stream<List<ChatContact>> getChatContact() {
    return repository.getChatContact();
  }
}
