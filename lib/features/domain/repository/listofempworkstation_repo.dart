import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';

abstract class ListofEmpWorkstationRepository{

  Future<ListofEmpWorkstationEntity> getListofEmpWorkstation( int deptid, int psid, int processid, String token,int pwsId);


}