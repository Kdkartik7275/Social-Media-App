// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/core/utils/popups/snackbars.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/authentication/presentation/pages/login.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/posts/presentation/pages/all_posts.dart';
import 'package:social_x/src/posts/presentation/widgets/post_tile.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/src/user/presentation/widgets/blocked_widget.dart';
import 'package:social_x/src/user/presentation/widgets/profile_headerr.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isBlockedByMe = false;
  @override
  void initState() {
    super.initState();
    checkBlockStatus();
  }

  checkBlockStatus() {
    final me =
        (BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded)
            .user;
    if (me.blockedUsers!.contains(widget.uid)) {
      setState(() {
        isBlockedByMe = true;
      });
    }
  }

  toggleBlock({required String myUserId}) {
    context
        .read<CurrentuserCubit>()
        .block(userId: widget.uid, myUserId: myUserId);
    setState(() {
      isBlockedByMe = !isBlockedByMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    final me =
        (BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded)
            .user;
    return StreamBuilder<UserEntity>(
        stream: context.read<ProfileBloc>().getUser(userId: widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;

            return Scaffold(
              appBar: TAppBar(
                showBackArrow: widget.showBackButton,
                leadingIconColor: Colors.black,
                title:
                    Text(widget.uid == me.id ? me.username! : user.username!),
                actions: [
                  widget.uid == me.id
                      ? BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is UnAuthenticated) {
                              TNavigators.offALL(context, const Login());
                            }
                            if (state is AuthFailure) {
                              return TSnackBar.showErrorSnackBar(
                                  context: context, message: state.error);
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: GestureDetector(
                                onTap: () async {
                                  context
                                      .read<CurrentuserCubit>()
                                      .updateOnlineStatus(false);
                                  context.read<AuthBloc>().add(OnLogoutUser());
                                },
                                child: const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: false,
                    toolbarHeight: 5.0,
                    collapsedHeight: 6.0,
                    expandedHeight: 230.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeader(
                          myId: me.id!,
                          user: user,
                          isBlocked: isBlockedByMe,
                          onBlock: () => toggleBlock(myUserId: me.id!)),
                    ),
                  ),
                  isBlockedByMe
                      ? SliverList(delegate:
                          SliverChildBuilderDelegate((context, index) {
                          if (index > 0) return null;
                          return const BlockedWidget();
                        }))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index > 0) return null;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'All Posts',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () =>
                                              TNavigators.navigatePush(context,
                                                  AllPosts(userId: user.id!)),
                                          icon:
                                              const Icon(Ionicons.grid_outline),
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<List<PostEntity>>(
                                    stream: context
                                        .read<PostsBloc>()
                                        .profilePosts(userId: widget.uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var list = snapshot.data!;
                                        return list.isEmpty
                                            ? const Center(
                                                child: Text("No Posts"),
                                              )
                                            : GridView.builder(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2.0, left: 2.0),
                                                scrollDirection: Axis.vertical,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 2 / 2,
                                                ),
                                                itemCount: list.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return PostTile(
                                                    post: list[index],
                                                  );
                                                },
                                              );
                                      }
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      } else {
                                        return circularProgress(context);
                                      }
                                    },
                                  )
                                  // buildPostView()
                                ],
                              );
                            },
                          ),
                        )
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return circularProgress(context);
          }
        });
  }
}
