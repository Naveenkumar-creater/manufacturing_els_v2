import 'package:prominous/features/domain/entity/workstation_problem_entity.dart';

abstract class WorkstationProblemRepository{
Future<WorkstationProblemsEntity>getResolveProblemList(int pwsid, String token);
}