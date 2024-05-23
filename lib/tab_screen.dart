import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:social_x/core/common/widgets/components/life_cycle_event_handler.dart';
import 'package:social_x/core/common/widgets/indicators/indicators.dart';
import 'package:social_x/core/utils/constants/colors.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';
import 'package:social_x/core/utils/navigator/navigators.dart';
import 'package:social_x/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_x/src/notifications/presentation/pages/notification.dart';
import 'package:social_x/src/posts/presentation/pages/create_post.dart';
import 'package:social_x/src/posts/presentation/pages/feeds.dart';
import 'package:social_x/src/search/presentation/pages/search.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/pages/profile.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;
  NotificationServices services = NotificationServices();

  List<IconData> iconsList = [
    IconlyLight.home,
    IconlyLight.search,
    IconlyLight.notification,
    IconlyLight.profile
  ];

  List<IconData> iconsListBold = [
    IconlyBold.home,
    IconlyBold.search,
    IconlyBold.notification,
    IconlyBold.profile
  ];

  List<Widget> pages = [
    const Feeds(),
    const SearchScreen(),
    const NotificationScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  void initState() {
    super.initState();
    setUserToken();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () =>
            context.read<CurrentuserCubit>().updateOnlineStatus(false),
        resumeCallBack: () =>
            context.read<CurrentuserCubit>().updateOnlineStatus(true),
      ),
    );
  }

  setUserToken() async {
    String token = await services.getToken();
    context.read<CurrentuserCubit>().setUserToken(
        token: token, userId: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentuserCubit, CurrentuserState>(
      builder: (context, state) {
        if (state is CurrentuserLoading) {
          return Scaffold(
            body: circularProgress(context),
          );
        }
        final me = (BlocProvider.of<CurrentuserCubit>(context).state
            as CurrentuserLoaded);
        return Scaffold(
            body: pages[_page],
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                newPostORStory(context);
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: TColors.lightAccent
                    //  gradient: TGradients.buttonLinearGradient,
                    ),
                child: Icon(
                  Ionicons.add_circle,
                  size: 30,
                  color: TColors.lightPrimary,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                gapLocation: GapLocation.center,
                height: 60,
                leftCornerRadius: 0,
                rightCornerRadius: 0,
                itemCount: pages.length,
                tabBuilder: (int index, bool isActive) {
                  if (index == 2) {
                    return StreamBuilder(
                        stream: context
                            .read<NotificationCubit>()
                            .listenToNotifcations(myUserId: me.user.id!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final unreadCount = snapshot.data!
                                .where((element) => element.isSeen == false)
                                .length;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  isActive
                                      ? iconsListBold[index]
                                      : iconsList[index],
                                  color: isActive
                                      ? TColors.darkAccent
                                      : TColors.darkPrimary,
                                ),
                                unreadCount > 0
                                    ? Positioned(
                                        top: 10,
                                        right: 20,
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                              child: Text(
                                            unreadCount > 4
                                                ? "4+"
                                                : unreadCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9),
                                          )),
                                        ))
                                    : const SizedBox()
                              ],
                            );
                          }
                          return Icon(
                            isActive ? iconsListBold[index] : iconsList[index],
                            color: isActive
                                ? TColors.darkAccent
                                : TColors.darkPrimary,
                          );
                        });
                  }
                  return Icon(
                    isActive ? iconsListBold[index] : iconsList[index],
                    color: isActive ? TColors.darkAccent : TColors.darkPrimary,
                  );
                },
                activeIndex: _page,
                onTap: (index) => setState(() => _page = index)));
      },
    );
  }

  Future<dynamic> newPostORStory(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    'Choose Upload',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: const Text('Make a post'),
                onTap: () {
                  Navigator.pop(context);
                  TNavigators.navigatePush(context, const CreatePost());
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.camera_on_rectangle,
                  size: 25.0,
                ),
                title: const Text('Add to story'),
                onTap: () async {
                  // Navigator.pop(context);
                  // await viewModel.pickImage(context: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
