 class SendAttendencereqModel {
    SendAttendencereqModel( {
      required this.apiFor,
      required this.clientAuthToken,
      required this.deptId,
      required this.psid,
      required this.processId,
      required this.attId,
      required  this.attStatus,
      required this.empid, required this.shiftStatus, required this.shiftId,
      required this.pwsId
      // required this.shiftDate,

    });
  final String? apiFor;
  final String?clientAuthToken;
  final int? deptId;
  final int? processId;
  final int ? psid;
  final int? attId;
  final int? attStatus;
  final int?empid;
  final int?shiftStatus;
  final int?shiftId;
  final int?pwsId;
  // final String?shiftDate;



    Map<String, dynamic> toJson() => {
      'client_aut_token': clientAuthToken,
      'api_for': apiFor,
      "fl_att_id":attId,
      'fl_att_status':attStatus,
      'fl_att_ps_id':psid,
      'fl_att_mpm_id':processId,
      'fl_att_emp_id':empid,
      "fl_att_shift_status":shiftStatus,
      "fl_att_shift_id":shiftId,
      "fl_att_pws_id":pwsId
      // 'ps_shift_date':shiftDate  
    };

}



