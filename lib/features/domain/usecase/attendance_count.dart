import 'package:prominous/features/domain/entity/attendance_count_entity.dart';

import '../repository/attendance_count_repository.dart';

class AttendanceCountUseCases {
  final AttendanceCountRepository attendanceCountRepository;

  AttendanceCountUseCases(this.attendanceCountRepository);
  Future<AttendanceEntity> execute(int id,int deptid,int psid, String token) async {
    return await attendanceCountRepository.getAttCount(id, deptid, psid, token);
  }
}
