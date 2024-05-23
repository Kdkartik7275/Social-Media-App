// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/chats/presentation/widgets/chat_item.dart';

class Chats extends StatefulWidget {
  final String myId;
  const Chats({
    Key? key,
    required this.myId,
  }) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
        title: Text("Chats"),
      ),
      body: StreamBuilder<List<ChatRoom>>(
          stream: context
              .read<ChatsBloc>()
              .listenToChatRooms(myUserId: widget.myId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chats = snapshot.data!;
              return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: const Divider(),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    if (chats.isEmpty) {
                      return const Center(child: Text('No Chats'));
                    }
                    return ChatItem(chatRoom: chats[index]);
                  });
            }
            return circularProgress(context);
          }),
    );
  }
}
