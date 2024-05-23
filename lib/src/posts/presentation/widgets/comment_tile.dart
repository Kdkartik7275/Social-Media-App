// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:social_x/src/posts/domain/entity/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentTile extends StatelessWidget {
  final CommentEntity comment;
  const CommentTile({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          comment.userDp!.isEmpty
              ? CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Center(
                    child: Text(
                      comment.username!.toUpperCase(),
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
                    '${comment.userDp}',
                  ),
                ),
          const SizedBox(width: 8),
          Text(
            comment.username!,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                comment.comment!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              timeago.format(comment.timestamp!.toDate()),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.grey,
              size: 15,
            ),
          ),
          const Text(
            "0",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
