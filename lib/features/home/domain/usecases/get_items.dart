import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetItems implements UseCase<List<Item>, NoParams> {
  final HomeRepository repository;

  GetItems(this.repository);

  @override
  Future<Either<Failure, List<Item>>> call(NoParams params) async {
    return await repository.getItems();
  }
}

