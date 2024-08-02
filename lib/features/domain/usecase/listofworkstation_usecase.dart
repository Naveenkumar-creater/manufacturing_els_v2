import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/repository/listofworkstation_repo.dart';

class ListofworkstationUsecase {
  final ListofWorkstationRepository listofWorkstationRepository;
  

  ListofworkstationUsecase(this.listofWorkstationRepository);

Future<ListOfWorkstationEntity> execute (int deptid,int psid, int processid, String token){
 return listofWorkstationRepository.getListofWorkstation(deptid, psid, processid, token)
;
}
}