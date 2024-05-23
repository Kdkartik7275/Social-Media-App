// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';
import 'package:social_x/src/chats/domain/usecases/message_read.dart';
import 'package:social_x/src/chats/domain/usecases/set_user_typing.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/chats/presentation/widgets/chat_bubble.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/src/user/presentation/pages/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String userId;
  final String myUserId;
  const Conversation({
    Key? key,
    required this.chatRoomId,
    required this.userId,
    required this.myUserId,
  }) : super(key: key);

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  bool isFirstChat = false;
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List<MessageEntity> messages = [];

  File? mediaUrl;
  bool sendingImage = false;

  pickImage({bool camera = false}) async {
    final image = await THelperFunctions.pickImage(camera: camera);
    if (image != null) {
      sendImage(image);
    }
  }

  sendImage(File image) {
    setState(() {
      sendingImage = true;
    });

    context.read<ChatsBloc>().add(OnSendFileMessage(
        myUserId: widget.myUserId, roomId: widget.chatRoomId, file: image));
    setState(() {
      sendingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.chatRoomId == 'newChat') {
      isFirstChat = true;
    }
    scrollController.addListener(() {
      focusNode.unfocus();
    });

    messageController.addListener(() {
      if (focusNode.hasFocus && messageController.text.isNotEmpty) {
        context.read<ChatsBloc>().add(OnToggleUserTyping(
            params: SetUserTypingParams(
                myUserId: widget.myUserId,
                chatId: widget.chatRoomId,
                istyping: true)));
        //  setTyping(true);
      } else if (!focusNode.hasFocus ||
          (focusNode.hasFocus && messageController.text.isEmpty)) {
        context.read<ChatsBloc>().add(OnToggleUserTyping(
            params: SetUserTypingParams(
                myUserId: widget.myUserId,
                chatId: widget.chatRoomId,
                istyping: false)));
      }
    });
  }

  _buildOnlineText(
    UserEntity user,
    bool typing,
  ) {
    if (user.isOnline!) {
      if (typing) {
        return "typing...";
      } else {
        return "online";
      }
    } else {
      return 'last seen ${timeago.format(user.lastSeen!.toDate())}';
    }
  }

  Map<DateTime, List<MessageEntity>> groupMessagesByDate(
      List<MessageEntity> messages) {
    Map<DateTime, List<MessageEntity>> groupedMessages = {};
    for (var message in messages) {
      DateTime date = message.timeSent!.toDate();
      DateTime formattedDate = DateTime(date.year, date.month, date.day);
      if (!groupedMessages.containsKey(formattedDate)) {
        groupedMessages[formattedDate] = [];
      }
      groupedMessages[formattedDate]!.add(message);
    }
    return groupedMessages;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatRoom>(
        stream:
            context.read<ChatsBloc>().getChatRoom(roomId: widget.chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chatUser = snapshot.data!.usersTyping!
                .firstWhere((e) => e.userId == widget.userId);
            bool isTyping = chatUser.isTyping!;
            return Scaffold(
              appBar: TAppBar(
                showBackArrow: true,
                leadingIconColor: Colors.black,
                title: StreamBuilder<UserEntity>(
                    stream: context
                        .read<ProfileBloc>()
                        .getUser(userId: widget.userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //  crossAxisAlignment: Cr,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.username!),
                                Text(
                                  _buildOnlineText(user, isTyping),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: user.isOnline!
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            user.photoUrl!.isEmpty
                                ? GestureDetector(
                                    onTap: () => TNavigators.navigatePush(
                                        context,
                                        ProfileScreen(
                                          uid: user.id!,
                                          showBackButton: true,
                                        )),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => TNavigators.navigatePush(
                                        context,
                                        ProfileScreen(
                                          uid: user.id!,
                                          showBackButton: true,
                                        )),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        '${user.photoUrl}',
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: StreamBuilder(
                          stream: context
                              .read<ChatsBloc>()
                              .listenMessages(chatId: widget.chatRoomId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                messages.isEmpty) {
                              return circularProgress(context);
                            }
                            if (snapshot.hasData) {
                              List<MessageEntity> allMessages = snapshot.data!;
                              allMessages.sort(
                                  (a, b) => a.timeSent!.compareTo(b.timeSent!));
                              Map<DateTime, List<MessageEntity>>
                                  groupedMessages =
                                  groupMessagesByDate(allMessages);
                              context.read<ChatsBloc>().add(OnMessageRead(
                                  params: MessageReadParams(
                                      chatId: widget.chatRoomId,
                                      userId: widget.userId)));
                              messages = snapshot.data!;
                              return ListView.builder(
                                  reverse: true,
                                  controller: scrollController,
                                  itemCount: groupedMessages.length,
                                  itemBuilder: (context, index) {
                                    List<DateTime> reversedDates =
                                        groupedMessages.keys
                                            .toList()
                                            .reversed
                                            .toList();
                                    DateTime date = reversedDates[index];
                                    List<MessageEntity> messages =
                                        groupedMessages[date]!;

                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Center(
                                              child: Text(_formatDate(date))),
                                        ),
                                        ...messages
                                            .map((message) => ChatBubbleWidget(
                                                  message: message,
                                                  isMe: message.senderId ==
                                                      widget.myUserId,
                                                )),
                                      ],
                                    );
                                  });
                            }
                            return const Center(
                              child: Text("Start Conersations...."),
                            );
                          })),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 70,
                    width: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.photo_on_rectangle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () => showPhotoOptions(),
                        ),
                        Flexible(
                          child: TextField(
                            onChanged: (value) {},
                            controller: messageController,
                            focusNode: focusNode,
                            style: TextStyle(
                              fontSize: 15.0,
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: "Type your message",
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Ionicons.send,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              context.read<ChatsBloc>().add(OnSendTextMessage(
                                  myUserId: widget.myUserId,
                                  roomId: widget.chatRoomId,
                                  message: messageController.text));
                              messageController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: circularProgress(context)),
            );
          }
        });
  }

  showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text("Camera"),
              onTap: () {
                pickImage(camera: true);
                TNavigators.navigatePop(context);
                //  sendMessage(viewModel, user, imageType: 0, isImage: true);
              },
            ),
            ListTile(
              title: const Text("Gallery"),
              onTap: () {
                pickImage(camera: false);
                TNavigators.navigatePop(context);
                //  sendMessage(viewModel, user, imageType: 1, isImage: true);
              },
            ),
          ],
        );
      },
    );
  }
}
