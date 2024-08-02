class DeleteProductionEntryModel {
  final String? clientAuthToken;
  final String? apiFor;
  final int? ipdid;
  final int? ipdpsid;

  DeleteProductionEntryModel(
      {required this.clientAuthToken,
      required this.apiFor,
      required this.ipdid,
      required this.ipdpsid});
  Map<String, dynamic> toJson() => {
        'client_aut_token': clientAuthToken,
        'api_for': apiFor,
        "ipd_id": ipdid,
        "ipd_ps_id": ipdpsid
      };
}

