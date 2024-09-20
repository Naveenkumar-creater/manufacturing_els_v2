
import 'package:prominous/features/domain/entity/edit_emp_list_entity.dart';


class EditListofEmpWorkstationModel extends EditListofEmpWorkstationEntity {
  const EditListofEmpWorkstationModel({
    required this.empWorkstation,
  }) : super(editEmplistEntity: empWorkstation);
  final List<EditEmpList> empWorkstation;

  factory EditListofEmpWorkstationModel.fromJson(Map<String, dynamic> json) {
    return EditListofEmpWorkstationModel(
      empWorkstation: json['response_data']['Edit_List_Of_Emp'] == null
          ? []
          : List<EditEmpList>.from(json['response_data']
                  ['Edit_List_Of_Emp']!
              .map((x) => EditEmpList.fromJson(x))),
    );
  }

  //   Map<String, dynamic> toJson() => {
  //     "List_Of_Employees": listOfEmployee.map((x) => x?.toJson()).toList(),
  // };
}

class EditEmpList extends EditEmpListEntity {
  const EditEmpList({

   required this.flAttId,
        required this.flAttShiftStatus,
        required this.flAttDate,
        required this.ipdeWorkedMinutes,
        required this.empName,
        required this.flAttStatus,
        required this.ipdeId,
        required this.empId,
      })
      : super(
        empId: empId,empName:empName ,flAttDate:flAttDate ,flAttId:flAttId ,flAttShiftStatus:flAttShiftStatus ,flAttStatus:flAttStatus ,ipdeId:ipdeId ,ipdeWorkedMinutes:ipdeWorkedMinutes 
           
            );
  final int? flAttId;
    final int? flAttShiftStatus;
    final DateTime? flAttDate;
    final int? ipdeWorkedMinutes;
    final String? empName;
    final int? flAttStatus;
    final int? ipdeId;
    final int? empId;

  factory EditEmpList.fromJson(Map<String, dynamic> json) {
    return EditEmpList(
      flAttId: json["fl_att_id"],
            flAttShiftStatus: json["fl_att_shift_status"],
            flAttDate: DateTime.tryParse(json["fl_att_date"] ?? ""),
            ipdeWorkedMinutes: json["ipde_worked_minutes"],
            empName: json["emp_name"],
            flAttStatus: json["fl_att_status"],
            ipdeId: json["ipde_id"],
            empId: json["emp_id"],
    );
  }

}


       