// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/notifications/domain/repository/notifications_repository.dart';

class Removeotification
    implements UseCaseWithParams<void, RemoveotificationParams> {
  final NotificationRepository repository;

  Removeotification({required this.repository});
  @override
  ResultFuture<void> call(RemoveotificationParams params) async {
    return await repository.removeNotification(
        userId: params.userId, key: params.key, value: params.value);
  }
}

class RemoveotificationParams {
  final String userId;
  final String key;
  final String value;

  RemoveotificationParams(
    this.userId,
    this.key,
    this.value,
  );
}
