class CloseShift{

  final String? clientAuthToken;
  final String? apiFor;
  final int ?ShiftStatus;
  final int? psid;
  CloseShift({ required this.psid, required this.clientAuthToken, required this.apiFor, required this.ShiftStatus});

  
  Map<String, dynamic> toJson() => {
  'client_aut_token':clientAuthToken,
      'api_for': apiFor,
      "ps_shift_status":ShiftStatus,
      "ps_id":psid
  };

}