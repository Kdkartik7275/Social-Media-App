import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class MessageRead implements UseCaseWithParams<void, MessageReadParams> {
  final ChatsRepository repository;

  MessageRead({required this.repository});
  @override
  ResultFuture<void> call(MessageReadParams params) async => await repository
      .setMessageRead(chatId: params.chatId, userId: params.userId);
}

class MessageReadParams {
  final String chatId;
  final String userId;

  MessageReadParams({required this.chatId, required this.userId});
}
