import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:social_x/core/common/network/connection_checker.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';
import 'package:social_x/core/utils/helper_functions/helper_functions.dart';
import 'package:social_x/src/authentication/data/data_source/auth_remote_data_source.dart';
import 'package:social_x/src/authentication/data/repository/auth_repository_impl.dart';
import 'package:social_x/src/authentication/domain/repository/auth_repository.dart';
import 'package:social_x/src/authentication/domain/usecases/forgot_password.dart';
import 'package:social_x/src/authentication/domain/usecases/login_user.dart';
import 'package:social_x/src/authentication/domain/usecases/logout.dart';
import 'package:social_x/src/authentication/domain/usecases/register_user.dart';
import 'package:social_x/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:social_x/src/chats/data/data_source/chat_remote_data_source.dart';
import 'package:social_x/src/chats/data/repositories/chat_repository_impl.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';
import 'package:social_x/src/chats/domain/usecases/chat_room.dart';
import 'package:social_x/src/chats/domain/usecases/create_chat_room.dart';
import 'package:social_x/src/chats/domain/usecases/file_message.dart';
import 'package:social_x/src/chats/domain/usecases/listen_chatroomds.dart';
import 'package:social_x/src/chats/domain/usecases/listen_messages.dart';
import 'package:social_x/src/chats/domain/usecases/message_read.dart';
import 'package:social_x/src/chats/domain/usecases/set_user_typing.dart';
import 'package:social_x/src/chats/domain/usecases/text_message.dart';
import 'package:social_x/src/chats/presentation/bloc/chats_bloc.dart';
import 'package:social_x/src/notifications/data/data_source/notification_data_source.dart';
import 'package:social_x/src/notifications/data/repositories/notification_repo_impl.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';
import 'package:social_x/src/notifications/domain/usecases/listen_notifications.dart';
import 'package:social_x/src/notifications/domain/usecases/new_notification.dart';
import 'package:social_x/src/notifications/domain/usecases/remove_notification.dart';
import 'package:social_x/src/notifications/domain/usecases/update_seen.dart';
import 'package:social_x/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_x/src/posts/data/data_source/post_data_source.dart';
import 'package:social_x/src/posts/data/repositories/post_repository_impl.dart';
import 'package:social_x/src/posts/domain/repository/post_repository.dart';
import 'package:social_x/src/posts/domain/usecases/add_comment.dart';
import 'package:social_x/src/posts/domain/usecases/fetch_comments.dart';
import 'package:social_x/src/posts/domain/usecases/fetch_posts.dart';
import 'package:social_x/src/posts/domain/usecases/like_post.dart';
import 'package:social_x/src/posts/domain/usecases/new_post.dart';
import 'package:social_x/src/posts/domain/usecases/profile_posts.dart';
import 'package:social_x/src/posts/presentation/bloc/comments/comment_bloc.dart';
import 'package:social_x/src/posts/presentation/bloc/new_post/new_post_bloc.dart';
import 'package:social_x/src/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:social_x/src/search/data/data_souce/search_remote_data_source.dart';
import 'package:social_x/src/search/data/repositories/search_repository_impl.dart';
import 'package:social_x/src/search/domain/repository/search_repository.dart';
import 'package:social_x/src/search/domain/usecases/search_user.dart';
import 'package:social_x/src/search/presentation/bloc/search_bloc.dart';
import 'package:social_x/src/user/data/data_source/user_remote_data_source.dart';
import 'package:social_x/src/user/data/repository/user_repository_impl.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/block_user.dart';
import 'package:social_x/src/user/domain/usecases/delete_user_data.dart';
import 'package:social_x/src/user/domain/usecases/follow_user.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user.dart';
import 'package:social_x/src/user/domain/usecases/get_current_user_data.dart';
import 'package:social_x/src/user/domain/usecases/get_user_data.dart';
import 'package:social_x/src/user/domain/usecases/save_user_data.dart';
import 'package:social_x/src/user/domain/usecases/store_user_profile.dart';
import 'package:social_x/src/user/domain/usecases/update_single_field.dart';
import 'package:social_x/src/user/domain/usecases/user_token.dart';
import 'package:social_x/src/user/presentation/bloc/cubit/currentuser_cubit.dart';
import 'package:social_x/src/user/presentation/bloc/profile/profile_bloc.dart';

part 'init_dependencies_main.dart';
