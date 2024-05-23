import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class GetChatRoom implements StreamUseCaseWithParams<ChatRoom, String> {
  final ChatsRepository repository;

  GetChatRoom({required this.repository});
  @override
  Stream<ChatRoom> call(String params) =>
      repository.getChatRoom(roomId: params);
}
