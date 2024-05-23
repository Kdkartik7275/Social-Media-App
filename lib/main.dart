import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';
import 'package:social_x/core/utils/theme/theme.dart';
import 'package:social_x/firebase_options.dart';
import 'package:social_x/landing.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/init_dependencies.dart';
import 'package:social_x/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_x/src/posts/presentation/bloc/comments/comment_bloc.dart';
import 'package:social_x/src/posts/presentation/bloc/new_post/new_post_bloc.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/search/presentation/bloc/search_bloc.dart';
import 'package:social_x/src/splash.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';
import 'package:social_x/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroungMessageListening);
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<AuthBloc>()),
      BlocProvider(create: (_) => sl<CurrentuserCubit>()),
      BlocProvider(create: (_) => sl<ProfileBloc>()),
      BlocProvider(create: (_) => sl<SearchBloc>()),
      BlocProvider(create: (_) => sl<NewPostBloc>()),
      BlocProvider(create: (_) => sl<PostsBloc>()),
      BlocProvider(create: (_) => sl<CommentBloc>()),
      BlocProvider(create: (_) => sl<ChatsBloc>()),
      BlocProvider(create: (_) => sl<NotificationCubit>()),
    ],
    child: const MyApp(),
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroungMessageListening(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationServices services = NotificationServices();

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(OnGetCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaveConnect',
      theme: TTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is UnAuthenticated) {
            return Landing();
          } else if (state is Authenticated) {
            context.read<CurrentuserCubit>().getCurrentUserData();

            return BlocBuilder<CurrentuserCubit, CurrentuserState>(
                builder: (context, userState) {
              if (userState is CurrentuserLoaded) {
                return const TabScreen();
              }

              return const SplashScreen();
            });
          }
          return const SplashScreen();
        },
      ),
    );
  }
}

ThemeData themeData(ThemeData theme) {
  return theme.copyWith(
    textTheme: GoogleFonts.nunitoTextTheme(
      theme.textTheme,
    ),
  );
}
