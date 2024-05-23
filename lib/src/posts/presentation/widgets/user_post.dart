import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_x/core/common/widgets/cards/custom_card.dart';
import 'package:social_x/core/common/widgets/images/custom_image.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/usecases/like_post.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/posts/presentation/pages/comments.dart';
import 'package:social_x/src/posts/presentation/widgets/view_image.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/src/user/presentation/pages/profile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:animations/animations.dart';

class UserPost extends StatefulWidget {
  final PostEntity? post;

  const UserPost({super.key, this.post});

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  final DateTime timestamp = DateTime.now();

  bool isLiked = false;
  int likesCount = 0;

  isPostLikedByMe() {
    final myUser =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    if (widget.post!.likes!.contains(myUser.user.id)) {
      setState(() {
        isLiked = true;
      });
    } else {
      setState(() {
        isLiked = false;
      });
    }
    likesCount = widget.post!.likes!.length;
  }

  toggleLike() {
    if (isLiked) {
      setState(() {
        likesCount--;
        isLiked = false;
      });
    } else {
      setState(() {
        likesCount++;
        isLiked = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isPostLikedByMe();
  }

  @override
  Widget build(BuildContext context) {
    final myUser =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    return StreamBuilder<UserEntity>(
        stream:
            context.read<ProfileBloc>().getUser(userId: widget.post!.ownerId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return CustomCard(
                child: OpenContainer(
                    closedColor: Theme.of(context).cardColor,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return Column(
                        children: [
                          buildUser(context, myUser.user.id!, user),
                          CustomImage(
                            imageUrl: widget.post?.mediaUrl ?? '',
                            height: 350.0,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  buildLikeButton(myUser.user.id!),
                                  InkWell(
                                    onTap: () => TNavigators.navigatePush(
                                        context,
                                        CommmentsScreen(
                                          post: widget.post!,
                                          myId: myUser.user.id!,
                                        )),
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble,
                                      size: 25,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.bookmark_outline_rounded))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: buildLikesCount(
                                              context, likesCount),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, top: 3.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            user.username!,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            widget.post?.description ?? "",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .color,
                                              fontSize: 15.0,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    buildCommentsCount(
                                        context, widget.post!.commentsCount!),
                                    const SizedBox(height: 10),
                                    Text(
                                      timeago.format(
                                          widget.post!.timestamp!.toDate()),
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                    const SizedBox(height: 5)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return ViewImage(
                        post: widget.post!,
                        username: user.username!,
                      );
                    }),
                onTap: () {});
          }
          return const SizedBox();
        });
  }

  buildLikeButton(String myId) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        toggleLike();
        context.read<PostsBloc>().add(OnLikePost(
            params: LikePostParams(postId: widget.post!.postId!, myId: myId)));
      },
      icon: Icon(
        isLiked ? Ionicons.heart : Ionicons.heart_outline,
        color: isLiked ? Colors.red : Colors.black,
      ),
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        count == 0 ? "$count comments" : 'View all  $count comments',
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600),
      ),
    );
  }

  buildUser(BuildContext context, String myId, UserEntity user) {
    bool isMe = myId == widget.post!.ownerId;
    return Visibility(
      visible: !isMe,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 50.0,
          decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: GestureDetector(
            onTap: () => showProfile(context, profileId: widget.post!.ownerId),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  user.photoUrl!.isEmpty
                      ? CircleAvatar(
                          radius: 20.0,
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
                          radius: 20.0,
                          backgroundImage: CachedNetworkImageProvider(
                            '${user.photoUrl}',
                          ),
                        ),
                  const SizedBox(width: 5.0),
                  Text(
                    user.username ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert_sharp))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showProfile(BuildContext context, {String? profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ProfileScreen(
          uid: profileId!,
          showBackButton: true,
        ),
      ),
    );
  }
}
