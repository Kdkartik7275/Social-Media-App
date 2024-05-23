// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:social_x/src/posts/presentation/bloc/comments/comment_bloc.dart';
import 'package:social_x/src/posts/presentation/widgets/comment_tile.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/utils/constants/colors.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/domain/usecases/add_comment.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';

class CommmentsScreen extends StatefulWidget {
  final PostEntity post;
  final String myId;
  const CommmentsScreen({
    Key? key,
    required this.post,
    required this.myId,
  }) : super(key: key);

  @override
  State<CommmentsScreen> createState() => _CommmentsScreenState();
}

class _CommmentsScreenState extends State<CommmentsScreen> {
  final comment = TextEditingController();
  List<CommentEntity> comments = [];

  @override
  void initState() {
    super.initState();
    context
        .read<CommentBloc>()
        .add(OnFetchComments(postId: widget.post.postId!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
        title: Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<CommentBloc, CommentState>(
              listener: (context, state) {},
              buildWhen: (previous, current) => current is! AddCommentLoading,
              builder: (context, state) {
                if (state is CommentsFailure) {
                  return Center(
                    child: Text(state.error),
                  );
                } else if (state is CommentsLoaded) {
                  comments = state.comments;
                  return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return CommentTile(comment: comment);
                      });
                } else if (state is CommentsLoading && comments.isEmpty) {
                  return circularProgress(context);
                }
                return const SizedBox();
              },
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: comment,
                  decoration: const InputDecoration(
                      hintText: "Add your comment...",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                )),
                TextButton(
                    onPressed: () {
                      if (comment.text.isNotEmpty) {
                        context.read<PostsBloc>().add(OnAddComment(
                            params: AddCommentParams(
                                myId: widget.myId,
                                postId: widget.post.postId!,
                                comment: comment.text)));
                        comment.clear();
                      }
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(color: TColors.darkAccent, fontSize: 16),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
