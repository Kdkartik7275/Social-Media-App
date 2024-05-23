import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class CreateChatRoom
    implements UseCaseWithParams<String, CreateChatRoomParams> {
  final ChatsRepository repository;

  CreateChatRoom({required this.repository});
  @override
  ResultFuture<String> call(CreateChatRoomParams params) async =>
      await repository.createChatRoom(
          userId: params.userId, myUserId: params.myUserId);
}

class CreateChatRoomParams {
  final String userId;
  final String myUserId;

  CreateChatRoomParams({required this.userId, required this.myUserId});
}
