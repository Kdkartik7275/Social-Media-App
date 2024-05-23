import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_x/core/common/errors/failure.dart';
import 'package:social_x/src/user/domain/repository/user_repository.dart';
import 'package:social_x/src/user/domain/usecases/follow_user.dart';

import 'user_repo.mock.dart';

void main() {
  late UserRepository repository;
  late FollowUser usecase;

  setUp(() {
    repository = MockUserRepo();

    usecase = FollowUser(repository: repository);
  });

  test(
      "should call follow user method and return null when user followed successfully",
      () async {
    // arrange

    when(() => repository.followUser(
            userId: any(named: 'userId'), myId: any(named: 'myId')))
        .thenAnswer((invocation) async => right(null));

    // act

    final result =
        await usecase.call(FollowUserParams(userId: 'userId', myId: 'myId'));

    //assert

    expect(result, right(null));
  });

  test("should return failure when user failed to follow user", () async {
    final failure = FirebaseFailure(message: "Something went Wrong");

    // arrange

    when(() => repository.followUser(
            userId: any(named: 'userId'), myId: any(named: 'myId')))
        .thenAnswer((invocation) async => left(failure));

    // act

    final result =
        await usecase.call(FollowUserParams(userId: 'userId', myId: 'myId'));

    expect(result, left(failure));
  });
}
