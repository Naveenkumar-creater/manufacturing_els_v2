import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';

abstract class RootcauseSolutionRepository{

  Future<RootcauseSolutionEntity> getListofSolution(int rootcauseid,int deptid, String token,int orgid);
}