// class EditWorkstationEntryModel {
//     EditWorkstationEntryModel( 
//       {required this.apiFor,
//       required this.clientAuthToken,
//       required this.ipdMpmId,
//       required this.ipdToTime,
//       required this.ipdReworkFlag,
//       required this.ipdAssetId,
//       required this.ipdCardNo,
//       required this.ipdRejQty,
//       required this.ipdDeptId,
//       required this.ipdDate,
//       required this.ipdGoodQty,
//       required this.ipdItemId,
//       required this.ipdId,
//       required this.ipdFromTime,
//       required this.ipdPcId,
//       // required this.mpmBatchProcess,
//       // required this.emppersonId,
//       required this.ipdpaid,
//       required this.targetqty,
//       // required this.batchno,
//       required this.ipdpsid,
//       required this.ppid,
//       required this.shiftid,
//       required this.ipdreworkableqty,
//       required this.listOfEmployeesForWorkStation,
//       required this.pwsid,
//       required this.listOfWorkstationIncident,
//       required this.nonProductionList
      
//       });
//   final String? apiFor;
//   final String? clientAuthToken;
//   final int? ipdMpmId;
//   final String? ipdToTime;
//   final int? ipdReworkFlag;
//   final int? ipdAssetId;
//   final int? ipdCardNo;
//   final double? ipdRejQty;
//   final int? ipdDeptId;
//   final String? ipdDate;
//   final double? ipdGoodQty;
//   final int? ipdItemId;
//   final int? ipdId;
//   final String? ipdFromTime;
//   final int? ipdPcId;
//   final int? ipdpaid;
//   final double? targetqty;
//   final int? ipdpsid;
//   final int? ppid;
//   final int? shiftid;
//   final double? ipdreworkableqty;
//   final int? pwsid;

//   final List<EditListOfEmployeesForWorkStation> listOfEmployeesForWorkStation;
//   final List<EditListOfWorkStationIncidents> listOfWorkstationIncident;
//   final List<NonProductionList>nonProductionList;

//   Map<String, dynamic> toJson() => {
//         'client_aut_token': clientAuthToken,
//         'api_for': apiFor,
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
//         "ipd_pws_id": pwsid,
//         "ipd_reworkable_qty": ipdreworkableqty,
//         "List_Of_Employees_For_WorkStation": listOfEmployeesForWorkStation
//             .map((listOfEmployeesForWorkStation) =>
//                 listOfEmployeesForWorkStation?.toJson())
//             .toList(),
            
//         "List_Of_WorkStation_incident": listOfWorkstationIncident
//             .map((listOfWorkstationIncident) =>
//                 listOfWorkstationIncident.toJson())
//             .toList(),
      
//       "Non_Production_Activity":nonProductionList
//             .map((nonProductionList) =>
//                 nonProductionList.toJson())
//             .toList()
//       };
// }

// class EditListOfEmployeesForWorkStation {
//   EditListOfEmployeesForWorkStation({
//     required this.empId,
//     required this.timing,
//     required this.ipdeId
//   });

//   final int? empId;
//   final int? timing;
//   final int?ipdeId;

//   Map<String, dynamic> toJson() => {
//         "emp_id": empId,
//         "emp_timing":timing,
//         "ipde_id":ipdeId
//       };
// }

// class EditListOfWorkStationIncidents {
//   EditListOfWorkStationIncidents(
//       {
//         required this.incfromtime,required this.incendtime,required this.solutionId,required this.problemStatusId,required this.productionstopageId, 
        
//         required this.incidenid,
//       required this.subincidentid,
//       required this.rootcauseid,
//       required this.notes});

//   final int? incidenid;
//   final int? subincidentid;
//   final int? rootcauseid;
//   final String? notes;
//   final String?incfromtime;
//   final String? incendtime;
//   final int?solutionId;
//   final int?problemStatusId;
//   final int? productionstopageId;

//   Map<String, dynamic> toJson() => {
//        "inc_from_time": incfromtime,
//         "inc_to_time": incendtime,
//         "incident_id": incidenid,
//         "subincidentid": subincidentid,
//         "rootcauseid": rootcauseid,
//         "solution_id":solutionId,
//         "problem_solved_status":problemStatusId,
//         "production_stopage": productionstopageId,
//         "notes": notes
//       };
// }

// class NonProductionList {
//   NonProductionList(
//  {required this.notes, required this.fromTime,required this.npamId, required this.toTime});

//   final int? npamId;
//   final String? fromTime;
//   final String? toTime;
//   final String? notes;

//   Map<String, dynamic> toJson() => {
//         "npam_id": npamId,
//         "from_time": fromTime,
//         "to_time": toTime,
//         "notes": notes
//       };
// }



//   // {
//   //     'client_aut_token': "",
//   //     'api_for': "edit_entry_v1",
//   //       "ipd_mpm_id": 1,
//   //       "ipd_to_time": "",
  
//   //       "ipd_rework_flag": 1,
//   //       "ipd_asset_id": 40,
//   //       "ipd_card_no": 1001,
//   //       "ipd_pc_id":1,
//   //       "ipd_rej_qty": 50,
//   //       "ipd_dept_id": 1057,
//   //       "ipd_date": "",
//   //       "ipd_good_qty": 50,
//   //       "ipd_item_id": 57,
//   //       "ipd_id": 2,
//   //       "ipd_from_time": "",
//   //         'ipd_pa_id':  1,
//   //         "ipd_ps_id":120,
//   //         "pp_plan_qty":500,
//   //         "pp_id":1,
//   //         "pp_shift_id": 1,
//   //         "ipd_reworkable_qty":20


//   //         "List_Of_Employees_For_WorkStation":[
//   //         {
//   //                 "emp_id": empId,
//   //                 "emp_timing":0
//   //       },
//   //       ],
//   //        "List_Of_WorkStation_incident":[
//   //         {
//   //       "incident_id": incidenid,
//   //       "subincident_id": subincidentid,
//   //       "rootcause_id": rootcauseid,
//   //       "notes": notes
//   //         }
//   //        ],
//   //       "Non_Production_Activity":[
//   //         {
//   //       "npac_id": 1,
//   //       "from_time": "",
//   //       "to_time": "",
//   //       "notes": ""
//   //         }
//   //        ]

//   //   }