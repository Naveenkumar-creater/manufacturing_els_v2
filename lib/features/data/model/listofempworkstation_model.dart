import 'package:prominous/features/domain/entity/employee_entity.dart';
import 'package:prominous/features/domain/entity/listofempworkstation_entity.dart';

class ListofEmpWorkstationModel extends ListofEmpWorkstationEntity {
  const ListofEmpWorkstationModel({
    required this.empWorkstation,
  }) : super(empWorkstationEntity: empWorkstation);
  final List<EmpWorkstation> empWorkstation;

  factory ListofEmpWorkstationModel.fromJson(Map<String, dynamic> json) {
    return ListofEmpWorkstationModel(
      empWorkstation: json['response_data']['List_Of_Employees_For_WorkStation'] == null
          ? []
          : List<EmpWorkstation>.from(json['response_data']
                  ['List_Of_Employees_For_WorkStation']!
              .map((x) => EmpWorkstation.fromJson(x))),
    );
  }

  //   Map<String, dynamic> toJson() => {
  //     "List_Of_Employees": listOfEmployee.map((x) => x?.toJson()).toList(),
  // };
}

class EmpWorkstation extends EmpWorkstationEntity {
  const EmpWorkstation(
      {required this.empPersonid,
      required this.processId,
      required this.personFname,
      required this.timing,
      required this.emp_mgr,
      required this.attendanceid,
      // required this.productId,
      required this.productQty,
      // required this.productName,
      required this.flattdate,
      required this.mfgpempid,
      required this.flattstatus,
      required this.processName,
      required this.flattshiftstatus,
      // required this.shiftId,
      // required this.shitStatus,
      required this.itemId,
      required this.flpsid,
      required this.pwsId,
      // required this.pwsStaffRequired,
      required this.pwsName
      //required this.attendance,
      })
      : super(
            empPersonid: empPersonid,
            processId: processId,
            personFname: personFname,
            timing: timing,
            emp_mgr: emp_mgr,
            // productId: productId,
            // productQty: productQty,
            // productName: productName,
            attendanceid: attendanceid,
            flattdate: flattdate,
            mfgpempid: mfgpempid,
            flattstatus: flattstatus,
            processName: processName,
            productQty: productQty,
            // shifId:shiftId,
            itemId: itemId,
            flattshiftstatus: flattshiftstatus,
            flpsid: flpsid,
            pwsId: pwsId,
            // pwsStaffRequired: pwsStaffRequired,
            pwsName:pwsName
            // shitStatus:shitStatus
            //attendance: attendance);
            );
  final int? empPersonid;
  final int? processId;
  final String? personFname;
  final String? timing;
  final int? emp_mgr;
  //final int? productId;
  final int? productQty;

  // final String? productName;
  //final int? attendance;
  final String? attendanceid;
  final String? flattdate;
  final int? mfgpempid;
  final int? flattstatus;
  final int? flattshiftstatus;
  final String? processName;
  // final int? shitStatus;
  // final int? shiftId;
  final String? itemId;
  final int? flpsid;
  final int? pwsId;
  // final int? pwsStaffRequired;
  final String? pwsName;

  factory EmpWorkstation.fromJson(Map<String, dynamic> json) {
    return EmpWorkstation(
      empPersonid: json["emp_id"],
      emp_mgr: json["emp_mgr"],
      processId: json["mfgpe_mpm_id"],
      personFname: json["emp_name"],
      timing: json["ipd_to_time"],
      //productId: json["product_id"],
      productQty: json["production_qty"],
      // productName: json["item_name"],
      //  attendance: json["fl_att_status"],
      attendanceid: json['fl_att_id'],
      mfgpempid: json["mfgpe_id"],
      flattdate: json["fl_att_in_time"],
      flattstatus: json["fl_att_status"],
      flattshiftstatus: json["fl_att_shift_status"],
      flpsid: json["fl_ps_id"],

      processName: json["mpm_name"],
      // shitStatus: json["fl_att_shift_status"],
      // shiftId: json["fl_att_shift_id"],
      itemId: json["ipd_item_id"],

      pwsId: json["pws_id"],
      // pwsStaffRequired: json["pws_staff_required"],

      pwsName:json["pws_name"]
    );
  }




  Map<String, dynamic> toJson() => {
        "mfgp_mpm_id": processId,
        "emp_name": personFname,
        // "item_name": "moulding",
        // "emp_desig": "Factory Worker",
        "emp_id": empPersonid,
        "emp_mgr": emp_mgr,
        // "emp_personid": empPersonid,
        "fl_att_id": attendanceid,
        // "person_fname": personFname,
        "ipd_to_time": timing,
        //  "productId":productId,
        //  "productQty":productQty,
        // "item_name": productName,
        "mpm_name": processName,
        //"fl_att_status": attendance,
        "fl_att_date": flattdate,
        "mfgp_emp_id": mfgpempid,
        "fl_att_status": flattstatus,
      };
}


       