import 'package:social_x/core/common/usecase/usecase.dart';
import 'package:social_x/core/utils/constants/typedefs.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';

class UpdateSingleField
    implements UseCaseWithParams<void, Map<String, dynamic>> {
  final UserRepository repository;

  UpdateSingleField({required this.repository});
  @override
  ResultFuture<void> call(Map<String, dynamic> params) async =>
      await repository.updateSingleField(json: params);
}
