class EmpCloseShift{

  final String? clientAuthToken;
  final String? apiFor;
  final int ?attid;
  final int ?attShiftStatus;
  final int? psid;
  final int? attendenceStatus;
  EmpCloseShift( {required this.attendenceStatus, required this.psid, required this.clientAuthToken, required this.apiFor, required this.attid, required this.attShiftStatus});

  
  Map<String, dynamic> toJson() => {
  'client_aut_token':clientAuthToken,
      'api_for': apiFor,
      "fl_att_id":attid,
      "fl_att_shift_status":attShiftStatus,
      "fl_ps_id":psid,
      "fl_att_status":attendenceStatus
  };

}


// {
//      'client_aut_token': "",
//       'api_for': "emp_close_shif",
//       "fl_att_id":1,
//       "fl_att_shift_status":1,
//       "fl_ps_id":1
// }
