import 'package:prominous/features/data/model/attendance_count.dart';
import 'package:prominous/features/domain/entity/attendance_count_entity.dart';
import 'package:prominous/features/domain/repository/attendance_count_repository.dart';

import '../datasource/remote/attendance_count_datasource.dart';

class AttendanceCountRepositoryImpl extends AttendanceCountRepository {
  final AttendanceCountDataSOurce attendanceCountDataSOurce;

  AttendanceCountRepositoryImpl(this.attendanceCountDataSOurce);

  @override
  Future<AttendanceCountModel> getAttCount(int id,int deptid,int psid, String token) async {
    AttendanceCountModel result =
        await attendanceCountDataSOurce.getAttCount( id, deptid, psid, token);
    return result;
  }
}
