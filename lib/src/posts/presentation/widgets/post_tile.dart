// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';
import 'package:social_x/src/posts/presentation/pages/single_post.dart';

class PostTile extends StatefulWidget {
  final PostEntity? post;

  PostTile({
    Key? key,
    this.post,
  }) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          TNavigators.navigatePush(context, SinglePost(post: widget.post!)),
      child: SizedBox(
        height: 150,
        width: 150,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(3.0),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.post!.mediaUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => circularProgress(context),
              errorWidget: (context, url, error) => const Center(
                child: Text(
                  'Unable to load Image',
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
