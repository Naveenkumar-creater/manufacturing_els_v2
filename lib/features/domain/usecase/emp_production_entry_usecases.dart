import '../entity/emp_production_entity.dart';
import '../repository/emp_production_entry_repo.dart';

class EmpProductionEntryUsecases {
  final EmpProductionRepository empProductionRepository;

  EmpProductionEntryUsecases(this.empProductionRepository);

  Future<EmpProductionEntity> execute(int pwsid,int deptid,int psid, String token
      //int goodQuantities, int rejectedQuantities, int reworkQuantities
      ) {
    return empProductionRepository.getempproduction(pwsid,deptid,psid, token
        //,goodQuantities, rejectedQuantities, reworkQuantities
        );
  }
}
