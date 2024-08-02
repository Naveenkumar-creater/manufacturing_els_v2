class ApiRequestDataModel {
  String? clientAuthToken;
  String apiFor;
  String? loginId;
  String? loginPassword;
  String? assetbarcode;
  String? clGroup;
  int? processId;
  int? statuscount;
  int? assetid;
  int? planId;
  int? acrdId;
  String? fromDateTime;
  String? toDateTime;
  String? clientId;
  String? personId;
  int? acrpInspectionStatus;
  int? timeStatus;
  int? machineStaus;
  int? datapoinPlanid;
  int? emppersonid;
  int? goodQuantities;
  int? rejectedQuantities;
  int? reworkQuantities;
  int? attstatus;
  String? attdate;
  String? attintime;
  int? attid;
  int? ipdid;
  String? ipdtotime;
  String? ipdfromtime;
  String? ipddate;
  int? ipdpcid;
  int? deptId;
  int? ipdassetid;
  int? ipdcardno;
  int? ipditemid;
  int? ipdmpmid;
  int? ipdempid;
  int? mfgPmpmId;
  int? mfgpEmpId;
  int? mfgPersonId;
  int? emp_mgr;
  int?ipdpaid;
 int?cardNo;
 int? paId;
 int? shiftId;
 int? psId;
 int ? itemId;
 int ? pwsid;
 String ? pwsBarcode;
 int?ipdpwsid;

    	int?	pwsspwsid;

    



  ApiRequestDataModel(
      {this.clientAuthToken,
      required this.apiFor,
      this.datapoinPlanid,
      this.timeStatus,
      this.assetid,
      this.personId,
      this.planId,
      this.acrdId,
      this.loginId,
      this.loginPassword,
      this.clGroup,
      this.processId,
      this.statuscount,
      this.fromDateTime,
      this.toDateTime,
      this.clientId,
      this.assetbarcode,
      this.acrpInspectionStatus,
      this.machineStaus,
      this.emppersonid,
      this.goodQuantities,
      this.rejectedQuantities,
      this.reworkQuantities,
      this.attstatus,
      this.attintime,
      this.attdate,
      this.attid,
      this.ipdid,
      this.ipdtotime,
      this.ipdfromtime,
      this.ipddate,
      this.ipdpcid,
      this.deptId,
      this.ipdassetid,
      this.ipdcardno,
      this.ipditemid,
      this.ipdmpmid,
      this.ipdempid,
      this.mfgPmpmId,
      this.mfgpEmpId,
      this.mfgPersonId,
      this.emp_mgr,
      this.ipdpaid,
      this.cardNo,
      this.paId,
      this.shiftId,
      this.psId,
      this.itemId,
      this.pwsid,
       this.pwsBarcode,
       this.ipdpwsid,
       this.pwsspwsid
      });

  Map<String, dynamic> toJson() {
    return {
          

    
      'card_no':cardNo,
      'client_aut_token': clientAuthToken,
      'api_for': apiFor,
      "pwsa_asset_id": assetid,
      'login_id': loginId,
      'login_password': loginPassword,
      'cl_group': clGroup,
      'process_Id': processId,
      "status": statuscount,
      'from_date_time': fromDateTime,
      'to_date_time': toDateTime,
      'client_id': clientId,
      'asset_bar_code': assetbarcode,
      'plan_id': planId,
      'acrp_id': datapoinPlanid,
      'personId': personId,
      'acrd_id': acrdId,
      "item_Id":itemId,
      'acrp_inspection_status': acrpInspectionStatus,
      'emp_personid': emppersonid,
      'timer_status': timeStatus,
      "Machine_Status": machineStaus,
      "ipd_good_qty": goodQuantities,
      "ipd_rej_qty": rejectedQuantities,
      "ipd_rework_flag": reworkQuantities,
      "fl_att_status": attstatus,
      // "fl_att_emp_id": emppersonid,
      "fl_att_in_time": attintime != null ? attintime!.toString() : null,
      "fl_att_date": attdate != null ? attdate!.toString() : null,
      "fl_att_id": attid,
      "ipd_id": ipdid,
      "ipd_to_time": ipdtotime != null ? ipdtotime!.toString() : null,
      "ipd_from_time": ipdfromtime != null ? ipdfromtime!.toString() : null,
      "ipd_date": ipddate != null ? ipddate!.toString() : null,
      "ipd_pc_id": ipdpcid,
      "dept_Id": deptId,
      "ps_Id":psId,
      "ipd_asset_id": ipdassetid,
      "ipd_card_no": ipdcardno,
      "ipd_item_id": ipditemid,
      "ipd_mpm_id": ipdmpmid,
      "ipd_emp_id": ipdempid,
      "emp_mgr": emp_mgr,
      "mfgp_mpm_id": mfgPmpmId,
      "mfgp_emp_id": mfgpEmpId,
      "mfg_person_id": mfgPersonId,
      "ipd_pa_id":ipdpaid,
      "pa_Id":paId,
      "shift_id":shiftId,
      "pws_id":pwsid,
      "pws_barcode":pwsBarcode,
      "ipd_pws_id":ipdpwsid,
      		"pwss_pws_id":pwsspwsid,

    };
  }
}








