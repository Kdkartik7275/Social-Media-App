// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';

class ChatBubbleWidget extends StatefulWidget {
  final MessageEntity message;
  final bool isMe;
  const ChatBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  Color? chatBubbleColor() {
    if (widget.isMe) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      if (Theme.of(context).brightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.grey[200];
      }
    }
  }

  Color? chatBubbleReplyColor() {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.grey[600];
    } else {
      return Colors.grey[50];
    }
  }

  @override
  Widget build(BuildContext context) {
    final align = widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius = widget.isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          );
    return Row(
      mainAxisAlignment: align,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.message.type == MessagesType.text
            ? !widget.isMe
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 10.0,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: widget.message.isSeen!
                          ? Colors.blue
                          : Colors.grey.shade500,
                      size: 15,
                    ),
                  )
                : const SizedBox()
            : const SizedBox(),
        widget.message.type == MessagesType.text
            ? GestureDetector(
                onLongPress: () => messageOption(context),
                child: ChatBubble(
                  elevation: 0.0,
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.all(5.0),
                  alignment: widget.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  clipper: ChatBubbleClipper3(
                    nipSize: 0,
                    type: widget.isMe
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble,
                  ),
                  backGroundColor: chatBubbleColor(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(
                              widget.message.type == MessagesType.text
                                  ? 10
                                  : 0),
                          child: Text(
                            widget.message.message!,
                            style: TextStyle(
                              color: widget.isMe
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color,
                            ),
                          )),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: radius,
                  child: CachedNetworkImage(
                    imageUrl: widget.message.message!,
                    // height: 200,
                    width: MediaQuery.of(context).size.width / 1.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        widget.isMe
            ? Padding(
                padding: widget.isMe
                    ? const EdgeInsets.only(
                        right: 10.0,
                        bottom: 10.0,
                      )
                    : const EdgeInsets.only(
                        left: 10.0,
                        bottom: 10.0,
                      ),
                child: Icon(
                  Icons.done_all,
                  color: widget.message.isSeen!
                      ? Colors.blue
                      : Colors.grey.shade500,
                  size: 15,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Future<dynamic> messageOption(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: const Center(child: Text("Delete Message")),
          ),
        );
      },
    );
  }
}
