import 'package:prominous/features/domain/entity/edit_incident_entity.dart';
import 'package:prominous/features/domain/repository/edit_incident_repo.dart';

class EditIncidentListUsecase {

final EditIncidentListRepository editIncidentListRepository;
EditIncidentListUsecase(this.editIncidentListRepository);

Future<EditIncidentListEntity> execute (String token,int deptid,int ipdid, int orgid){
return  editIncidentListRepository.getListofIncident(token, deptid, ipdid,  orgid);
}

}