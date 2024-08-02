import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';

abstract class ListofWorkstationRepository{

  Future<ListOfWorkstationEntity> getListofWorkstation(int deptid,int psid, int processid, String token);
}