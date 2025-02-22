import 'package:prominous/features/data/datasource/remote/edit_entry_datasource.dart';
import 'package:prominous/features/domain/entity/edit_entry_entity.dart';
import 'package:prominous/features/domain/repository/edit_entry_repo.dart';

class EditEntryRepoImpl implements  EditEntryRepository{

  final EditEntryDatasource editEntryDatasource;
  EditEntryRepoImpl(this.editEntryDatasource);
  @override
  Future<EditEntryEntity> getEditEntry(int ipdId, int pwsId,int psid, int deptid,String token, int orgid) {
  final result= editEntryDatasource.getEditEntry(ipdId, pwsId, psid, deptid, token,  orgid);
  return result;
  }
  
}