import 'package:prominous/features/data/datasource/remote/listofempworkstation_datasource.dart';
import 'package:prominous/features/data/model/listofempworkstation_model.dart';

import 'package:prominous/features/domain/repository/listofempworkstation_repo.dart';


class ListofEmpworkstationRepoImpl extends ListofEmpWorkstationRepository{
ListOfEmpWorkstationDatatsource listOfEmpWorkstationDatatsource;

  ListofEmpworkstationRepoImpl( this.listOfEmpWorkstationDatatsource);
  @override
  Future<ListofEmpWorkstationModel>getListofEmpWorkstation( int deptid, int psid, int processid, String token,int pwsId) async{
  return  await listOfEmpWorkstationDatatsource.getListofEmpWorkstation(deptid, psid, processid, token, pwsId);
  }
  
}