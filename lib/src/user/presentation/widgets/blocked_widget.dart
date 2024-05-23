import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

class BlockedWidget extends StatelessWidget {
  const BlockedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 100),
        Icon(
          Ionicons.lock_closed_outline,
          size: 70,
        ),
        SizedBox(height: 20),
        Text(
          "User is Blocked By You",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
