class WorkstationCloseShiftModel {
    WorkstationCloseShiftModel({
        required this.clientAutToken,
        required this.apiFor,
        required this.mpmId,
        required this.psId,
        required this.pwsId,
    });

    final String? clientAutToken;
    final String? apiFor;
    final int? mpmId;
    final int? psId;
    final int? pwsId;

    factory WorkstationCloseShiftModel.fromJson(Map<String, dynamic> json){ 
        return WorkstationCloseShiftModel(
            clientAutToken: json["client_aut_token"],
            apiFor: json["api_for"],
            mpmId: json["mpm_id"],
            psId: json["ps_id"],
            pwsId: json["pws_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "client_aut_token": clientAutToken,
        "api_for": apiFor,
        "mpm_id": mpmId,
        "ps_id": psId,
        "pws_id": pwsId,
    };

}
