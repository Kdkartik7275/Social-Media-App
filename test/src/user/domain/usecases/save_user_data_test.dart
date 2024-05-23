import 'package:flutter_test/flutter_test.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/save_user_data.dart';

import 'user_repo.mock.dart';

void main() {
  late UserRepository repository;
  late SaveUserData usecase;

  setUp(() {
    repository = MockUserRepo();

    usecase = SaveUserData(repository: repository);

    group("Save User Data UseCase", () {
      test("description", () {});
    });
  });
}
