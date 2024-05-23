// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_x/core/common/widgets/appbar/appbar.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';

import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/src/user/presentation/pages/profile.dart';

class Follows extends StatefulWidget {
  final bool isFollwers;
  final List<String> users;
  const Follows({
    Key? key,
    required this.isFollwers,
    required this.users,
  }) : super(key: key);

  @override
  State<Follows> createState() => _FollowsState();
}

class _FollowsState extends State<Follows> {
  @override
  Widget build(BuildContext context) {
    final me =
        BlocProvider.of<CurrentuserCubit>(context).state as CurrentuserLoaded;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        leadingIconColor: Colors.black,
        title: Text(widget.isFollwers ? "Followers" : "Followings"),
      ),
      body: ListView.builder(
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            if (widget.users.isEmpty) {
              return const SizedBox();
            }
            final userId = widget.users[index];
            return StreamBuilder(
                stream: context.read<ProfileBloc>().getUser(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return ListTile(
                      onTap: () => TNavigators.navigatePush(
                          context, ProfileScreen(uid: user.id!)),
                      leading: user.photoUrl!.isEmpty
                          ? CircleAvatar(
                              radius: 20.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
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
                      trailing: user.id! == me.user.id!
                          ? const SizedBox()
                          : Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: user.followers!.contains(me.user.id!)
                                      ? Colors.white
                                      : const Color(0xff597FDB),
                                  border: user.followers!.contains(me.user.id!)
                                      ? Border.all(
                                          color: const Color(0xff597FDB))
                                      : null),
                              child: Center(
                                child: Text(
                                  user.followers!.contains(me.user.id!)
                                      ? "Unfollow"
                                      : user.followings!.contains(me.user.id!)
                                          ? "Follow Back"
                                          : "Follow",
                                  style: TextStyle(
                                      color:
                                          user.followers!.contains(me.user.id!)
                                              ? const Color(0xff597FDB)
                                              : Colors.white,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                    );
                  } else {
                    return circularProgress(context);
                  }
                });
          }),
    );
  }
}
