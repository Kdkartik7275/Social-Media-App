import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/src/chats/domain/entity/message.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class ListenToMessages
    implements
        StreamUseCaseWithParams<List<MessageEntity>, ListenToMessagesParams> {
  final ChatsRepository repository;

  ListenToMessages({required this.repository});
  @override
  Stream<List<MessageEntity>> call(ListenToMessagesParams params) =>
      repository.listenToMessages(chatRoomId: params.chatRoomId);
}

class ListenToMessagesParams {
  final String chatRoomId;

  ListenToMessagesParams({required this.chatRoomId});
}
