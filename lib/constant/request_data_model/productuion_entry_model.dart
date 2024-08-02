class ProductionEntryReqModel {
    ProductionEntryReqModel( {
      required this.apiFor,
      required this.clientAuthToken,
        required this.ipdMpmId,
        required this.ipdToTime,
        required this.ipdReworkFlag,
        required this.ipdAssetId,
        required this.ipdCardNo,
        required this.ipdRejQty,
        required this.ipdDeptId,
        required this.ipdDate,
        required this.ipdGoodQty,
        required this.ipdItemId,
        required this.ipdId,
        required this.ipdFromTime,
        required this.ipdPcId,
        // required this.mpmBatchProcess,
        // required this.emppersonId,
        required this.ipdpaid,
        required this.targetqty,
        // required this.batchno,
        required this.ipdpsid,
        required this.ppid,
         required this.shiftid,
         required this.ipdreworkableqty

    });
      final String? apiFor;
  final String?clientAuthToken;
    final int? ipdMpmId;
    final String? ipdToTime;
    final int? ipdReworkFlag;
    final int? ipdAssetId;
    final int? ipdCardNo;
    final int? ipdRejQty;
    final int? ipdDeptId;
    final String? ipdDate;
    final int? ipdGoodQty;
    final int? ipdItemId;
    final int? ipdId;
    final String? ipdFromTime;
    final int? ipdPcId;
    // final int? mpmBatchProcess;
    // final int? emppersonId;
    final int?  ipdpaid;
    final int?targetqty;
    // final int?batchno;
    final int? ipdpsid;
    final int? ppid;
    final int? shiftid;
    final int? ipdreworkableqty;
    // factory ProductionEntryReqModel.fromJson(Map<String, dynamic> json){ 
    //     return ProductionEntryReqModel(
    //         ipdMpmId: json["ipd_mpm_id"],
    //         ipdToTime: json["ipd_to_time"],
    //         ipdReworkFlag: json["ipd_rework_flag"],
    //         ipdAssetId: json["ipd_asset_id"],
    //         ipdCardNo: json["ipd_card_no"],
    //         ipdRejQty: json["ipd_rej_qty"],
    //         ipdDeptId: json["ipd_dept_id"],
    //         ipdDate: json["ipd_date"],
    //         ipdGoodQty: json["ipd_good_qty"],
    //         ipdItemId: json["ipd_item_id"],
    //         ipdId: json["ipd_id"],
    //         ipdFromTime: json["ipd_from_time"],
    //         ipdPcId: json["ipd_pc_id"],
    //         mpmBatchProcess: json["mpm_batch_process"],
    //         personId: json["person_id"],
    //     );
    // }

    Map<String, dynamic> toJson() => {
      'client_aut_token': clientAuthToken,
      'api_for': apiFor,
        "ipd_mpm_id": ipdMpmId,
        "ipd_to_time": ipdToTime,
        "ipd_rework_flag": ipdReworkFlag,
        "ipd_asset_id": ipdAssetId,
        "ipd_card_no": ipdCardNo,
        "ipd_pc_id":ipdPcId,
        "ipd_rej_qty": ipdRejQty,
        "ipd_dept_id": ipdDeptId,
        "ipd_date": ipdDate,
        "ipd_good_qty": ipdGoodQty,
        "ipd_item_id": ipdItemId,
        "ipd_id": ipdId,
        "ipd_from_time": ipdFromTime,
        // "emp_personid": emppersonId,
          'ipd_pa_id':  ipdpaid,
          "ipd_ps_id":ipdpsid,
          "pp_plan_qty":targetqty,
          // "ipd_batch_no":batchno,
          "pp_id":ppid,
          "pp_shift_id": shiftid,

          "ipd_reworkable_qty":ipdreworkableqty

    };

}


  // {
  //     'client_aut_token': "",
  //     'api_for': "edit_entry_v1",
  //       "ipd_mpm_id": 1,
  //       "ipd_to_time": "",
  //       "ipd_rework_flag": 1,
  //       "ipd_asset_id": 40,
  //       "ipd_card_no": 1001,
  //       "ipd_pc_id":1,
  //       "ipd_rej_qty": 50,
  //       "ipd_dept_id": 1057,
  //       "ipd_date": "",
  //       "ipd_good_qty": 50,
  //       "ipd_item_id": 57,
  //       "ipd_id": 2,
  //       "ipd_from_time": "",
  //         'ipd_pa_id':  1,
  //         "ipd_ps_id":120,
  //         "pp_plan_qty":500,
  //         "pp_id":1,
  //         "pp_shift_id": 1,

  //         "ipd_reworkable_qty":20

  //   };