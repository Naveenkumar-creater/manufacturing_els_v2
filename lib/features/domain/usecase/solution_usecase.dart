import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';
import 'package:prominous/features/domain/entity/target_qty_entity.dart';
import 'package:prominous/features/domain/repository/rootcause_solution_repo.dart';


class RootcauseSolutionUsecase {
  final RootcauseSolutionRepository rootcauseSolutionRepository;
  RootcauseSolutionUsecase(this.rootcauseSolutionRepository);

  Future<RootcauseSolutionEntity> execute ( int rootcauseid,int deptid, String token, int orgid)async {
    
    return rootcauseSolutionRepository.getListofSolution(rootcauseid, deptid, token,  orgid);
  }
}
