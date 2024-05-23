import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_x/src/user/domain/entity/user.dart';

// ignore: must_be_immutable
class UserModel extends UserEntity {
  UserModel({
    super.username,
    super.email,
    super.photoUrl,
    super.blockedUsers,
    super.country,
    super.bio,
    super.id,
    super.signedUpAt,
    super.lastSeen,
    super.followers,
    super.followings,
    super.isOnline,
  });

  static UserModel empty() => UserModel(
      bio: "",
      country: "",
      email: "",
      id: "",
      isOnline: false,
      lastSeen: Timestamp.now(),
      blockedUsers: [],
      followers: [],
      followings: [],
      photoUrl: "",
      signedUpAt: Timestamp.now(),
      username: "");
  UserModel copyWith({
    String? username,
    String? email,
    String? photoUrl,
    String? country,
    String? bio,
    String? id,
    Timestamp? signedUpAt,
    Timestamp? lastSeen,
    List<String>? blockedUsers,
    List<String>? followers,
    List<String>? followings,
    bool? isOnline,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      country: country ?? this.country,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      id: id ?? this.id,
      signedUpAt: signedUpAt ?? this.signedUpAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'blockedUsers': blockedUsers,
      'country': country,
      'bio': bio,
      'id': id,
      'signedUpAt': signedUpAt,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
      'followers': followers,
      'followings': followings
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      signedUpAt: map['signedUpAt'] ?? Timestamp.now(),
      lastSeen: map['lastSeen'] ?? Timestamp.now(),
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      followers: map['followers'] != null
          ? List.from((map['followers'] as List))
          : null,
      blockedUsers: map['blockedUsers'] != null
          ? List.from((map['blockedUsers'] as List))
          : null,
      followings: map['followings'] != null
          ? List.from((map['followings'] as List))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
