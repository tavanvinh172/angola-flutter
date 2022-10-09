// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_angola/common/enums/status_enum.dart';
import 'package:flutter_angola/common/providers/message_reply.dart';
import 'package:flutter_angola/common/repository/common_firebase_storage_repository.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/models/chat_contact.dart';
import 'package:flutter_angola/models/message.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel? receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.email,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: receiverUserData!.email,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String? receiverUsername,
    required StatusEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUsername ?? '',
      repliedMessageType:
          messageReply == null ? StatusEnum.text : messageReply.messageEnum,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.email,
        receiverUsername: receiverUserData.email,
        messageType: StatusEnum.text,
        messageReply: messageReply,
        senderUsername: senderUser.email,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .map((event) {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        contacts.add(chatContact);
      }
      return contacts;
    });
  }

  Stream<List<Message>> getMessageStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUser,
    required StatusEnum messageEnum,
    required ProviderRef ref,
    required MessageReply? messageReply,
  }) async {
    try {
      UserModel? receiverUserData;
      var userMap =
          await firestore.collection('users').doc(receiverUserId).get();
      DateTime timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chats/${messageEnum.type}/${senderUser.uid}/$receiverUserId/$messageId',
              file);
      receiverUserData = UserModel.fromMap(userMap.data()!);
      String contactMsg = '';
      switch (messageEnum) {
        case StatusEnum.image:
          contactMsg = "Image 📷";
          break;
        case StatusEnum.audio:
          contactMsg = "Audio 🔉";
          break;
        case StatusEnum.video:
          contactMsg = "Video 📺";
          break;
        case StatusEnum.gif:
          contactMsg = "GIF 🧧";
          break;
        default:
          contactMsg = "Image 📷";
      }
      _saveDataToContactSubCollection(
        senderUser,
        receiverUserData,
        contactMsg,
        timeSent,
        receiverUserId,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.email,
        receiverUsername: receiverUserData.email,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUsername: senderUser.email,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
