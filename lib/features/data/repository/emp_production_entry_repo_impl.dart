import 'package:prominous/features/data/datasource/remote/emp_production_entry_datasourcel.dart';

import 'package:prominous/features/domain/repository/emp_production_entry_repo.dart';

import '../../domain/entity/emp_production_entity.dart';

class EmpProductionEntryRepoImpl implements EmpProductionRepository {
  final EmpProductionEntryDatasource empProductionEntryDatasource;

  EmpProductionEntryRepoImpl(this.empProductionEntryDatasource);

  @override
  Future<EmpProductionEntity> getempproduction(
    int pwsid,
    int deptid,int psid,
    String token,
    // int goodQuantities, int rejectedQuantities, int reworkQuantities
  ) {
    final result = empProductionEntryDatasource.getempproduction(pwsid,deptid,psid,token
        // , goodQuantities, rejectedQuantities, reworkQuantities
        );
    return result;
  }
}
