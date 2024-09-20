import 'package:prominous/features/domain/entity/problem_status_entity.dart';
import 'package:prominous/features/domain/repository/problem_status_repo.dart';

class ProblemStatusUsecase {
  final ProblemStatusRepository problemStatusRepository;
  ProblemStatusUsecase(this.problemStatusRepository);

  Future<ProblemStatusEntity> execute(
    String token,
  ) async {
    return problemStatusRepository.getProblemStatus(token);
  }
}
