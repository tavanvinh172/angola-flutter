// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notify {
  final String uid;
  final String notifyId;
  final DateTime datePublished;
  final String message;
  Notify({
    required this.uid,
    required this.notifyId,
    required this.datePublished,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'notifyId': notifyId,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'message': message,
    };
  }

  factory Notify.fromMap(Map<String, dynamic> map) {
    return Notify(
      uid: map['uid'] as String,
      notifyId: map['notifyId'] as String,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      message: map['message'] as String,
    );
  }
}
