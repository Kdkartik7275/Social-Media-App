// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/posts/presentation/widgets/user_post.dart';

class AllPosts extends StatefulWidget {
  final String userId;
  const AllPosts({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
        title: Text("All Posts"),
      ),
      body: StreamBuilder<List<PostEntity>>(
          stream: context.read<PostsBloc>().profilePosts(userId: widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data;
              if (posts!.isEmpty) {
                return const Center(
                  child: Text("No Posts"),
                );
              }
              return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return UserPost(
                      post: posts[index],
                    );
                  });
            }
            return circularProgress(context);
          }),
    );
  }
}
