import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/constants/colors.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/chats/presentation/pages/chats.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/posts/presentation/widgets/user_post.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';

class Feeds extends StatefulWidget {
  const Feeds({super.key});

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    context.read<PostsBloc>().add(OnFetchPosts(limit: page));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PostsBloc>().add(OnFetchPosts(limit: page));
  }

  @override
  Widget build(BuildContext context) {
    final me =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    return Scaffold(
      appBar: TAppBar(
        title: const Text("WaveConnect"),
        centreTitle: false,
        actions: [
          StreamBuilder<List<ChatRoom>>(
              stream: context
                  .read<ChatsBloc>()
                  .listenToChatRooms(myUserId: me.user.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int unreadCount = snapshot.data!
                      .where((element) =>
                          element.islastmsgread == false &&
                          element.lastmessage != "")
                      .length;
                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Ionicons.chatbubble_ellipses_outline,
                          size: 30.0,
                          color: TColors.lightAccent,
                        ),
                        onPressed: () {
                          TNavigators.navigatePush(
                            context,
                            Chats(myId: me.user.id!),
                          );
                        },
                      ),
                      unreadCount == 0
                          ? const SizedBox()
                          : Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                    child: Text(
                                  unreadCount > 4
                                      ? "4+"
                                      : unreadCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 8),
                                )),
                              ))
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // StoryWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
                  BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
                if (state is PostsLoaded) {
                  return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            UserPost(
                              post: state.posts[index],
                            ),
                            if (state.posts[index] == state.posts.last)
                              const SizedBox(height: 150),
                          ],
                        );
                      });
                } else if (state is PostsLoading) {
                  return circularProgress(context);
                } else if (state is PostsFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No Feeds',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
