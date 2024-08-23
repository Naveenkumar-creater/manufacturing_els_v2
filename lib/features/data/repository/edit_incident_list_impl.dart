import 'package:prominous/features/data/datasource/remote/edit_incident_list_datasource.dart';
import 'package:prominous/features/domain/entity/edit_incident_entity.dart';
import 'package:prominous/features/domain/repository/edit_incident_repo.dart';


class EditIncidentListRepoImpl extends EditIncidentListRepository {
 final EditIncidentListDatasourceImpl editIncidentListDatasourceImpl;
 EditIncidentListRepoImpl(this.editIncidentListDatasourceImpl);

  @override
  Future<EditIncidentListEntity> getListofIncident(String token, int deptid, int ipdid) {
   return editIncidentListDatasourceImpl.getListofIncident(token, deptid, ipdid);
  }

 
  
}