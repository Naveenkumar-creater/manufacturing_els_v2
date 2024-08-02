import 'package:prominous/features/domain/entity/attendance_count_entity.dart';

abstract class AttendanceCountRepository {
  Future<AttendanceEntity> getAttCount(int id,int deptid,int psid, String token);
}
