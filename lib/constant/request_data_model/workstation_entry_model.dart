class WorkStationEntryReqModel {
  WorkStationEntryReqModel( 
      {required this.apiFor,
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
      required this.pwsid,
      required this.listOfWorkstationIncident,
      required this.nonProductionList,
      required this.ipdareaid
      
      });
  final String? apiFor;
  final String? clientAuthToken;
  final int? ipdMpmId;
  final String? ipdToTime;
  final int? ipdReworkFlag;
  final int? ipdAssetId;
  final String? ipdCardNo;
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
  final int? pwsid;
  final int?ipdareaid;

  final List<ListOfEmployeesForWorkStation> listOfEmployeesForWorkStation;
  final List<ListOfWorkStationIncidents> listOfWorkstationIncident;
  final List<NonProductionList>nonProductionList;

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
        "ipd_pws_id": pwsid,
        "ipd_reworkable_qty": ipdreworkableqty,
        "ipd_area_id":ipdareaid,
        "List_Of_Employees_For_WorkStation": listOfEmployeesForWorkStation
            .map((listOfEmployeesForWorkStation) =>
                listOfEmployeesForWorkStation?.toJson())
            .toList(),
            
        "List_Of_WorkStation_incident": listOfWorkstationIncident
            .map((listOfWorkstationIncident) =>
                listOfWorkstationIncident.toJson())
            .toList(),
      
      "Non_Production_Activity":nonProductionList
            .map((nonProductionList) =>
                nonProductionList.toJson())
            .toList()
      };
}

class ListOfEmployeesForWorkStation {
  ListOfEmployeesForWorkStation({
    required this.empId,
    required this.timing,
    required this.ipdeId
  });

  final int? empId;
  final int? timing;
  final int?ipdeId;

  Map<String, dynamic> toJson() => {
        "emp_id": empId,
        "emp_timing":timing,
        "ipde_id":ipdeId
      };
}

class ListOfWorkStationIncidents {
  ListOfWorkStationIncidents(
      {
        required this.incfromtime,
        required this.incendtime,
        required this.solutionId,
        required this.problemStatusId,
        required this.productionstopageId, 
        required this.incidenid,
      required this.subincidentid,
      required this.rootcauseid,
      required this.ipdIncId,
      required this.notes,
      required this.ipdId});

  final int? incidenid;
  final int? subincidentid;
  final int? rootcauseid;
  final String? notes;
  final String?incfromtime;
  final String? incendtime;
  final int?solutionId;
  final int?problemStatusId;
  final int? productionstopageId;
  final int?ipdIncId;
  final int?ipdId;

  Map<String, dynamic> toJson() => {
       "inc_from_time": incfromtime,
        "inc_to_time": incendtime,
        "incident_id": incidenid,
        "subincidentid": subincidentid,
        "rootcauseid": rootcauseid,
        "solution_id":solutionId,
        "problem_solved_status":problemStatusId,
        "production_stopage": productionstopageId,
        "ipdinc_id":ipdIncId,
        "ipdinc_ipd_id":ipdId,
        "notes": notes
      };
}

class NonProductionList {
  NonProductionList(
 {required this.notes, required this.fromTime,required this.npamId, required this.toTime});

  final int? npamId;
  final String? fromTime;
  final String? toTime;
  final String? notes;

  Map<String, dynamic> toJson() => {
        "npam_id": npamId,
        "from_time": fromTime,
        "to_time": toTime,
        "notes": notes
      };
}



// server workstation entry json formate
// {
//         'client_aut_token': clientAuthToken,
//         'api_for': "update_production_v1",
//         "ipd_mpm_id": ipdMpmId,
//         "ipd_to_time": ipdToTime,
//         "ipd_rework_flag": ipdReworkFlag,
//         "ipd_asset_id": ipdAssetId,
//         "ipd_card_no": ipdCardNo,
//         "ipd_pc_id": ipdPcId,
//         "ipd_rej_qty": ipdRejQty,
//         "ipd_dept_id": ipdDeptId,
//         "ipd_date": ipdDate,
//         "ipd_good_qty": ipdGoodQty,
//         "ipd_item_id": ipdItemId,
//         "ipd_id": ipdId,
//         "ipd_from_time": ipdFromTime,
//         'ipd_pa_id': ipdpaid,
//         "ipd_ps_id": ipdpsid,
//         "pp_plan_qty": targetqty,
//         "pp_id": ppid,
//         "pp_shift_id": shiftid,
//         "ipd_reworkable_qty": ipdreworkableqty,
//         "List_Of_Employees_For_WorkStation":[
//           {
//                   "emp_id": empId,
//                   "emp_timing":0
//                   "ipde_id":0
//         },
//         ],
//          "List_Of_WorkStation_incident":[
//           {
//         "inc_from_time": "",
//         "inc_to_time": "",
//         "incident_id": incidenid,
//         "subincident_id": subincidentid,
//         "rootcause_id": rootcauseid,
//         "solution_id":solution_id,
//         "problem_solved_status":problemSolvedId
//         "production_stopage":0
//         "notes": notes
//           }
//          ],
//         "Non_Production_Activity":[
//           {
//         "npam_id": 1,
//         "from_time": "",
//         "to_time": "",
//         "notes": ""
//           }
//          ]
       
        
//       }



    // {
    //     'client_aut_token': clientAuthToken,
    //     'api_for': "update_problem_v1",
    //     "ipdinc_id":0,
    //    "ipdinc_ipd_id":0
    //     "inc_from_time": "",
    //     "inc_end_time": "",
    //     "incident_id": incidenid,
    //     "subincident_id": subincidentid,
    //     "rootcause_id": rootcauseid,
    //     "solution_id":solution_id,
    //     "problem_solved_status":problemSolvedId
    //     "production_stopage":0
    //     "notes": notes
    //       }
        