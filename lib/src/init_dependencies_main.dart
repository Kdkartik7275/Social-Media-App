part of 'init_dependencies.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initUser();
  _initSearch();
  _initPosts();
  _initChats();
  _initNotifications();

  // -------------------------------- FIREBASE ------------------------------
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerFactory(() => InternetConnection());

  // ---------------------------- CORE  ---------------------------

  sl.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(sl()));
  sl.registerFactory<THelperFunctions>(() => THelperFunctions());
  sl.registerFactory<NotificationServices>(() => NotificationServices());
}

_initAuth() {
  // DATASOURCE
  sl
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(auth: sl()))

    // REPOSITORY
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        connectionChecker: sl(),
        remoteDataSource: sl(),
        userRemoteDataSource: sl()))
    // USECASES

    ..registerFactory(() => LoginUser(repository: sl()))
    ..registerFactory(() => RegisterUser(repository: sl()))
    ..registerFactory(() => ForgotPassword(repository: sl()))
    ..registerFactory(() => Logout(repository: sl()))

    // BLOC
    ..registerFactory(() => AuthBloc(
        getCurrentUser: sl(),
        registerUser: sl(),
        logoutUser: sl(),
        userProfile: sl(),
        saveUserData: sl(),
        loginUser: sl()));
}

_initUser() {
  // DATASOURCE
  sl
    ..registerFactory<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
        notificationServices: sl(),
        auth: sl(),
        firestore: sl(),
        storage: sl(),
        addNotification: sl(),
        removeotification: sl()))

    // REPOSITORY
    ..registerFactory<UserRepository>(() =>
        UserRepositoryImpl(connectionChecker: sl(), remoteDataSource: sl()))
    // USECASES

    ..registerFactory(() => StoreUserProfile(repository: sl()))
    ..registerFactory(() => SaveUserData(repository: sl()))
    ..registerFactory(() => DeleteUserData(repository: sl()))
    ..registerFactory(() => GetCurrentUser(repository: sl()))
    ..registerFactory(() => GetCurrentUserData(repository: sl()))
    ..registerFactory(() => UpdateSingleField(repository: sl()))
    ..registerFactory(() => GetUserData(repository: sl()))
    ..registerFactory(() => FollowUser(repository: sl()))
    ..registerFactory(() => BlockUser(repository: sl()))
    ..registerFactory(() => SetUserToken(repository: sl()))

    // BLOC
    ..registerFactory(() => CurrentuserCubit(
        currentUserData: sl(),
        updateSingleField: sl(),
        storeUserProfile: sl(),
        userToken: sl(),
        blockUser: sl()))
    ..registerFactory(() => ProfileBloc(userData: sl(), followUser: sl()));
}

_initSearch() {
  // DATASOURCE
  sl
    ..registerFactory<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(firestore: sl()))

    // REPOSITORY
    ..registerFactory<SearchRepository>(() => SearchRepositoryImplementation(
        connectionChecker: sl(), remoteDataSource: sl()))
    // USECASES

    ..registerFactory(() => SearchUser(repository: sl()))

    // BLOC
    ..registerFactory(() => SearchBloc(searchUser: sl()));
}

_initPosts() {
  // DATASOURCE
  sl
    ..registerFactory<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(
        firestore: sl(),
        addNotification: sl(),
        removeotification: sl(),
        notificationServices: sl()))

    // REPOSITORY
    ..registerFactory<PostRepository>(() =>
        PostRepositoryImpl(connectionChecker: sl(), remoteDataSource: sl()))
    // USECASES

    ..registerFactory(() => NewPost(repository: sl()))
    ..registerFactory(() => FetchPosts(repository: sl()))
    ..registerFactory(() => LikePost(repository: sl()))
    ..registerFactory(() => AddComment(repository: sl()))
    ..registerFactory(() => FetchComments(repository: sl()))
    ..registerFactory(() => ProfilePosts(repository: sl()))

    // BLOC
    ..registerFactory(() => NewPostBloc(newPost: sl()))
    ..registerFactory(() => CommentBloc(fetchComments: sl()))
    ..registerFactory(() => PostsBloc(
        fetchPosts: sl(),
        fetchProfilePosts: sl(),
        likePost: sl(),
        addComment: sl()));
}

_initNotifications() {
  // DATASOURCE
  sl
    ..registerFactory<NotificationDataSource>(
        () => NotificationDataSourceImpl(firestore: sl()))

    // REPOSITORY
    ..registerFactory<NotificationRepository>(() =>
        NotificationRepositoryImpl(connectionChecker: sl(), dataSource: sl()))
    // USECASES
    ..registerFactory(() => NewNotification(repository: sl()))
    ..registerFactory(() => LitenTONotifications(repository: sl()))
    ..registerFactory(() => Removeotification(repository: sl()))
    ..registerFactory(() => UpdateNotificationSeenStatus(repository: sl()))

    // BLOC
    ..registerFactory(() => NotificationCubit(
        notifications: sl(), updateNotificationSeenStatus: sl()));
}

_initChats() {
  // DATASOURCE
  sl
    ..registerFactory<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(
        firestore: sl(), functions: sl(), storage: sl()))

    // REPOSITORY
    ..registerFactory<ChatsRepository>(() =>
        ChatRepositoryImpl(connectionChecker: sl(), remoteDataSource: sl()))
    // USECASES

    ..registerFactory(() => GetChatRoom(repository: sl()))
    ..registerFactory(() => CreateChatRoom(repository: sl()))
    ..registerFactory(() => SetUserTyping(repository: sl()))
    ..registerFactory(() => SendTextMessage(repository: sl()))
    ..registerFactory(() => ListenToMessages(repository: sl()))
    ..registerFactory(() => ListenToChatRooms(repository: sl()))
    ..registerFactory(() => SendFileMessage(repository: sl()))
    ..registerFactory(() => MessageRead(repository: sl()))

    // BLOC
    ..registerFactory(() => ChatsBloc(
        chatRoom: sl(),
        createChatRoom: sl(),
        setUserTyping: sl(),
        listenToMessages: sl(),
        setMessageRead: sl(),
        listenToChats: sl(),
        fileMessage: sl(),
        sendTextMessage: sl()));
}
