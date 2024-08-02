class EmpProcessChange {
    EmpProcessChange({
        required this.clientAutToken,
        required this.apiFor,
        required this.mfgpeMpmId,
        required this.mfgpeId,
        required this.mfgpePersonId,
        required this.pwsePwsId,
        required this.flAttId,
    });

    final String? clientAutToken;
    final String? apiFor;
    final int? mfgpeMpmId;
    final int? mfgpeId;
    final int? mfgpePersonId;
    final int? pwsePwsId;
    final int? flAttId;

    Map<String, dynamic> toJson() => {
        "client_aut_token": clientAutToken,
        "api_for": apiFor,
        "mfgpe_mpm_id": mfgpeMpmId,
        "mfgpe_id": mfgpeId,
        "mfgpe_person_id": mfgpePersonId,
        "pwse_pws_id": pwsePwsId,
        "fl_att_id": flAttId,
    };

}


    