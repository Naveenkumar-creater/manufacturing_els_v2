import 'package:prominous/features/data/datasource/remote/listofworkstation_datasource.dart';
import 'package:prominous/features/data/model/listofworkstation_model.dart';
import 'package:prominous/features/domain/entity/listofworkstation_entity.dart';
import 'package:prominous/features/domain/repository/listofworkstation_repo.dart';

class ListofworkstationRepoImpl extends ListofWorkstationRepository{
ListOfWorkstationDatatsource listOfWorkstationDatatsource;

  ListofworkstationRepoImpl( this.listOfWorkstationDatatsource);
  @override
  Future<ListOfWorkstationModel> getListofWorkstation(int deptid, int psid, int processid, String token) async{
  return  await listOfWorkstationDatatsource.getListofWorkstation(deptid, psid, processid, token);
  }
  
}