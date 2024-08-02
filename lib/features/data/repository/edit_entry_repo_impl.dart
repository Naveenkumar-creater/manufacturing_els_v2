import 'package:prominous/features/data/datasource/remote/edit_entry_datasource.dart';
import 'package:prominous/features/domain/entity/edit_entry_entity.dart';
import 'package:prominous/features/domain/repository/edit_entry_repo.dart';

class EditEntryRepoImpl implements  EditEntryRepository{

  final EditEntryDatasourceImpl editEntryDatasourceImpl;
  EditEntryRepoImpl(this.editEntryDatasourceImpl);

  @override
  Future<EditEntryEntity> getEditEntry(int ipdId, int pwsId,int psid, int deptid,String token) {
  final result= editEntryDatasourceImpl.getEditEntry(ipdId, pwsId, psid, deptid, token);
  return result;
  }
  
}