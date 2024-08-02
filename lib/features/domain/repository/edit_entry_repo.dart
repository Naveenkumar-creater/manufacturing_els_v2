import 'package:prominous/features/domain/entity/edit_entry_entity.dart';

abstract class EditEntryRepository {
Future <EditEntryEntity> getEditEntry(int ipdId, int pwsId,int psid, int deptid,String token);
}