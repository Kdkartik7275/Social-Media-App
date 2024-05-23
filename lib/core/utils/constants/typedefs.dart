import 'package:fpdart/fpdart.dart';
import 'package:social_x/core/common/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = Future<Either<Failure, void>>;

typedef ResultStream<T> = Stream<Either<Failure, T>>;
