import '../../domain/entity/attendance_count_entity.dart';

class AttendanceCountModel extends AttendanceEntity {
  AttendanceCountModel({
    required this.attendanceCount,
  }) : super(attendanceEntity: attendanceCount);

  final AttendanceCount? attendanceCount;

  factory AttendanceCountModel.fromJson(Map<String, dynamic> json) {
    return AttendanceCountModel(
      attendanceCount: json["response_data"]["Attendance_Count"] == null
          ? null
          : AttendanceCount.fromJson(json["response_data"]["Attendance_Count"]),
    );
  }
}

class AttendanceCount extends AttendanceCountEntity {
  AttendanceCount({
    required this.totalEmployees,
    required this.presentees,
    required this.absentees,
  }) : super(
            totalEmployees: totalEmployees,
            presentees: presentees,
            absentees: absentees);

  final int? totalEmployees;
  final int? presentees;
  final int? absentees;

  factory AttendanceCount.fromJson(Map<String, dynamic> json) {
    return AttendanceCount(
      totalEmployees: json["TotalEmployees"],
      presentees: json["Presentees"],
      absentees: json["Absentees"],
    );
  }
}
