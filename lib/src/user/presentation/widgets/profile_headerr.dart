// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/chats/domain/usecases/create_chat_room.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/chats/presentation/pages/conversation.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/domain/usecases/follow_user.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/src/user/presentation/pages/edit_profile.dart';
import 'package:social_x/src/user/presentation/pages/follows.dart';
import 'package:social_x/src/user/presentation/pages/settings.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    Key? key,
    required this.user,
    required this.myId,
    this.onBlock,
    required this.isBlocked,
  }) : super(key: key);

  final UserEntity user;
  final String myId;
  final Function()? onBlock;
  final bool isBlocked;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool isFollowing = false;

  isFollowedByMe() {
    if (widget.user.followers!.contains(widget.myId)) {
      setState(() {
        isFollowing = true;
      });
    } else {
      setState(() {
        isFollowing = false;
      });
    }
  }

  toggleFollow({required String myId, required String userId}) {
    setState(() {
      isFollowing = !isFollowing;
      context.read<ProfileBloc>().add(
          OnFollowUser(params: FollowUserParams(userId: userId, myId: myId)));
    });
  }

  @override
  void initState() {
    super.initState();
    isFollowedByMe();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.user.photoUrl!.isEmpty
                  ? CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Text(
                          widget.user.username![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  backgroundImage: CachedNetworkImageProvider(
                                    '${widget.user.photoUrl}',
                                  ),
                                ),
                              ),
                            );
                          }),
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: CachedNetworkImageProvider(
                          '${widget.user.photoUrl}',
                        ),
                      ),
                    ),
              const SizedBox(width: 25),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.username!,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: null,
                    ),
                    Text(
                      widget.user.country!,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.user.email!,
                      style: const TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              widget.myId == widget.user.id
                  ? InkWell(
                      onTap: () => TNavigators.navigatePush(context, Setting()),
                      child: Column(
                        children: [
                          Icon(
                            Ionicons.settings_outline,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const Text(
                            'settings',
                            style: TextStyle(
                              fontSize: 11.5,
                            ),
                          )
                        ],
                      ),
                    )
                  : PopupMenuButton(
                      color: Colors.white,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          onTap: widget.onBlock,
                          value: 'Block User',
                          child: const Text('Block User'),
                        ),
                        // Add more PopupMenuItems for other options if needed
                      ],
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
            ],
          ),
          widget.user.bio!.isEmpty
              ? const SizedBox()
              : SizedBox(
                  width: 200,
                  child: Text(
                    widget.user.bio!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: null,
                  ),
                ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCount("POSTS", 0, () {}),
              buildCount(
                  "FOLLOWERS",
                  widget.user.followers!.length,
                  () => TNavigators.navigatePush(
                      context,
                      Follows(
                        isFollwers: true,
                        users: widget.user.followers!,
                      ))),
              buildCount(
                  "FOLLOWINGS",
                  widget.user.followings!.length,
                  () => TNavigators.navigatePush(
                      context,
                      Follows(
                          isFollwers: false, users: widget.user.followings!))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildProfileButton(
                  myId: widget.myId,
                  userId: widget.user.id!,
                  user: widget.user),
              const SizedBox(width: 12),
              widget.user.id == widget.myId
                  ? const SizedBox()
                  : BlocListener<ChatsBloc, ChatsState>(
                      listener: (context, state) {
                        if (state is ChatRoomCreated) {
                          TNavigators.navigatePush(
                              context,
                              Conversation(
                                chatRoomId: state.roomId,
                                userId: widget.user.id!,
                                myUserId: widget.myId,
                              ));
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          context.read<ChatsBloc>().add(OnCreatChatRoom(
                              params: CreateChatRoomParams(
                                  myUserId: widget.myId,
                                  userId: widget.user.id!)));
                        },
                        child: Container(
                          height: 40.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff597FDB)),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xff597FDB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  buildProfileButton(
      {required String myId, required String userId, UserEntity? user}) {
    //if isMe then display "edit profile"
    bool isMe = userId == myId;
    if (widget.isBlocked) {
      return buildButton(text: "UnBlock", function: widget.onBlock);
    }
    if (isMe) {
      return buildButton(
          text: "Edit Profile",
          function: () => TNavigators.navigatePush(
              context,
              EditProfile(
                user: user!,
              )));
      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: () {
          toggleFollow(myId: myId, userId: userId);
        },
      );
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildButton(
        text: user!.followings!.contains(myId) ? "Follow Back" : "Follow",
        function: () {
          toggleFollow(myId: myId, userId: userId);
        },
      );
    }
  }

  buildButton({String? text, Function()? function}) {
    return Center(
      child: GestureDetector(
        onTap: function!,
        child: Container(
          height: 40.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color(0xff597FDB),
          ),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  buildCount(String label, int count, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w900,
              fontFamily: 'Ubuntu-Regular',
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: 'Ubuntu-Regular',
            ),
          )
        ],
      ),
    );
  }
}
