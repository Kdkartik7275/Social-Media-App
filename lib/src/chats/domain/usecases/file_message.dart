import 'dart:io';

import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/core/utils/enums/message_type.dart';
import 'package:social_x/src/chats/domain/repository/chat_repository.dart';

class SendFileMessage
    implements UseCaseWithParams<void, SendFileMessageParams> {
  final ChatsRepository repository;

  SendFileMessage({required this.repository});
  @override
  ResultFuture<void> call(SendFileMessageParams params) async =>
      await repository.sendFileMessage(
          type: params.type,
          roomId: params.roomId,
          file: params.file,
          myUserId: params.myUserId);
}

class SendFileMessageParams {
  final String myUserId;
  final MessagesType type;
  final File file;
  final String roomId;

  SendFileMessageParams(
      {required this.myUserId,
      required this.type,
      required this.file,
      required this.roomId});
}
