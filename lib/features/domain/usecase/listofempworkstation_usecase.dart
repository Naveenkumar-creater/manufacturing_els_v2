import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/repository/listofempworkstation_repo.dart';
import 'package:prominous/features/domain/repository/listofworkstation_repo.dart';

class ListofEmpworkstationUsecase {
  final ListofEmpWorkstationRepository listofEmpWorkstationRepository;
  

  ListofEmpworkstationUsecase(this.listofEmpWorkstationRepository);

Future<ListofEmpWorkstationEntity> execute (int deptid,int psid, int processid, String token,int pwsId){
  return listofEmpWorkstationRepository.getListofEmpWorkstation(deptid, psid, processid, token, pwsId);

;}
}