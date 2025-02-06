import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';

abstract class ListofRootCauseRepository {

  Future<ListOfRootCauseEntity> getListofRootcause (String token, int deptid, int incidentid, int orgid);
}