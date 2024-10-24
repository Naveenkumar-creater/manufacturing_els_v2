class DeleteProductionEntryModel {
  final String? clientAuthToken;
  final String? apiFor;
  final int? ipdid;
  final int? ipdpsid;
   final int?pcid;
   final String?cardno;
   final int? processid;
   final int?paid;
  DeleteProductionEntryModel(
      {required this.clientAuthToken,
      required this.apiFor,
      required this.ipdid,
      required this.ipdpsid,
      required this.pcid,required this.cardno,required this.processid,required this.paid, });
  Map<String, dynamic> toJson() => {
        'client_aut_token': clientAuthToken,
        'api_for': apiFor,
        "ipd_id": ipdid,
        "ipd_ps_id": ipdpsid,
        "ipd_pc_id":pcid,
        "ipd_card_no":cardno,
        "ipd_mpm_id":processid,
        "ipd_pa_id":paid
      };
}



