import 'package:prominous/features/domain/entity/edit_incident_entity.dart';

abstract class EditIncidentListRepository{
  Future<EditIncidentListEntity> getListofIncident(String token,int deptid,int ipdid);
}