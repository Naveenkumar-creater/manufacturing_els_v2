import 'package:prominous/features/domain/entity/problem_status_entity.dart';

abstract class ProblemStatusRepository {

  Future<ProblemStatusEntity> getProblemStatus (String token, int orgid);
}