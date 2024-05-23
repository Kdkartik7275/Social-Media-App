// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? username;
  String? email;
  String? photoUrl;
  String? country;
  String? bio;
  String? id;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  List<String>? followers;
  List<String>? blockedUsers;
  List<String>? followings;
  bool? isOnline;
  UserEntity({
    this.username,
    this.email,
    this.photoUrl,
    this.country,
    this.bio,
    this.id,
    this.signedUpAt,
    this.lastSeen,
    this.blockedUsers,
    this.isOnline,
    this.followers,
    this.followings,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        photoUrl,
        country,
        bio,
        id,
        signedUpAt,
        lastSeen,
        isOnline,
        followers,
        followings
      ];
}
