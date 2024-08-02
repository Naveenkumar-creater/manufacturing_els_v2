import 'package:prominous/features/domain/entity/edit_entry_entity.dart';
import 'package:prominous/features/domain/repository/edit_entry_repo.dart';

class EditEntryUsecase{
  final EditEntryRepository  editEntryRepository;
  EditEntryUsecase(this.editEntryRepository);

  Future<EditEntryEntity> execute (int ipdId, int pwsId,int psid, int deptid,String token){
    return editEntryRepository.getEditEntry(ipdId, pwsId, psid, deptid, token);
  }
}