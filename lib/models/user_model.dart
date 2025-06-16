import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String username;
  final String profilePic;
  final String uid;
  const UserModel({
    required this.email,
    required this.username,
    required this.profilePic,
    required this.uid,
  });

  UserModel copyWith({
    String? email,
    String? username,
    String? profilePic,
    String? uid,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'profilePic': profilePic,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, username: $username, profilePic: $profilePic, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.username == username &&
      other.profilePic == profilePic &&
      other.uid == uid;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      username.hashCode ^
      profilePic.hashCode ^
      uid.hashCode;
  }
}
