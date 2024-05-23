import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class SetUserTyping implements UseCaseWithParams<void, SetUserTypingParams> {
  final ChatsRepository repository;

  SetUserTyping({required this.repository});
  @override
  ResultFuture<void> call(SetUserTypingParams params) async =>
      await repository.setUserTyping(
          chatId: params.chatId,
          myUserId: params.myUserId,
          istyping: params.istyping);
}

class SetUserTypingParams {
  final String myUserId;
  final String chatId;
  final bool istyping;

  SetUserTypingParams(
      {required this.myUserId, required this.chatId, required this.istyping});
}
