import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/item.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Item>>> getItems();
}

