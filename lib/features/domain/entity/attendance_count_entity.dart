import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final AttendanceCountEntity? attendanceEntity;

  const AttendanceEntity({this.attendanceEntity});
  @override
  List<Object?> get props => [attendanceEntity];
}

class AttendanceCountEntity extends Equatable {
  final int? totalEmployees;
  final int? presentees;
  final int? absentees;

  AttendanceCountEntity({this.totalEmployees, this.presentees, this.absentees});
  @override
  List<Object?> get props => [totalEmployees, presentees, absentees];
}
