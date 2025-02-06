import 'package:prominous/features/data/datasource/remote/edit_emp_list_datasource.dart';
import 'package:prominous/features/data/model/edit_emp_list_model.dart';
import 'package:prominous/features/domain/repository/edit_emp_list_repo.dart';


class EditListofEmpworkstationRepoImpl extends EditListofEmpWorkstationRepository{
EditListOfEmpWorkstationDatatsource editListOfEmpWorkstationDatatsource;

  EditListofEmpworkstationRepoImpl( this.editListOfEmpWorkstationDatatsource);
  @override
  Future<EditListofEmpWorkstationModel>getEditListofEmpWorkstation(int ipdid, String token, int psid,int orgid) async{
  return  await editListOfEmpWorkstationDatatsource.getEditListofEmpWorkstation(ipdid, token,psid,  orgid);
  }
  
}