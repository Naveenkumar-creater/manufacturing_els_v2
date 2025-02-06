import 'package:prominous/features/domain/entity/edit_emp_list_entity.dart';
import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';

abstract class EditListofEmpWorkstationRepository{

  Future<EditListofEmpWorkstationEntity> getEditListofEmpWorkstation(int ipdid,String token, int psid, int orgid);


}