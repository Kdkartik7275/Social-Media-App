// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/src/posts/domain/entity/post.dart';

class ViewImage extends StatelessWidget {
  final PostEntity post;
  final String username;
  const ViewImage({
    Key? key,
    required this.post,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
      ),
      body: ClipRRect(
        child: CachedNetworkImage(
          imageUrl: post.mediaUrl!,
          placeholder: (context, url) {
            return circularProgress(context);
          },
          errorWidget: (context, url, error) {
            return const Icon(Icons.error);
          },
          // height: 400.0,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3.0),
              Row(
                children: [
                  const Icon(Ionicons.alarm_outline, size: 13.0),
                  const SizedBox(width: 3.0),
                  Text(
                    timeago.format(post.timestamp!.toDate()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
