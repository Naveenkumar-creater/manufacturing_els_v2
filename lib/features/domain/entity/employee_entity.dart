import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final List<ListofEmployeeEntity>? listofEmployeeEntity;

  const EmployeeEntity({this.listofEmployeeEntity});

  @override
  List<Object?> get props => [listofEmployeeEntity];
}

class ListofEmployeeEntity extends Equatable {
  const ListofEmployeeEntity( {
    required this.processName,
    required this.empPersonid,
    required this.processId,
    required this.personFname,
    // required this.timing,
    required this.emp_mgr,
    //required this.productId,
    // required this.productQty,
    // required this.productName,
    //required this.attendance,
    required this.attendanceid,
    required this.flattdate,
    required this.mfgpempid, 
    required this.flattstatus,
    required this.flattshiftstatus,
    // required this.shifId, 
    // required this.itemId,
    required this.flpsid,
    required this.pwsId, 
    // required this.pwsStaffRequired,
    required this.pwsName,
    required this.pwseid
    // required this.shitStatus,
  });

  final int? empPersonid;
  final int?  processId;
  final String? personFname;
  // final String? timing;
  final int? emp_mgr;
  final String ? attendanceid;
  //final int? productId;
  // final int ? productQty;
  // final String? productName;
  //final int? attendance;
  final String? flattdate;
  final int? mfgpempid;
  final int?  flattstatus;
  final String? processName;
  final int? flattshiftstatus;
    // final int?  shifId;
    // final int? shitStatus;
      // final String? itemId;
      final int?flpsid;
          final int? pwsId;
    //  final int? pwsStaffRequired;
     final String? pwsName;
     final int? pwseid;

      
  @override
  List<Object?> get props => [
        empPersonid,
        processId,
        personFname,
        // timing,
        emp_mgr,
        // itemId,
        flattshiftstatus,
        // productQty,
        // productName,
        attendanceid,
        flattdate,
        flattstatus,
        mfgpempid,
        flpsid,
        pwsName
      ];

  get index => null;

  // Method to update the employee ID
  ListofEmployeeEntity updateEmpPersonId(int newEmpPersonId) {
    return ListofEmployeeEntity(
      empPersonid: newEmpPersonId,
      processId: processId,
      personFname: personFname,
      // timing: timing,
      emp_mgr: emp_mgr,
      // productName: productName,
      attendanceid: attendanceid,
      flattdate: flattdate,
      mfgpempid: mfgpempid, flattstatus: flattstatus,
      processName: processName,
      // productQty:productQty,
         flattshiftstatus: flattshiftstatus,
      // itemId: itemId,
      flpsid:flpsid, pwsId: pwsId, 
      
      // pwsStaffRequired: pwsStaffRequired,
      pwsName:pwsName, pwseid: pwseid
    );
  }
}
