import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/repository/listofrootcause_repo.dart';

class ListofRootCauseUsecase {

  final ListofRootCauseRepository listofRootCauseRepository;

  ListofRootCauseUsecase(this.listofRootCauseRepository);

  Future<ListOfRootCauseEntity> execute(String token , int deptid, int incidentid, int orgid){
    return listofRootCauseRepository.getListofRootcause(token, deptid, incidentid,  orgid);

  }
}