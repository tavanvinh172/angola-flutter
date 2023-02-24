class UserModel {
  static const String userPersistenceKey = 'userKey';
  final String uid;
  final String email;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  final List<String> followers;
  final List<String> following;
  UserModel({
    required this.uid,
    required this.email,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      profilePic: map['profilePic'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupId: List<String>.from(map['groupId']),
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
    );
  }
}
