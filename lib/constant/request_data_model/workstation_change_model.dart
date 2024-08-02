class WorkstationChanges {
    WorkstationChanges({
        required this.clientAutToken,
        required this.apiFor,
        required this.pwseempid,
        required this.pwsePwsId,
        required this.pwseId,
        required this.attid,
        // required this.flattstatus
    });

    final String? clientAutToken;
    final String? apiFor;
    final int? pwseempid;
    final int? pwsePwsId;
    final int? pwseId;
    final int? attid;
    // final int? flattstatus;

    Map<String, dynamic> toJson() => {
        "client_aut_token": clientAutToken,
        "api_for": apiFor,
        "pwse_emp_id": pwseempid,
        "pwse_pws_id": pwsePwsId,
        "pwse_id": pwseId,
        "fl_att_id":attid,
        // "fl_att_status":flattstatus
    };

}


