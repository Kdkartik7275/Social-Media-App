// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/presentation/widgets/user_post.dart';

class SinglePost extends StatelessWidget {
  final PostEntity post;
  const SinglePost({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
      ),
      body: UserPost(post: post),
    );
  }
}
