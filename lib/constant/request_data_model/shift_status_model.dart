 class ShiftStatusreqModel {
    ShiftStatusreqModel({
      required this.apiFor,
      required this.clientAuthToken,
      required this.deptId,
      required this.psid,
      required this.processId,
      required this.shiftgroupId
      // required this.shiftDate,

    });
  final String? apiFor;
  final String?clientAuthToken;
  final int? deptId;
  final int? processId;
  final int ? psid;
  final int? shiftgroupId;
  // final String?shiftDate;



    Map<String, dynamic> toJson() => {
      'client_aut_token': clientAuthToken,
      'api_for': apiFor,
      'ps_dept_id':deptId,
      'ps_id':psid,
      'ps_mpm_id':processId,
      'ps_sg_id':shiftgroupId
      // 'ps_shift_date':shiftDate  
    };

}


