import 'package:prominous/features/domain/entity/shift_status_entity.dart';

abstract class ShiftStatusRepository{
  Future<ShiftStatusEntity> getShiftStatus(int deptid,int processId,String token);
}