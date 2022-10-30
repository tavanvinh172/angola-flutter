// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_angola/common/enums/status_enum.dart';

class Notify {
  final String uid;
  final String notifyId;
  final DateTime datePublished;
  final String profileImg;
  final StatusEnum statusEnum;
  final String message;
  Notify({
    required this.uid,
    required this.notifyId,
    required this.datePublished,
    required this.profileImg,
    required this.statusEnum,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'notifyId': notifyId,
      'profileImg': profileImg,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'statusEnum': statusEnum.type,
      'message': message,
    };
  }

  factory Notify.fromMap(Map<String, dynamic> map) {
    return Notify(
      uid: map['uid'] as String,
      notifyId: map['notifyId'] as String,
      profileImg: map['profileImg'] as String,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      statusEnum: (map['statusEnum'] as String).toEnum(),
      message: map['message'] as String,
    );
  }
}
