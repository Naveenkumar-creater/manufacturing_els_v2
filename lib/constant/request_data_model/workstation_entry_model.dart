class WorkStationEntryReqModel {
  WorkStationEntryReqModel({
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
    required this.ipdreworkableqty,
    required this.listOfEmployeesForWorkStation,
    required this.pwsid
  });
  final String? apiFor;
  final String? clientAuthToken;
  final int? ipdMpmId;
  final String? ipdToTime;
  final int? ipdReworkFlag;
  final int? ipdAssetId;
  final int? ipdCardNo;
  final double? ipdRejQty;
  final int? ipdDeptId;
  final String? ipdDate;
  final double? ipdGoodQty;
  final int? ipdItemId;
  final int? ipdId;
  final String? ipdFromTime;
  final int? ipdPcId;
  final int? ipdpaid;
  final double? targetqty;
  final int? ipdpsid;
  final int? ppid;
  final int? shiftid;
  final double? ipdreworkableqty;
  final int?pwsid;

  final List<ListOfEmployeesForWorkStation> listOfEmployeesForWorkStation;

  Map<String, dynamic> toJson() => {
        'client_aut_token': clientAuthToken,
        'api_for': apiFor,
        "ipd_mpm_id": ipdMpmId,
        "ipd_to_time": ipdToTime,
        "ipd_rework_flag": ipdReworkFlag,
        "ipd_asset_id": ipdAssetId,
        "ipd_card_no": ipdCardNo,
        "ipd_pc_id": ipdPcId,
        "ipd_rej_qty": ipdRejQty,
        "ipd_dept_id": ipdDeptId,
        "ipd_date": ipdDate,
        "ipd_good_qty": ipdGoodQty,
        "ipd_item_id": ipdItemId,
        "ipd_id": ipdId,
        "ipd_from_time": ipdFromTime,
        'ipd_pa_id': ipdpaid,
        "ipd_ps_id": ipdpsid,
        "pp_plan_qty": targetqty,
        "pp_id": ppid,
        "pp_shift_id": shiftid,
        "ipd_pws_id":pwsid,
        "ipd_reworkable_qty": ipdreworkableqty,
        "List_Of_Employees_For_WorkStation": listOfEmployeesForWorkStation
            .map((listOfEmployeesForWorkStation) =>
                listOfEmployeesForWorkStation?.toJson())
            .toList(),
      };
}

class ListOfEmployeesForWorkStation {
  ListOfEmployeesForWorkStation({
    required this.empId,
  });

  final int? empId;

  Map<String, dynamic> toJson() => {
        "emp_id": empId,
      };
}



