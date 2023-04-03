import 'package:fpdart/fpdart.dart';
import 'package:twitter_clonee/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
