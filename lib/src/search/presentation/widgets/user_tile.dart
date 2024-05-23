import 'package:flutter/material.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/user/domain/entity/user.dart';
import 'package:social_x/src/user/presentation/pages/profile.dart';

class SearchUserTile extends StatelessWidget {
  const SearchUserTile({
    super.key,
    required this.user,
  });

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => TNavigators.navigatePush(
          context,
          ProfileScreen(
            uid: user.id!,
            showBackButton: true,
          )),
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          : CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                '${user.photoUrl}',
              ),
            ),
      title: Text(
        user.username!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.email!,
      ),
    );
  }
}
