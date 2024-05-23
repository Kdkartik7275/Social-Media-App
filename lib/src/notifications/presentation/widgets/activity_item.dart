// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:social_x/src/notifications/domain/entity/notification.dart';

class ActivityItem extends StatefulWidget {
  final NotificationEntity notification;
  const ActivityItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserEntity>(
        stream: context
            .read<ProfileBloc>()
            .getUser(userId: widget.notification.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              onTap: () {
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (_) => widget.activity!.type == "follow"
                //         ? Profile(profileId: widget.activity!.userId)
                //         : ViewActivityDetails(activity: widget.activity!),
                //   ),
                // );
              },
              leading: user.photoUrl!.isEmpty
                  ? CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Text(
                          user.username![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
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
              title: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(
                      text: '${user.username!} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: buildTextConfiguration(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                timeago.format(widget.notification.timestamp!.toDate()),
                style: const TextStyle(fontSize: 12),
              ),
              trailing: previewConfiguration(),
            );
          }
          return const SizedBox();
        });
  }

  previewConfiguration() {
    if (widget.notification.type == "like" ||
        widget.notification.type == "comment") {
      return buildPreviewImage();
    } else {
      return const Text('');
    }
  }

  buildTextConfiguration() {
    if (widget.notification.type == "like") {
      return "liked your post";
    } else if (widget.notification.type == "follow") {
      return "started following you";
    } else if (widget.notification.type == "comment") {
      return "commented '${widget.notification.commentData}'";
    } else {
      return "Error: Unknown type '${widget.notification.type}'";
    }
  }

  buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: widget.notification.mediaUrl!,
        placeholder: (context, url) {
          return circularProgress(context);
        },
        errorWidget: (context, url, error) {
          return const Icon(Icons.error);
        },
        height: 40.0,
        fit: BoxFit.cover,
        width: 40.0,
      ),
    );
  }
}
