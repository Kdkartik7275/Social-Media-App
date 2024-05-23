import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/chats/domain/entity/chat_room.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class ListenToChatRooms
    implements StreamUseCaseWithParams<List<ChatRoom>, String> {
  final ChatsRepository repository;

  ListenToChatRooms({required this.repository});
  @override
  Stream<List<ChatRoom>> call(String params) =>
      repository.listenToChats(myUserId: params);
}
