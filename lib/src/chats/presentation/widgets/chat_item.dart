// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/chats/presentation/pages/conversation.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';

class ChatItem extends StatefulWidget {
  final ChatRoom chatRoom;
  const ChatItem({
    Key? key,
    required this.chatRoom,
  }) : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    final me =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    return StreamBuilder<UserEntity>(
        stream: context.read<ProfileBloc>().getUser(
            userId: widget.chatRoom.roomId!.replaceAll(me.user.id!, "")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListTile(
              onTap: () => TNavigators.navigatePush(
                  context,
                  Conversation(
                      chatRoomId: widget.chatRoom.roomId!,
                      userId: user.id!,
                      myUserId: me.user.id!)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Stack(
                children: <Widget>[
                  user.photoUrl == null || user.photoUrl!.isEmpty
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: Center(
                            child: Text(
                              user.username![0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundImage: CachedNetworkImageProvider(
                            '${user.photoUrl}',
                          ),
                        ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      height: 15,
                      width: 15,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: user.isOnline ?? false
                                ? const Color(0xff00d72f)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 11,
                          width: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                '${user.username}',
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.chatRoom.lastmessage! == 'image'
                    ? "Sent an image"
                    : widget.chatRoom.lastmessage!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 12,
                    color: widget.chatRoom.islastmsgread!
                        ? Colors.grey
                        : Colors.black,
                    fontWeight: widget.chatRoom.islastmsgread!
                        ? FontWeight.w400
                        : FontWeight.bold),
              ),
              trailing: widget.chatRoom.lastmessage != ""
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeago.format(widget.chatRoom.timeSent!.toDate()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        widget.chatRoom.islastmsgread!
                            ? const SizedBox()
                            : Container(
                                height: 5,
                                width: 5,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                              )
                      ],
                    )
                  : null,
            );
          }
          return circularProgress(context);
        });
  }
}
