// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotificationsCount;
  const NotificationBadge({
    Key? key,
    required this.totalNotificationsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      child: Center(
        child: Text(
          '$totalNotificationsCount',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
