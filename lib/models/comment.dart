// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comment {
  final String commentId;
  final String text;
  final String uid;
  final String profilePic;
  final String name;
  final DateTime datePublished;
  Comment({
    required this.commentId,
    required this.text,
    required this.uid,
    required this.profilePic,
    required this.name,
    required this.datePublished,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'text': text,
      'uid': uid,
      'profilePic': profilePic,
      'name': name,
      'datePublished': datePublished.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      text: map['text'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      name: map['name'] as String,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
    );
  }
}
