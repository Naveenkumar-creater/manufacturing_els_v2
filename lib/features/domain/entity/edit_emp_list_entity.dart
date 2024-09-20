
import 'package:equatable/equatable.dart';

class EditListofEmpWorkstationEntity extends Equatable {
  final List<EditEmpListEntity>? editEmplistEntity;

  const EditListofEmpWorkstationEntity ({this.editEmplistEntity});

  @override
  List<Object?> get props => [editEmplistEntity];
}

class EditEmpListEntity extends Equatable {
  const EditEmpListEntity( {
  required this.flAttId,
        required this.flAttShiftStatus,
        required this.flAttDate,
        required this.ipdeWorkedMinutes,
        required this.empName,
        required this.flAttStatus,
        required this.ipdeId,
        required this.empId,

  });
 final int? flAttId;
    final int? flAttShiftStatus;
    final DateTime? flAttDate;
    final int? ipdeWorkedMinutes;
    final String? empName;
    final int? flAttStatus;
    final int? ipdeId;
    final int? empId;
      
  @override
  List<Object?> get props => [flAttId,flAttShiftStatus,flAttDate,ipdeWorkedMinutes,empName,flAttStatus,ipdeId,empId];


}