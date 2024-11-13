// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';
import 'package:prominous/constant/request_data_model/workstation_close_shift_model.dart';
import 'package:prominous/constant/request_data_model/workstation_entry_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/constant/utilities/exception_handle/show_deletepopup_error.dart';
import 'package:prominous/constant/utilities/exception_handle/show_save_error.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

import 'package:prominous/features/presentation_layer/api_services/Workstation_problem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/card_no_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofempworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_catagory_di.dart';

import 'package:prominous/features/presentation_layer/api_services/listofproblem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofrootcause_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/non_production_activity_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/problem_status_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_avilable_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_location_di.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_emp_production_timing.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_recentHistoryBottomSheet.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_stroed_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_avilable_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_location_provider.dart';
import 'package:prominous/features/presentation_layer/provider/scanforworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/workstation_problem_provider.dart';
import 'package:prominous/features/presentation_layer/widget/timing_widget/set_timing_widget.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/emp_close_shift_widget.dart';
import 'package:prominous/features/presentation_layer/widget/barcode_widget/workstation_barcode_Scanner.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/non_production_activity_popup.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/problem_entry_popup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/features/presentation_layer/api_services/activity_di.dart';
import 'package:prominous/features/presentation_layer/api_services/emp_production_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/recent_activity.dart';
import 'package:prominous/features/presentation_layer/api_services/target_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/activity_provider.dart';
import 'package:prominous/features/presentation_layer/provider/card_no_provider.dart';
import 'package:prominous/features/presentation_layer/provider/emp_production_entry_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_provider.dart';
import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/provider/target_qty_provider.dart';
import 'package:prominous/features/presentation_layer/widget/barcode_widget/asset_barcode_scanner.dart';
import 'package:prominous/features/presentation_layer/widget/barcode_widget/cardno_barcode_scanner.dart';
import '../../api_services/product_di.dart';
import 'package:intl/intl.dart';
import '../../../../constant/utilities/exception_handle/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../../../constant/utilities/customwidgets/customnum_field.dart';

class MobileEmpWorkstationProductionEntryPage extends StatefulWidget {
  final int? empid;
  final int? processid;
  final String? barcode;
  final int? cardno;
  final int? assetid;
  final int? deptid;
  bool? isload;
  final int? psid;
  final int? attendceStatus;
  final String? attenceid;
  final int? pwsid;
  final String? workstationName;

  MobileEmpWorkstationProductionEntryPage(
      {Key? key,
      this.empid,
      this.processid,
      this.barcode,
      this.cardno,
      this.assetid,
      this.isload,
      this.deptid,
      this.psid,
      this.attenceid,
      this.attendceStatus,
      this.pwsid,
      this.workstationName})
      : super(key: key);

  @override
  State<MobileEmpWorkstationProductionEntryPage> createState() =>
      _EmpProductionEntryPageState();
}

class _EmpProductionEntryPageState
    extends State<MobileEmpWorkstationProductionEntryPage> {
   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late ListProblemStoringProvider storedListOfProblem;
  late NonProductionStoredListProvider nonProductionList;
  final TextEditingController goodQController = TextEditingController();
  final TextEditingController rejectedQController = TextEditingController();
  final TextEditingController reworkQtyController = TextEditingController();
  final TextEditingController targetQtyController = TextEditingController();
  final TextEditingController batchNOController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController assetCotroller = TextEditingController();
  final TextEditingController incidentReasonController =
      TextEditingController();
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  final ActivityService activityService = ActivityService();
  ProductLocationService productLocationService = ProductLocationService();
  final Listofproblemservice listofproblemservice = Listofproblemservice();
  final ProblemStatusService problemStatusService = ProblemStatusService();
  final ListofRootCauseService listofRootCauseService = ListofRootCauseService();
  final ListofproblemCategoryservice listofproblemCategoryservice = ListofproblemCategoryservice();
  final TargetQtyApiService targetQtyApiService = TargetQtyApiService();
  final EmpProductionEntryService empProductionEntryService = EmpProductionEntryService();
  final ListofEmpworkstationService listofEmpworkstationService = ListofEmpworkstationService();
  final WorkstationProblemService workstationProblemService = WorkstationProblemService();
  final NonProductionActivityService nonProductionActivityService = NonProductionActivityService();
  ListofworkstationService listofworkstationService =  ListofworkstationService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
  List<Map<String, dynamic>> incidentList = [];
  ActualQtyService actualQtyService = ActualQtyService();
  final CardNoApiService cardNoApiService = CardNoApiService();
    final ScrollController _scrollController = ScrollController();

  ProductAvilableQtyService productAvilableQtyService =ProductAvilableQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  FocusNode goodQtyFocusNode = FocusNode();
  FocusNode rejectedQtyFocusNode = FocusNode();
  FocusNode reworkFocusNode = FocusNode();
  FocusNode cardNoFocusNode = FocusNode();
   FocusNode assetFocusNode = FocusNode();
  // Define the FocusNode for the Item Ref field
  final FocusNode itemRefFocusNode = FocusNode();
  bool isChecked = false;

  bool isLoading = true;
  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late String currentTime;
  late int currentSecond;
  bool visible = true;
  int? product_Id;
  String? workstationBarcode;

  TimeOfDay timeofDay = TimeOfDay.now();
  late DateTime currentDateTime;
  // Initialized to avoid null check
  String? selectedName;
  String? selectproblemname;
  String? selectproblemCategoryname;
  String? selectrootcausename;
  String? dropdownProduct;
  String? activityDropdown;
  String? locationDropdown;
  String? locationName;
  int? locationid;

  String? problemDropdown;
  int? problemid;
  String? problemCategoryDropdown;
  int? problemCategoryid;
  String? rootCauseDropdown;
  int? rootCauseid;
  List<ListOfIncidentCategoryEntity>? problemCategory;
  List<ListrootcauseEntity>? listofrootcause;

  String? lastUpdatedTime;
  String? fromtime;
  String? currentDate;
  int? reworkValue;
  int? productid;
  int? activityid;
  TimeOfDay? updateTimeManually;
  String? cardNo;
  String? productName;
  String? assetID;
  String? achivedTargetQty;
  List<TextEditingController> empTimingTextEditingControllers = [];
  final List<String?> errorMessages = [];

  EmployeeApiService employeeApiService = EmployeeApiService();
   GlobalKey _updateTimeKey = GlobalKey();

  int? fromMinutes;
  int? overallqty;
  int? avilableqty;
  int? seqNo;
  int? pcid;

  DateTime? shiftStartTime;
  DateTime? shiftEndtTime;

  int? previousGoodValue; // Variable to store the previous value entered for Good Quantity
  int? previousRejectedValue;
  int? previousReworkValue; // Total minutes// Variable to track the error message
  String? errorMessage;
  String? rejectederrorMessage;
  String? reworkerrorMessage;
  String? itemerrorMessage;

Future<void> updateproduction(int? processid) async {
    final responsedata =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    final ppId = Provider.of<TargetQtyProvider>(context, listen: false)
        .user
        ?.targetQty
        ?.ppid;
    final EmpWorkstation =
        Provider.of<ListofEmpworkstationProvider>(context, listen: false)
            .user
            ?.empWorkstationEntity;
    final StoredListOfProblem =
        Provider.of<ListProblemStoringProvider>(context, listen: false)
            .getIncidentList;

    final ListofNonProduction =
        Provider.of<NonProductionStoredListProvider>(context, listen: false)
            .getNonProductionList;
    // DateTime parsedLastUpdatedTime =
    //     DateFormat('yyyy-MM-dd HH:mm').parse(lastUpdatedTime!);
    final empproduction = responsedata;
    print(empproduction);
    if (empproduction != null) {
      // Check if empproduction is not empty
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString("client_token") ?? "";

      now = DateTime.now();
      currentYear = now.year;

      currentMonth = now.month;
      currentDay = now.day;
      currentHour = now.hour;
      currentMinute = now.minute;
      currentSecond = now.second;

      final currentDateTime =
          '$currentYear-${currentMonth.toString().padLeft(2, '0')}-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}';

      //String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      WorkStationEntryReqModel workStationEntryReq = WorkStationEntryReqModel(
          apiFor: "update_production_v1",
          clientAuthToken: token,
          ipdRejQty: double.tryParse(rejectedQController.text) ?? 0,
          ipdReworkFlag: reworkValue ?? empproduction.ipdflagid,
          ipdGoodQty: double.tryParse(goodQController.text) ?? 0,
          // batchno: int.tryParse(batchNOController.text),
          targetqty: double.tryParse(targetQtyController.text),
          ipdreworkableqty: double.tryParse(reworkQtyController.text),
          ipdCardNo: cardNoController.text.toString(),
          ipdpaid: activityid ?? 0,
          ipdFromTime: fromtime,
          ipdToTime: lastUpdatedTime ?? currentDateTime,
          ipdDate: currentDateTime.toString(),
          ipdId: 0,
          // activityid == empproduction.ipdpaid ? empproduction.ipdid : 0,
          ipdPcId: pcid ?? 0,
          ipdDeptId: widget.deptid ?? 1,
          ipdAssetId: int.tryParse(assetCotroller.text.toString()) ?? 0,
          //ipdcardno: empproduction.first.ipdcardno,
          ipdItemId: product_Id ?? empproduction.itemid,
          ipdMpmId: processid,
          // emppersonId: widget.empid ?? 0,
          ipdpsid: widget.psid,
          ppid: ppId ?? 0,
          shiftid: Shiftid,
          ipdareaid: locationid ?? 0,
          listOfEmployeesForWorkStation: [],
          pwsid: widget.pwsid,
          listOfWorkstationIncident: [],
          nonProductionList: []);

// // Clear the list to avoid duplicates
// workStationEntryReq.listOfEmployeesForWorkStation.clear();

// Loop through each EmpWorkstation entry
      for (int index = 0; index < EmpWorkstation!.length; index++) {
        final empid = EmpWorkstation[index];
        final emptimingController = empTimingTextEditingControllers[index];

        // Parse the timing from the TextEditingController's text
        final emptiming = int.tryParse(emptimingController.text) ?? 0;

        print(emptiming);

        // Create a ListOfEmployeesForWorkStation object with the timing
        final listofempworkstation = ListOfEmployeesForWorkStation(
          empId: empid.empPersonid ?? 0,
          timing: emptiming, ipdeId: 0, // Assign the parsed timing value
        );

        // Add the object to workStationEntryReq.listOfEmployeesForWorkStation
        workStationEntryReq.listOfEmployeesForWorkStation
            .add(listofempworkstation);
      }

      for (int index = 0; index < StoredListOfProblem.length; index++) {
        final incident = StoredListOfProblem[index];

        final lisofincident = ListOfWorkStationIncidents(
            incidenid: incident.problemId,
            notes: incident.reasons,
            rootcauseid: incident.rootCauseId,
            subincidentid: incident.problemCategoryId,
            incfromtime: incident.fromtime,
            incendtime: incident.endtime,
            problemStatusId: incident.problemstatusId,
            productionstopageId: incident.productionStoppageId ?? 0,
            solutionId: incident.solutionId, ipdIncId:incident.ipdIncId, ipdId: incident.ipdId );
             workStationEntryReq.listOfWorkstationIncident.add(lisofincident);
      }
      for (int index = 0; index < ListofNonProduction.length; index++) {
        final nonProduction = ListofNonProduction[index];

        final nonProductionList = NonProductionList(
            fromTime: nonProduction.npamFromTime,
            notes: nonProduction.notes,
            npamId: nonProduction.npamId,
            toTime: nonProduction.npamToTime);
        workStationEntryReq.nonProductionList.add(nonProductionList);
      }

      final requestBodyjson = jsonEncode(workStationEntryReq.toJson());

      print(requestBodyjson);

      const timeoutDuration = Duration(seconds: 30);
      try {
        http.Response response = await http
            .post(
              Uri.parse(ApiConstant.baseUrl),
              headers: {
                'Content-Type': 'application/json',
              },
              body: requestBodyjson,
            )
            .timeout(timeoutDuration);

        // ignore: avoid_print
        print(response.body);

        if (response.statusCode == 200) {
          try {
            final responseJson = jsonDecode(response.body);

            final responseMsg = responseJson["response_msg"];
            print(responseJson);

            if (responseMsg == "success") {
              return ShowSaveError.showAlert(
                  context, "Saved Successfully","Success","Success",Colors.green);
            } else {
              return ShowSaveError.showAlert(context, responseMsg);
            }
          } catch (e) {
            // Handle the case where the response body is not a valid JSON object
            ShowSaveError.showAlert(context, e.toString());
          }
        } else {
          throw ("Server responded with status code ${response.statusCode}");
        }
      } on TimeoutException {
        throw ('Connection timed out. Please check your internet connection.');
      } catch (e) {
        ShowError.showAlert(context, e.toString());
      }
      // Handle response if needed
    } else {
      // Handle case when empproduction is empty
      print("workstation entry is empty");
    }
  }



  void _openBottomSheet() {
    showModalBottomSheet(
      
      shape: RoundedRectangleBorder(
        
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0),
        
        ),
      
        
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => RecentHistoryBottomSheet(
          empid: widget.empid,
          processid: widget.processid,
          deptid: widget.deptid,
          isload: true,
          attenceid: widget.attenceid,
          attendceStatus: widget.attendceStatus,
          // shiftId: widget.shiftid,
          psid: widget.psid,
          pwsid: widget.pwsid,
          workstationName: widget.workstationName,
          
          ),
    );
  }

  void _closeShiftPop(BuildContext context, String attid, String attstatus) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: Column(children: [
                    const Text("Confirm you submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                               style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                            ),
                            onPressed: () async {
                              try {
                                await EmpClosesShift.empCloseShift(
                                    'emp_close_shift',
                                    widget.psid ?? 0,
                                    2,
                                    attid,
                                    int.tryParse(attstatus) ?? 0);

                                await _fetchARecentActivity();
                                await employeeApiService.employeeList(
                                    context: context,
                                    deptid: widget.deptid ?? 1,
                                    processid: widget.processid ?? 0,
                                    psid: widget.psid ?? 0);

                                Navigator.of(context).pop();
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            },
                            child:  Text("Submit",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child:  Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }

  void _EmpOpenShiftPop(BuildContext context, String attid, String attstatus) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: Column(children: [
                    const Text("Confirm you submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                            ),
                            onPressed: () async {
                              try {
                                await EmpClosesShift.empCloseShift(
                                    'emp_close_shift',
                                    widget.psid ?? 0,
                                    1,
                                    attid,
                                    int.tryParse(attstatus) ?? 0);
                                _fetchARecentActivity();
                                await employeeApiService.employeeList(
                                    context: context,
                                    deptid: widget.deptid ?? 1,
                                    processid: widget.processid ?? 0,
                                    psid: widget.psid ?? 0);
                                Navigator.of(context).pop();
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            },
                            child:  Text("Submit",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child:  Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }

  Future<void>_WorkStationcloseapi()async{
     try {
         await employeeApiService.employeeList(
                                    context: context,
                                    deptid: widget.deptid ?? 1,
                                    processid: widget.processid ?? 0,
                                    psid: widget.psid ?? 0);

                                await listofEmpworkstationService
                                    .getListofEmpWorkstation(
                                        context: context,
                                        deptid: widget.deptid ?? 1,
                                        psid: widget.psid ?? 0,
                                        processid: widget.processid ?? 0,
                                        pwsId: widget.pwsid ?? 0);

                                //           Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => ResponsiveTabletHomepage(),
                                // ));
                                await listofworkstationService
                                    .getListofWorkstation(
                                        context: context,
                                        deptid: widget.deptid ?? 1057,
                                        psid: widget.psid ?? 0,
                                        processid: widget.processid ?? 0);
                                await attendanceCountService.getAttCount(
                                    context: context,
                                    id: widget.processid ?? 0,
                                    deptid: widget.deptid ?? 1057,
                                    psid: widget.psid ?? 0);

                              await actualQtyService.getActualQty(
                          context: context,
                          id: widget.processid ?? 0,
                          psid: widget.psid ?? 0);

                      await planQtyService.getPlanQty(
                          context: context,
                          id: widget.processid ?? 0,
                          psid: widget.psid ?? 0);

                                         
       
     } catch (e) {
      isLoading=false;
       
     }
  }

  

  void _WorkStationcloseShiftPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: Column(children: [
                    const Text("Confirm you submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                          
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                            ),
                              
                            onPressed: () async {
                              try {
                                
                                Navigator.of(context).pop();
                        
                                await workstationClose(
                                    processid: widget.processid,
                                    psid: widget.psid,
                                    pwsid: widget.pwsid);
                                   
                                   _WorkStationcloseapi(); 
                              

                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            },
                            child: Text("Submit",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child:  Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }

  Future<void> workstationClose({int? processid, int? psid, int? pwsid}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final requestBody = WorkstationCloseShiftModel(
        apiFor: "workstation_close_shift_v1",
        clientAutToken: token,
        mpmId: processid,
        psId: psid,
        pwsId: pwsid);
    final requestBodyjson = jsonEncode(requestBody.toJson());

    print(requestBodyjson);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBodyjson,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
       try {
          final responseJson = jsonDecode(response.body);

          final responsemsg=responseJson["response_msg"];
          if(responsemsg=="success"){
           return ShowDeleteError.showAlert(context, "Workstation Closed successfully","Success","Success",Colors.green);
          }else{
 return ShowError.showAlert(context, "Workstation Not Closed","Error");
          }
       
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
           return ShowError.showAlert(context,e.toString(),"Error");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }

  

  void updateinitial() {
    if (widget.isload == true) {
      final productionEntry =
          Provider.of<EmpProductionEntryProvider>(context, listen: false)
              .user
              ?.empProductionEntity;
      final productname = Provider.of<ProductProvider>(context, listen: false)
          .user
          ?.listofProductEntity;

      setState(() {
        // assetCotroller.text = productionEntry?.ipdassetid?.toString() ?? "0";
        // cardNoController.text = productionEntry?.ipdcardno?.toString() ?? "0";
        // reworkQtyController.text =
        //     productionEntry?.ipdreworkableqty?.toString() ?? "0";
        // // If itemid is not 0, find the matching product name
        // productNameController.text = (productionEntry?.itemid != 0
        //     ? productname
        //         ?.firstWhere(
        //           (product) => productionEntry?.itemid == product.productid,
        //         )
        //         .productName
        //     : "0")!;
      });
    }
  }


  @override
  void initState() {
    super.initState();

    // Fetch recent activity, then initialize the values
    _fetchARecentActivity().then((_) {
      updateinitial();
    });

    itemRefFocusNode.addListener(() {
      if (!itemRefFocusNode.hasFocus) {
        validateProductName(); // Validate when focus is lost
      }
    });
    reworkValue ??= 0; // Set reworkValue to 0 if it's currently null
    // Get the current time details
    currentDateTime = DateTime.now();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;
    String? shiftTime;
    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

    String? shifttodate = productionEntry?.ipdtotime;

    final shiftFromtime =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftFromTime;

// Construct the shift start date with current time
    final shiftStartDateTiming = '${currentYear.toString().padLeft(4, '0')}-'
        '${currentMonth.toString().padLeft(2, '0')}-'
        '${currentDay.toString().padLeft(2, '0')} $shiftFromtime';

// Reassign the current fromtime value based on the condition
    fromtime = (productionEntry?.ipdfromtime?.isEmpty ?? true)
        ? shiftStartDateTiming
        : productionEntry?.ipdtotime;

// Retrieve shift details
    final shiftToTimeString =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftToTime;

       TimeOfDay shiftendTime = TimeOfDay(
    hour: int.parse(shiftToTimeString!.split(":")[0]),
    minute: int.parse(shiftToTimeString!.split(":")[1]),
  );

      DateTime? shiftToTime;
if (shifttodate != null && shifttodate.isNotEmpty) {
  DateTime parsedShiftToDate = DateTime.parse(shifttodate);

  // Create a DateTime object for the shift end time using the parsed date
  DateTime shiftEndDateTime = DateTime(
    parsedShiftToDate.year,
    parsedShiftToDate.month,
    parsedShiftToDate.day,
    shiftendTime.hour,
    shiftendTime.minute,
  );

  // Check if parsedShiftToDate is before the shift end time (08:00)
  if (parsedShiftToDate.isBefore(shiftEndDateTime)) {
    // Do not add a day, keep the same date
    shiftToTime = parsedShiftToDate;
  } else {
    // Add one day if the parsed date is after the shift end time
    shiftToTime = parsedShiftToDate.add(Duration(days: 1));
  }
} else {
  // Parse the shiftToTimeString if shifttodate is not provided
  final shiftToTimeParts = shiftToTimeString.split(':');
  final now = DateTime.now();
  shiftToTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(shiftToTimeParts[0]),
    int.parse(shiftToTimeParts[1]),
    int.parse(shiftToTimeParts[2]),
  );
}


      final shiftFromTimeString =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      DateTime? shiftFromTime;

      if (shiftFromTimeString != null && shiftToTime != null) {
        // Parse the shiftFromTime but using the same date as shiftToTime
        final shiftFromTimeParts = shiftFromTimeString.split(':');

        shiftFromTime = DateTime(
          shiftToTime.year, // Use the same year as shiftToTime
          shiftToTime.month, // Use the same month as shiftToTime
          shiftToTime.day, // Use the same day as shiftToTime
          int.parse(shiftFromTimeParts[0]),
          int.parse(shiftFromTimeParts[1]),
          int.parse(shiftFromTimeParts[2]),
          
        );

       
        if (shiftFromTime != null &&
            shiftToTime != null &&
            shiftToTime.isBefore(shiftFromTime)) {
          shiftToTime = shiftFromTime.add(Duration(days: 1));
        }

      
      //         if (shiftFromTime != null &&
      //       shiftToTime != null ){
      //       if((shiftToTime.day == DateTime.now().day &&
      //          shiftToTime.month == DateTime.now().month &&
      //          shiftToTime.year == DateTime.now().year &&
      //          shiftToTime.isAfter(shiftFromTime)) ){
      //        shiftToTime = shiftToTime;
      //          }
      //      else {
      //     shiftToTime = shiftToTime.add(Duration(days: 1));

      // }
      //       }
    }

    if (shiftFromTime != null && shiftToTime != null) {
      // No adjustment of shiftToTime date, keeping it as-is
      // if (currentTime.isAfter(shiftFromTime) &&
      //     currentTime.isBefore(shiftToTime)) {
      //   // Current time is within the shift time
      //   final timeString = '${currentTime.hour.toString().padLeft(2, '0')}:'
      //       '${currentTime.minute.toString().padLeft(2, '0')}:'
      //       '${currentTime.second.toString().padLeft(2, '0')}';
      //   shiftTime = timeString;
      // } else {
      // Current time is outside the shift time
      shiftTime = shiftToTimeString;

      if (shiftToTime != null) {
        setState(() {
          lastUpdatedTime = '${shiftToTime!.year.toString().padLeft(4, '0')}-'
              '${shiftToTime.month.toString().padLeft(2, '0')}-'
              '${shiftToTime.day.toString().padLeft(2, '0')} $shiftTime';

          print(lastUpdatedTime);
        });
      } else {
        print("Shift To time is not available.");
      }
    } else {
      print("Shift From or To time is not available.");
    }

    shiftStartTime = DateTime.parse(fromtime!);
    shiftEndtTime = DateTime.parse(lastUpdatedTime!);
  }


    void submitGoodQuantity() {
    final value = goodQController.text;
    final currentValue = int.tryParse(value) ?? 0;

    setState(() {

       if (currentValue == previousGoodValue) {
      errorMessage = null;
      return;
    }

    if (overallqty == 0) {
      // When overallqty is 0, the only valid input should be 0
      if (currentValue != 0) {
        errorMessage = 'Value must be 0';
      } else {
        errorMessage = null;
      }
    } else {
      // Validate the entered value against overallqty
      if (currentValue < 0) {
        errorMessage = 'Value must be greater than 0.';
      } else if (currentValue > (overallqty ?? 0)) {
        errorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        errorMessage = null;
        // Update overallqty and store the validated value
        overallqty = (overallqty ?? 0) - currentValue;
        previousGoodValue = currentValue;
      }
    }
    
    });
  }

 void submitRejectedQuantity() {
  final value = rejectedQController.text;
  final currentValue = int.tryParse(value) ?? 0;

  setState(() {
    // Skip validation if the value has not changed
    if (currentValue == previousRejectedValue) {
      rejectederrorMessage = null;
      return;
    }

    if (overallqty == 0) {
      // When overallqty is 0, the only valid input should be 0
      if (currentValue != 0) {
        rejectederrorMessage = 'Value must be 0';
      } else {
        rejectederrorMessage = null;
      }
    } else {
      // Validate the entered value against overallqty
      if (currentValue < 0) {
        rejectederrorMessage = 'Value must be greater than 0.';
      } else if (currentValue > (overallqty ?? 0)) {
        rejectederrorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        rejectederrorMessage = null;
        // Update overallqty and store the validated value
        overallqty = (overallqty ?? 0) - currentValue;
        previousRejectedValue = currentValue;
      }
    }
  });
}


  void submitReworkQuantity() {
    final value = reworkQtyController.text;
    final currentValue = int.tryParse(value) ?? 0;

    setState(() {
        if (currentValue == previousReworkValue) {
      reworkerrorMessage = null;
      return;
    }

    if (overallqty == 0) {
      // When overallqty is 0, the only valid input should be 0
      if (currentValue != 0) {
        reworkerrorMessage = 'Value must be 0';
      } else {
        reworkerrorMessage = null;
      }
    } else {
      // Validate the entered value against overallqty
      if (currentValue < 0) {
        reworkerrorMessage = 'Value must be greater than 0.';
      } else if (currentValue > (overallqty ?? 0)) {
        reworkerrorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        reworkerrorMessage = null;
        // Update overallqty and store the validated value
        overallqty = (overallqty ?? 0) - currentValue;
        previousReworkValue = currentValue;
      }
    }

    });
  }
    void validateProductName() {
    // Get the list of products
    final productList = Provider.of<ProductProvider>(context, listen: false)
            .user
            ?.listofProductEntity ??
        [];

    // Trim and convert entered product name to lowercase
    final enteredProductName = productNameController.text.trim().toLowerCase();

    // Check if the entered product name exists in the product list
    final isValidProduct = productList.any(
      (product) => product.productName?.toLowerCase() == enteredProductName,
    );

    if (!isValidProduct) {
      // Clear the input if the entered value is not valid
      productNameController.clear();

      // Show an error message to the user
      setState(() {
        itemerrorMessage = 'Please select a valid product';
      });
    } else {
      // Safely get the matching product using firstWhere with orElse
      final matchingProduct = productList.firstWhere(
        (product) => product.productName?.toLowerCase() == enteredProductName,
      );

      if (matchingProduct != null) {
        // Update the controller text and product ID
        productNameController.text = matchingProduct.productName!;
        product_Id = matchingProduct.productid;
        setState(() {
          itemerrorMessage = null; // Clear the error message if valid
        });
      }
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store the reference to the provider
  storedListOfProblem =
      Provider.of<ListProblemStoringProvider>(context, listen: false);

  nonProductionList =
      Provider.of<NonProductionStoredListProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Dispose text controllers
    targetQtyController.dispose();
    goodQController.dispose();
    rejectedQController.dispose();
    reworkQtyController.dispose();
    overallqty = null;
    cardNoController.dispose();
    _scrollController.dispose();

   for (var controller in empTimingTextEditingControllers) {
      controller.dispose();
    }

    nonProductionList.reset(notify: false);
    super.dispose();
  }



  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  // }

 Future<void> _fetchARecentActivity() async {
    try {
      // Fetch data
      await empProductionEntryService.productionentry(
          context: context,
          pwsId: widget.pwsid ?? 0,
          deptid: widget.deptid ?? 0,
          psid: widget.psid ?? 0);

      await listofEmpworkstationService.getListofEmpWorkstation(
          context: context,
          deptid: widget.deptid ?? 0,
          psid: widget.psid ?? 0,
          processid: widget.processid ?? 1,
          pwsId: widget.pwsid ?? 0);

      await workstationProblemService.getListofProblem(
          context: context, pwsid: widget.pwsid ?? 0);

      await productApiService.productList(
          context: context,
          id: widget.processid ?? 1,
          deptId: widget.deptid ?? 0);

      await recentActivityService.getRecentActivity(
          context: context,
          id: widget.pwsid ?? 0,
          deptid: widget.deptid ?? 0,
          psid: widget.psid ?? 0);

      await activityService.getActivity(
          context: context,
          id: widget.processid ?? 0,
          deptid: widget.deptid ?? 0,
          pwsId: widget.pwsid ?? 0);

      await productLocationService.getAreaList(context: context);

      currentDateTime = DateTime.now();
      now = DateTime.now();
      currentYear = now.year;
      currentMonth = now.month;
      currentDay = now.day;
      currentHour = now.hour;
      currentMinute = now.minute;
      currentSecond = now.second;

      String? shiftTime;

      final productionEntry = Provider.of<EmpProductionEntryProvider>(context, listen: false)
              .user
              ?.empProductionEntity;

      String? shifttodate = productionEntry?.ipdtotime;
      

      final shiftfromtime =  Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

// Construct the shift start date with current time
      final shiftStartDateTiming = '${currentYear.toString().padLeft(4, '0')}-'
          '${currentMonth.toString().padLeft(2, '0')}-'
          '${currentDay.toString().padLeft(2, '0')} $shiftfromtime';

// Reassign the current fromtime value based on the condition
      fromtime = (productionEntry?.ipdfromtime?.isEmpty ?? true)
          ? shiftStartDateTiming
          : productionEntry?.ipdtotime;



// Retrieve shift details
      final shiftToTimeString = Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftToTime;
              
       TimeOfDay shiftendTime = TimeOfDay(
    hour: int.parse(shiftToTimeString!.split(":")[0]),
    minute: int.parse(shiftToTimeString!.split(":")[1]),
  );

      DateTime? shiftToTime;
if (shifttodate != null && shifttodate.isNotEmpty) {
  DateTime parsedShiftToDate = DateTime.parse(shifttodate);

  // Create a DateTime object for the shift end time using the parsed date
  DateTime shiftEndDateTime = DateTime(
    parsedShiftToDate.year,
    parsedShiftToDate.month,
    parsedShiftToDate.day,
    shiftendTime.hour,
    shiftendTime.minute,
  );

  // Check if parsedShiftToDate is before the shift end time (08:00)
  if (parsedShiftToDate.isBefore(shiftEndDateTime)) {
    // Do not add a day, keep the same date
    shiftToTime = parsedShiftToDate;
  } else {
    // Add one day if the parsed date is after the shift end time
    shiftToTime = parsedShiftToDate.add(Duration(days: 1));
  }
} else {
  // Parse the shiftToTimeString if shifttodate is not provided
  final shiftToTimeParts = shiftToTimeString.split(':');
  final now = DateTime.now();
  shiftToTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(shiftToTimeParts[0]),
    int.parse(shiftToTimeParts[1]),
    int.parse(shiftToTimeParts[2]),
  );
}


      final shiftFromTimeString =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      DateTime? shiftFromTime;

      if (shiftFromTimeString != null && shiftToTime != null) {
        // Parse the shiftFromTime but using the same date as shiftToTime
        final shiftFromTimeParts = shiftFromTimeString.split(':');

        shiftFromTime = DateTime(
          shiftToTime.year, // Use the same year as shiftToTime
          shiftToTime.month, // Use the same month as shiftToTime
          shiftToTime.day, // Use the same day as shiftToTime
          int.parse(shiftFromTimeParts[0]),
          int.parse(shiftFromTimeParts[1]),
          int.parse(shiftFromTimeParts[2]),
          
        );

       
        if (shiftFromTime != null &&
            shiftToTime != null &&
            shiftToTime.isBefore(shiftFromTime)) {
          shiftToTime = shiftFromTime.add(Duration(days: 1));
        }

      

        // Adjust the date of shiftToTime if it falls on the next day
        //   if (shiftFromTime != null &&
        //       shiftToTime != null ){
        //       if((shiftToTime.day == DateTime.now().day &&
        //          shiftToTime.month == DateTime.now().month &&
        //          shiftToTime.year == DateTime.now().year &&
        //          shiftToTime.isAfter(shiftFromTime)) ){
        //        shiftToTime = shiftToTime;
        //          }
        //      else {
        //     shiftToTime = shiftToTime.add(Duration(days: 1));

        // }
        //       }
      }

      if (shiftFromTime != null && shiftToTime != null) {
        // No adjustment of shiftToTime date, keeping it as-is
        // if (currentTime.isAfter(shiftFromTime) &&
        //     currentTime.isBefore(shiftToTime)) {
        //   // Current time is within the shift time
        //   final timeString = '${currentTime.hour.toString().padLeft(2, '0')}:'
        //       '${currentTime.minute.toString().padLeft(2, '0')}:'
        //       '${currentTime.second.toString().padLeft(2, '0')}';
        //   shiftTime = timeString;
        // } else {
        //   // Current time is outside the shift time
        shiftTime = shiftToTimeString;

        if (shiftToTime != null) {
          setState(() {
            lastUpdatedTime = '${shiftToTime!.year.toString().padLeft(4, '0')}-'
                '${shiftToTime.month.toString().padLeft(2, '0')}-'
                '${shiftToTime.day.toString().padLeft(2, '0')} $shiftTime';

            print(lastUpdatedTime);
          });
        } else {
          print("Shift To time is not available.");
        }
      } else {
        print("Shift From or To time is not available.");
      }

      shiftStartTime = DateTime.parse(fromtime!);
      shiftEndtTime = DateTime.parse(lastUpdatedTime!);

      empTimingUpdation(fromtime!, lastUpdatedTime!);

      _storedWorkstationProblemList();

      DateTime StartfromTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromtime!);
      DateTime toTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastUpdatedTime!);

      fromMinutes = toTime.difference(StartfromTime).inMinutes;

      // Initialize controllers and error messages based on list length
    //   final listofempworkstation =
    //       Provider.of<ListofEmpworkstationProvider>(context, listen: false)
    //           .user
    //           ?.empWorkstationEntity;

    // if (listofempworkstation != null) {
    // for (int i = 0; i < listofempworkstation.length; i++) {
    //   empTimingTextEditingControllers.add(TextEditingController());
    //   errorMessages.add(null); // Initially no error
    // }
  // }

      // Access fetched data and set initial values
      final initialValue = productionEntry?.ipdflagid;

      if (initialValue != null) {
        setState(() {
          // isChecked = initialValue == 1;
          // goodQController.text = productionEntry?.goodqty?.toString() ?? "";
          // rejectedQController.text = productionEntry?.rejqty?.toString() ?? "";
          // batchNOController.text = productionEntry?.ipdbatchno.toString() ??
          ""; // Set isChecked based on initialValue
        });
      }

      setState(() {
        // Set initial values inside setState
        isLoading = false; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }


  void _submitPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: Column(children: [
                    const Text("Confirm you submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                             
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                            ),
                            onPressed: () async {
                              try {
                                if (dropdownProduct != null &&
                                        dropdownProduct != 'Select' &&
                                        goodQController.text.isNotEmpty ||
                                    rejectedQController.text.isNotEmpty ||
                                    reworkQtyController.text.isNotEmpty) {
                                 Navigator.of(context).pop();
                                  await updateproduction(widget.processid);
                                
                               _WorkStationcloseapi(); 

                                  
                                }
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.amber,
                                  ),
                                );
                              }
                            },
                            child:  Text("Submit",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }

  Future<void> _problemEntrywidget(
     String ? shiftFromTime,
      String ? shiftToTime,
     processid,deptid,assetid,
      [
      int? selectproblemid,
      int? problemCategoryId,
      int? rootcauseid,
      String? reason,
      int?solutionid,
      int? problemStatusId,
      int? productionStopageid,
      int?ipdId,
      int?ipdincId,
      bool? showButton,
      String? closeStartTime,
      int ? pwsid
     ]) async {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 800),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: Align(
              alignment: Alignment.centerRight, // Align the drawer to the right
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width *
                      0.75.w, // Set the width to half of the screen
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set the height to full screen height
                  child: ProblemEntryPopup(
                    SelectProblemId: selectproblemid,
                    problemCategoryId: problemCategoryId,
                    reason: reason,
                    rootcauseid: rootcauseid,
                    showButton: showButton,
                    shiftFromTime: shiftFromTime,
                    shiftToTime: shiftToTime,
                    problemStatusId:problemStatusId ,
                    solutionId: solutionid,
                    productionStopageId:productionStopageid,
                    ipdid: ipdId,
                    ipdincid:ipdincId ,
                  closestartTime: closeStartTime,
                  pwsId:pwsid, processid: processid,assetid:assetid ,deptid: deptid,

                  )),
            ),
          ),
        );
      },
    );
  }

//  void deletePop(BuildContext context, ipdid, ipdpsid) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: Colors.white,
//             child: WillPopScope(
//               onWillPop: () async {
//                 return false;
//               },
//               child: Container(
//                 width: 200,
//                 height: 150,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 32,
//                   ),
//                   child: Column(children: [
//                     const Text("Confirm you submission"),
//                     const SizedBox(
//                       height: 32,
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 await delete(
//                                     ipdid: ipdid ?? 0, ipdpsid: ipdpsid ?? 0);
//                                 await _fetchARecentActivity();
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                               } catch (error) {
//                                 // Handle and show the error message here
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(error.toString()),
//                                     backgroundColor: Colors.amber,
//                                   ),
//                                 );
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Go back")),
//                         ],
//                       ),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//           );
//         });
//   }


  Future<void> _nonProductionActivityPopup(
      String? shiftfromtime, String? shiftTotime) async {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 800),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
            child: Align(
              alignment: Alignment.centerRight, // Align the drawer to the right
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width *
                      0.75.w, // Set the width to half of the screen
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set the height to full screen height
                  child: NonProductionActivityPopup(
                      shiftFromTime: shiftfromtime, shiftToTime: shiftTotime)),
            ),
          ),
        );
      },
    );
  }

    void _storedWorkstationProblemList() {

  Provider.of<ListProblemStoringProvider>(context, listen: false).reset();
   final workstationProblem = Provider.of<WorkstationProblemProvider>(context, listen: false)
        .user
        ?.resolvedProblemInWs;
           
    if (workstationProblem != null) {
      for (int i = 0; i < workstationProblem.length; i++) {
         ListOfWorkStationIncident data =
                                          ListOfWorkStationIncident(
                                              fromtime: workstationProblem[i].fromTime,
                                              endtime: workstationProblem[i].endTime,
                                              productionStoppageId:
                                                  workstationProblem[i].productionStopageId,
                                              problemstatusId: workstationProblem[i].problemStatusId,
                                              problemsolvedName:
                                                  workstationProblem[i].problemStatus,
                                              solutionId: workstationProblem[i].solId,
                                              solutionName: workstationProblem[i].solDesc,
                                              problemCategoryname:
                                                 workstationProblem[i].subincidentName,
                                              problemId: workstationProblem[i].incidentId,
                                              problemName: workstationProblem[i].incidentName,
                                              problemCategoryId:
                                                  workstationProblem[i].subincidentId,
                                              reasons:
                                                  workstationProblem[i].ipdincNotes,
                                              rootCauseId: workstationProblem[i].ipdincIncrcmId,
                                              rootCausename:
                                                  workstationProblem[i].incrcmRootcauseBrief,
                                                  ipdId:workstationProblem[i].ipdincipdid,
                                                  ipdIncId: workstationProblem[i].ipdincid,
                                                  assetId:workstationProblem[i].incmAssetId  );
       Provider.of<ListProblemStoringProvider>(
                                                    context,
                                                    listen: false)
                                                .addIncidentList(data);
      }
    }
  }



  void empTimingUpdation(String startTime, String endTime) {
  DateTime fromDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTime);
  DateTime toDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTime);

  Duration timeoutDuration = toDate.difference(fromDate);
  int minutes = timeoutDuration.inMinutes;

  final listofempworkstation =
      Provider.of<ListofEmpworkstationProvider>(context, listen: false)
          .user
          ?.empWorkstationEntity;

  if (listofempworkstation != null) {
    setState(() {
      // Clear previous controllers and messages to avoid duplicates
      empTimingTextEditingControllers.clear();
      errorMessages.clear();

      for (int i = 0; i < listofempworkstation.length; i++) {
        TextEditingController controller = TextEditingController();
        controller.text = minutes.toString();
        empTimingTextEditingControllers.add(controller);
        errorMessages.add(null); // No initial error
      }
    });
  } else {
    print("listofempworkstation is null");
  }
}


void addFocusListeners() {
    goodQtyFocusNode.addListener(() {
      if (!goodQtyFocusNode.hasFocus) {
        submitGoodQuantity();
      }
    });

    rejectedQtyFocusNode.addListener(() {
      if (!rejectedQtyFocusNode.hasFocus) {
        submitRejectedQuantity();
      }
    });

    reworkFocusNode.addListener(() {
      if (!reworkFocusNode.hasFocus) {
        submitReworkQuantity();
      }
    });
  }

  void clearTextFields() {
    goodQController.clear();
    rejectedQController.clear();
    reworkQtyController.clear();
    overallqty = null;
    seqNo = null;
  }

  void updateProductName(String name) {
    productName = name;
    productNameController.text = name; // Sync the controller text
  }


  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {



     final Size size = MediaQuery.of(context).size;

    final shiftFromtime =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftFromTime;
    final shiftTotime = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.shiftToTime;

    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

    final totalGoodQty = productionEntry?.totalGoodqty;
    final totalRejQty = productionEntry?.totalRejqty;

    final listofempworkstation =
        Provider.of<ListofEmpworkstationProvider>(context, listen: false)
            .user
            ?.empWorkstationEntity;

    final StoredListOfProblem =
        Provider.of<ListProblemStoringProvider>(context, listen: true)
            .getIncidentList;

    print(productionEntry);

    // final productname = Provider.of<ProductProvider>(context, listen: false)
    //     .user
    //     ?.listofProductEntity;

    final activity = Provider.of<ActivityProvider>(context, listen: false)
        .user
        ?.activityEntity;

    final location =
        Provider.of<ProductLocationProvider>(context, listen: false)
            .user
            ?.itemProductionArea;

    final startTime = DateFormat('HH:mm:ss').format(shiftStartTime!);

    final actualdate = (fromtime != null && fromtime!.isNotEmpty)
        ? DateTime.parse(fromtime!)
        : DateTime.now();
    //  final actualdate = (lastUpdatedTime != null && lastUpdatedTime!.isNotEmpty)
    //   ? DateTime.parse(lastUpdatedTime!)
    //   : DateTime.now();

    final processName = Provider.of<EmployeeProvider>(context, listen: false)
            .user
            ?.listofEmployeeEntity
            ?.first
            .processName ??
        "";



    final scannerPwsid =
        Provider.of<ScanforworkstationProvider>(context, listen: false)
            .user
            ?.workStationScanEntity
            ?.pwsId;

 

    // final totalGoodQty = productionEntry?.totalGoodqty;
    // final totalRejQty = productionEntry?.totalRejqty;
    // final productname = Provider.of<ProductProvider>(context, listen: false)
    //     .user
    //     ?.listofProductEntity;

    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    print(productionEntry);

  final shiftStartDateTiming = '${currentYear.toString().padLeft(4, '0')}-'
      '${currentMonth.toString().padLeft(2, '0')}-'
      '${currentDay.toString().padLeft(2, '0')}  $shiftFromtime';


    final shiftEndingTime= '${currentYear.toString().padLeft(4, '0')}-'
      '${currentMonth.toString().padLeft(2, '0')}-'
      '${currentDay.toString().padLeft(2, '0')}  $shiftTotime';

    

    // DateTime shiftStartTime=DateTime.parse(fromtime!);
  
    // DateTime shiftEndtTime=DateTime.parse(lastUpdatedTime!);

    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: SizedBox(
                  height: 30.h,
                  width: 30.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _scrollDown,
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                toolbarHeight: 60.h,
                leading: IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/arrow-left.svg',
                      color: Colors.white,
                      width: 20.w,
                    ),
                    onPressed: () async {
                      // await employeeApiService.employeeList(
                      //     context: context,
                      //     deptid: widget.deptid ?? 1,
                      //     processid: widget.processid ?? 0,
                      //     psid: widget.psid ?? 0);
                      // await listofEmpworkstationService.getListofEmpWorkstation(
                      //     context: context,
                      //     deptid: widget.deptid ?? 1,
                      //     psid: widget.psid ?? 0,
                      //     processid: widget.processid ?? 0,
                      //     pwsId: widget.pwsid ?? 0);
                      // await listofworkstationService.getListofWorkstation(
                      //     context: context,
                      //     deptid: widget.deptid ?? 1057,
                      //     psid: widget.psid ?? 0,
                      //     processid: widget.processid ?? 0);
                      await attendanceCountService.getAttCount(
                          context: context,
                          id: widget.processid ?? 0,
                          deptid: widget.deptid ?? 1057,
                          psid: widget.psid ?? 0);

                      await actualQtyService.getActualQty(
                          context: context,
                          id: widget.processid ?? 0,
                          psid: widget.psid ?? 0);

                      await planQtyService.getPlanQty(
                          context: context,
                          id: widget.processid ?? 0,
                          psid: widget.psid ?? 0);

                      Navigator.of(context).pop();
                    }),

                // automaticallyImplyLeading:true,
                // leading:,

                // leading: IconButton(
                //     icon: Icon(Icons.arrow_back, color: Colors.white),
                //     onPressed: () {
                //       employeeApiService.employeeList(
                //           context: context,
                //           processid: widget.processid ?? 0,
                //           deptid: widget.deptid ?? 1,
                //           psid: widget.psid ?? 0);
                //        Provider.of<ScanforworkstationProvider>(context, listen: false).reset();
                //        Navigator.pop(context);
                //       // Navigator.of(context).push(MaterialPageRoute(
                //       //   builder: (context) => ResponsiveTabletHomepage(),
                //       // ));
                //     }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.workstationName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "lexend",
                          fontSize: 20.sp),
                    ),
                    // ScanWorkstationBarcode(
                    //   deptid: widget.deptid,
                    //   pwsid: widget.pwsid,
                    //   onCardDataReceived: (scannedBarcode) {
                    //     setState(() {
                    //       workstationBarcode = scannedBarcode;
                    //     });
                    //   },
                    // )
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 45, 54, 104),
                automaticallyImplyLeading: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
                    child: Container(
                        
                              decoration: BoxDecoration(
                             
                                color: Colors.white,),
                      child: Column(
                        children: [
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.sp),
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: Container(
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(150, 235, 236, 255),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  '${fromtime?.substring(0, fromtime!.length - 3)}',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 16.sp,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text('to',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 14.sp,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                  '${lastUpdatedTime?.substring(0, lastUpdatedTime!.length - 3)}',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 16.sp,
                                                      color: Colors.black54)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                                                UpdateTime(
                                                  key: _updateTimeKey,
                                                  onTimeChanged: (time) {
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      setState(() {
                                                        lastUpdatedTime =
                                                            time.toString();

                                                        if (fromtime != null &&
                                                            lastUpdatedTime !=
                                                                null) {
                                                          empTimingUpdation(
                                                              fromtime!,
                                                              lastUpdatedTime!);
                                                        }
                                                      });
                                                    });
                                                  },
                                                  shiftFromTime:
                                                      startTime ?? "",
                                                  shiftToTime:
                                                      shiftTotime ?? "",
                                                  shiftDate: actualdate,
                                                ),
                                              SizedBox(
                                                width: 30.w,
                                              ),
                                              SizedBox(
                                                height: 35.h,
                                                child: CustomButton(
                                                  width: 80.w,
                                                  height: 30.h,
                                                  onPressed: () {
                                                    _WorkStationcloseShiftPop(
                                                        context);

                                                  },
                                                  child: Text('Close Shift',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 12.sp,
                                                          color: Colors.white)),
                                                  backgroundColor: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.w, right: 8.w, bottom: 8.w),
                                    child: Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(5.r),
                                      child: Container(
                                       
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                150, 235, 236, 255),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Padding(
                                          padding: EdgeInsets.only(top:15.w,bottom: 15.w),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Job Card',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 14.sp,
                                                                color:
                                                                    Colors.black54,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            CardNoScanner(
                                                              // empId: widget.empid,
                                                              // processId: widget.processid,
                                                              onCardDataReceived:
                                                                  (scannedCardNo,
                                                                      scannedProductName,itemid,cardid) {
                                                                setState(() {
                                                                  cardNoController
                                                                          .text =
                                                                      scannedCardNo;
                                                                  productNameController
                                                                          .text =
                                                                      scannedProductName;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                             Focus(
  focusNode: cardNoFocusNode,
  onFocusChange: (hasFocus) {
    // Trigger only when the focus is lost
    if (!hasFocus) {
      final cardNo = int.tryParse(cardNoController.text) ?? 0;
      if (cardNo != 0) {
        cardNoApiService.getCardNo(
          context: context,
          cardNo: cardNo,
        ).then((_) {
          final item = Provider.of<CardNoProvider>(context, listen: false)
              .user
              ?.scanCardForItem;

          if (item != null) {
            setState(() {
              product_Id = item.pcItemId;
              pcid = item.pcId;
              updateProductName(item.itemName ?? "");
            });

            // Move the focus to the Item Ref field automatically
            FocusScope.of(context).requestFocus(itemRefFocusNode);
          }
        });
      }
    }
  },
  child: SizedBox(
    width: 150.w,
    height: 50.h,
    child: CustomNumField(
        enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
      controller: cardNoController,
      hintText: 'Job Card',
      keyboardtype: TextInputType.number,

      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter Job Card.';
        } else if (RegExp(r'^0+$').hasMatch(value)) {
          return 'Cannot contain zeros';
        }
        return null;
      },
      enabled: activityDropdown !=null ? false:true,
      onEditingComplete: () {
        final cardNo = int.tryParse(cardNoController.text) ?? 0;
        if (cardNo != 0) {
          cardNoApiService.getCardNo(
            context: context,
            cardNo: cardNo,
          ).then((_) {
            final item = Provider.of<CardNoProvider>(context, listen: false)
                .user
                ?.scanCardForItem;

            if (item != null) {
              setState(() {
                product_Id = item.pcItemId;
                pcid = item.pcId;
                updateProductName(item.itemName ?? "");
              });

              // Move the focus to the Item Ref field automatically
              FocusScope.of(context).requestFocus(itemRefFocusNode);
            }
          });
        }
      },
    ),
  ),
),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                     Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Item Ref",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.h,),
                                                       SizedBox(
                                                            width: 150.w,
                                                            height: 50.h,
                                                            child: TypeAheadField<
                                                                String>(
                                                              textFieldConfiguration:
                                                                  TextFieldConfiguration(
                                                                enabled:
                                                                    product_Id !=
                                                                            null
                                                                        ? false
                                                                        : true,
                                                                controller:
                                                                    productNameController,
                                                                focusNode:
                                                                    itemRefFocusNode,
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  constraints:
                                                                      BoxConstraints(
                                                                          maxHeight:
                                                                              40,
                                                                          maxWidth:
                                                                              200),
                                                                  hintText:
                                                                      "Item Ref",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black38,
                                                                      fontSize:
                                                                          16),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  errorStyle:
                                                                      TextStyle(
                                                                          fontSize:
                                                                              10.0,
                                                                          height:
                                                                              0.10),
                                                                             enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                               
                                                                  
                                                                ),
                                                                onSubmitted:
                                                                    (value) {
                                                                  validateProductName();
                                                                },
                                                                // Add this to handle validation when focus is lost
                                                                onEditingComplete:
                                                                    () {
                                                                  validateProductName();
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                },
                                                              ),
                                                              suggestionsCallback:
                                                                  (pattern) async {
                                                                if (pattern
                                                                    .isEmpty)
                                                                  return [];
                                                                final productList = Provider.of<
                                                                                ProductProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .user
                                                                        ?.listofProductEntity ??
                                                                    [];
                                                                return productList
                                                                    .where((product) =>
                                                                        product
                                                                            .productName
                                                                            ?.toLowerCase()
                                                                            .contains(pattern
                                                                                .toLowerCase()) ??
                                                                        false)
                                                                    .map((product) =>
                                                                        product
                                                                            .productName ??
                                                                        '')
                                                                    .toList();
                                                              },
                                                              itemBuilder: (context,
                                                                  String
                                                                      suggestion) {
                                                                return ListTile(
                                                                  title: Text(
                                                                      suggestion),
                                                                );
                                                              },
                                                              onSuggestionSelected:
                                                                  (String
                                                                      suggestion) {
                                                                updateProductName(
                                                                    suggestion);
                                                                // Update product ID based on selected suggestion
                                                                final productList = Provider.of<
                                                                                ProductProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .user
                                                                        ?.listofProductEntity ??
                                                                    [];
                                                                final selectedProductItem =
                                                                    productList
                                                                        .firstWhere(
                                                                  (product) =>
                                                                      product
                                                                          .productName
                                                                          ?.toLowerCase() ==
                                                                      suggestion
                                                                          .toLowerCase(),
                                                                );
                                          
                                                                if (selectedProductItem !=
                                                                    null) {
                                                                  product_Id =
                                                                      selectedProductItem
                                                                          .productid; // Update product ID
                                                                  setState(() {
                                                                    productNameController
                                                                            .text =
                                                                        selectedProductItem
                                                                            .productName!;
                                                                    itemerrorMessage =
                                                                        null; // Clear error message when valid product is selected
                                                                  });
                                                                }
                                                              },
                                                              noItemsFoundBuilder:
                                                                  (context) =>
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Text(
                                                                    'No products found',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                              ),
                                                            ),
                                                          ),
                                                          if (itemerrorMessage !=
                                                              null)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      top: 2.0),
                                                              child: Text(
                                                                itemerrorMessage ??
                                                                    "",
                                                                style: TextStyle(
                                                                  fontSize: 9.0,
                                                                  color:
                                                                      Colors.red,
                                                                  height: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                        Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Asset ID',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                                         Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ), 
                                          
                                                            ScanBarcode(
                                                              // empId: widget.empid,
                                                              pwsid: widget.pwsid,
                                                              onCardDataReceived:
                                                                  (scannedAssetId) {
                                                                setState(() {
                                                                  assetCotroller
                                                                          .text =
                                                                      scannedAssetId;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                          Focus(
                                                          focusNode: assetFocusNode,
  onFocusChange: (hasFocus) {
    if (!hasFocus) {
      // When focus is lost, submit the value
      final assetId = assetCotroller.text;

      if (assetId.isNotEmpty) {
       setState(() {
         assetCotroller.text=assetId;
       });
        print("Asset ID submitted: $assetId");
      }
    }
  },
  child: SizedBox(
    width: 150.w,
    height: 50.h,
    child: CustomNumField(
        enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
      enabled: activityDropdown != null ? false : true,
      controller: assetCotroller,
      hintText: 'Asset id',
      
    ),
  ),
),
                                                        
                                                
                                                      ],
                                                    ),
                                                   
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Production Activity',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5.h,),
                                                        Container(
                                                            width: 150.w,
                                                            height: 45.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color:
                                                                      Colors.white),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius
                                                                          .circular(
                                                                              5)),
                                                            ),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    String>(
                                                              value:
                                                                  activityDropdown,
                                                              decoration:
                                                                  InputDecoration(
                                                                fillColor:
                                                                    Colors.white,
                                                                filled: true,
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.w,
                                                                        vertical:
                                                                            2.h),
                                                                border: InputBorder
                                                                    .none,
                                                              ),
                                                              hint: Text("Select"),
                                                              isExpanded: true,
                                                             onChanged: ((cardNoController.text.isNotEmpty && productNameController
                                                                        .text
                                                                        .isNotEmpty && assetCotroller.text.isNotEmpty && reworkValue==0) )
                                                                ? 
                                                                   (String?
                                                                      newvalue) async {
                                                                      if (newvalue !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          activityDropdown =
                                                                              newvalue;
                                                                          clearTextFields();
                                                                        });
                                          
                                                                        final selectedActivity =
                                                                            activity
                                                                                ?.firstWhere(
                                                                          (activity) =>
                                                                              activity.paActivityName ==
                                                                              newvalue,
                                                                          orElse: () => ProcessActivity(
                                                                              paActivityName:
                                                                                  "",
                                                                              mpmName:
                                                                                  "",
                                                                              pwsName:
                                                                                  "",
                                                                              paId:
                                                                                  0,
                                                                              paMpmId:
                                                                                  0),
                                                                        );
                                                                    if (selectedActivity !=
                                                                                null &&
                                                                            selectedActivity.paId !=
                                                                                null) {
                                                                          activityid =
                                                                              selectedActivity.paId ??
                                                                                  0;
                                          
                                                                          Provider.of<ProductAvilableQtyProvider>(context,
                                                                                  listen: false)
                                                                              .reset();
                                          
                                                                          await productAvilableQtyService
                                                                              .getAvilableQty(
                                                                            context:
                                                                                context,
                                                                            reworkflag:
                                                                                reworkValue ?? 0,
                                                                            processid:
                                                                                widget.processid ?? 0,
                                                                            paid: activityid ??
                                                                                0,
                                                                            cardno:
                                                                                cardNoController.text,
                                                                          );
                                          
                                                                          await targetQtyApiService
                                                                              .getTargetQty(
                                                                            context:
                                                                                context,
                                                                            paId: activityid ??
                                                                                0,
                                                                            deptid:
                                                                                widget.deptid ?? 1,
                                                                            psid: widget.psid ??
                                                                                0,
                                                                            pwsid:
                                                                                widget.pwsid ?? 0,
                                                                          );
                                          
                                                                          final targetqty = Provider.of<TargetQtyProvider>(context,
                                                                                  listen: false)
                                                                              .user
                                                                              ?.targetQty;
                                                                          final overallgoodQty = Provider.of<ProductAvilableQtyProvider>(context,
                                                                                  listen: false)
                                                                              .user
                                                                              ?.productqty;
                                                                          if (overallgoodQty !=
                                                                              null) {
                                                                            print(
                                                                                'overallgoodQty list state: $overallgoodQty');
                                                                            avilableqty =
                                                                                Provider.of<ProductAvilableQtyProvider>(context, listen: false).user?.productqty?.ipcwGoodQtyAvl ?? 0;
                                          
                                                                            final processSeq = Provider.of<ProductAvilableQtyProvider>(context, listen: false)
                                                                                .user
                                                                                ?.productqty
                                                                                ?.imfgpProcessSeq;
                                          
                                                                            setState(
                                                                                () {
                                                                              overallqty =
                                                                                  avilableqty;
                                                                              seqNo =
                                                                                  processSeq;
                                          
                                                                              if ((seqNo != 1 || (seqNo == 1 && reworkValue == 1)) &&
                                                                                  overallqty != 0) {
                                                                                addFocusListeners();
                                                                              } else if ((seqNo == 1 && overallqty == 0)) {
                                                                                return null;
                                                                              } else {
                                                                                ShowError.showAlert(context, "No Avilable Quantity");
                                                                              }
                                                                            });
                                                                          } else {
                                                                            ShowError.showAlert(
                                                                                context,
                                                                                "Skipped Previous Process");
                                                                          }
                                          
                                                                          setState(
                                                                              () {
                                                                            targetQtyController.text =
                                                                                targetqty?.targetqty?.toString() ?? '';
                                                                            achivedTargetQty =
                                                                                targetqty?.achivedtargetqty?.toString() ?? "";
                                                                          });
                                                                        }
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          activityDropdown =
                                                                              null;
                                                                          activityid =
                                                                              0;
                                                                        });
                                                                      }
                                                                    }:null,
                                                              items: activity
                                                                      ?.map(
                                                                        (activityName) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            onTap:
                                                                                () {
                                                                              setState(
                                                                                  () {
                                                                                selectedName =
                                                                                    activityName.paActivityName;
                                                                              });
                                                                            },
                                                                            value:
                                                                                '${activityName.paActivityName}', // Append index to ensure uniqueness
                                                                            child:
                                                                                Text(
                                                                              activityName.paActivityName ??
                                                                                  "",
                                                                              style:
                                                                                  TextStyle(
                                                                                color:
                                                                                    Colors.black87,
                                                                                fontFamily:
                                                                                    "lexend",
                                                                                fontSize:
                                                                                    16.sp,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                      ?.toSet()
                                                                      .toList() ??
                                                                  [],
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Target Qty',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 50.h,
                                                          child: CustomNumField(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            validation: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty) {
                                                                return 'Enter target qty';
                                                              } else if (RegExp(
                                                                      r'^0+$')
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Cannot contain zeros';
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                targetQtyController,
                                                            hintText:
                                                                'Target Quantity',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Good Qty',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 14.sp,
                                                                color:
                                                                    Colors.black54,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 50.h,
                                                          child:  CustomNumField(
                                                             enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            validation: (value) {
    // This validation runs during form submission
    if (value == null || value.isEmpty) {
      return 'Enter good qty or 0';
    }
    return null;
  },
                                           
                                                                          controller:
                                                                              goodQController,
                                                                          focusNode:
                                                                              goodQtyFocusNode,
                                                                          isAlphanumeric:
                                                                              false,
                                                                          hintText:
                                                                              'Good Quantity',
                                                                          enabled: (selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                           onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1)) ?
  
  (value) {
    final currentValue = int.tryParse(value) ?? 0;

    // Clear validation error when user starts typing
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }

    setState(() {
      // Restore previous good value to overallqty if it was already subtracted
      if (previousGoodValue != null) {
        overallqty = (overallqty ?? 0) + previousGoodValue!;
        previousGoodValue = null;
      }

      // Custom validation for the input value
      if (currentValue < 0) {
        errorMessage = 'Value must be greater than 0.';
      } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) != 0) {
        errorMessage = 'Value must be between 1 and $overallqty.';
      } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) == 0) {
        errorMessage = 'Value must be 0';
      } else {
        errorMessage = null; // Clear the error message if valid
      }
    });
  }:null,
),
                                                                ),
                                                                if (errorMessage !=
                                                                    null)
                                                                  Padding(
                                                                    padding:  EdgeInsets
                                                                        .only(
                                                                        left: 8.sp,
                                                                        top: 2.sp),
                                                                    child: Text(
                                                                      errorMessage ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9.sp, // Adjust the font size as needed
                                                                        color: Colors
                                                                            .red,
                                                                        height:
                                                                            1.0, // Adjust the height to control spacing
                                                                      ),
                                                                    ),
                                                                  
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Rejected Qty',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 50.h,
                                                          child: CustomNumField(
                                                                          validation:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Enter Rejected qty or 0';
                                                                          }
                                                                          return null; // Return null if no validation errors
                                                                        },
                                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                          
                                                                          focusNode:
                                                                              rejectedQtyFocusNode,
                                                                          controller:
                                                                              rejectedQController,
                                                                          isAlphanumeric:
                                                                              false,
                                                                          hintText:
                                                                              'Rejected Quantity',
                                                                          enabled: (selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                       onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1))
                                                                            ? (value) {
                                                                                final currentValue = int.tryParse(value) ?? 0; // Parse the entered value

                                                                                setState(() {
                                                                                  // Restore previous rejected value to overallqty if it was already subtracted
                                                                                  if (previousRejectedValue != null) {
                                                                                    overallqty = (overallqty ?? 0) + previousRejectedValue!;
                                                                                    previousRejectedValue = null; // Reset the previous value after restoring
                                                                                  }

                                                                                  // Validate the entered value against overallqty
                                                                                  if (currentValue < 0) {
                                                                                    rejectederrorMessage = 'Value must be greater than 0.';
                                                                                  } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) != 0) {
                                                                                    rejectederrorMessage = 'Value must be between 1 and $overallqty.';
                                                                                  }  else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) == 0) {
                                                                                       rejectederrorMessage = 'Value must be 0';
                                                                                  } else {
                                                                                    rejectederrorMessage = null; // Clear the error message if valid
                                                                                  }
                                                                                });
                                                                              }
                                                                            : null),
                                                                ),
                                                                if (rejectederrorMessage !=
                                                                    null)
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 8.0,
                                                                        top: 2.0),
                                                                    child: Text(
                                                                      rejectederrorMessage ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9.0, // Adjust the font size as needed
                                                                        color: Colors
                                                                            .red,
                                                                        height:
                                                                            1.0, // Adjust the height to control spacing
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Rework Qty',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 14.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            Text(
                                                              ' *',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 50.h,
                                                          child:   CustomNumField(
                                                                            validation:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Enter rework qty or 0';
                                                                          }
                                                                          return null;
                                                                        },
                                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                            ),
                                          
                                                                          focusNode:
                                                                              reworkFocusNode,
                                                                          controller:
                                                                              reworkQtyController,
                                                                          isAlphanumeric:
                                                                              false,
                                                                          hintText:
                                                                              'rework qty  ',
                                                                          enabled: (selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                            onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1))
                                                                            ? (value) {
                                                                                final currentValue = int.tryParse(value) ?? 0;

                                                                                setState(() {
                                                                                  // Restore previous rejected value to overallqty if it was already subtracted
                                                                                  if (previousReworkValue != null) {
                                                                                    overallqty = (overallqty ?? 0) + previousReworkValue!;
                                                                                    previousReworkValue = null; // Reset the previous value after restoring
                                                                                  }

                                                                                  // Validate the entered value against overallqty
                                                                                  if (currentValue < 0) {
                                                                                    reworkerrorMessage = 'Value must be greater than 0.';
                                                                                  } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) != 0) {
                                                                                    reworkerrorMessage = 'Value must be between 1 and $overallqty.';
                                                                                  } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) == 0) {
                                                                                       reworkerrorMessage = 'Value must be 0';
                                                                                  } else { 
                                                                                    reworkerrorMessage = null; // Clear the error message if valid
                                                                                  }
                                                                                });
                                                                              }
                                                                            : null),
                                                                ),
                                                                if (reworkerrorMessage !=
                                                                    null)
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 8.0,
                                                                        top: 1.0),
                                                                    child: Text(
                                                                      reworkerrorMessage ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9.0, // Adjust the font size as needed
                                                                        color: Colors
                                                                            .red,
                                                                        height:
                                                                            1.0, // Adjust the height to control spacing
                                                                      ),
                                                                    ),
                                                                  ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 4.w),
                                                              child: Text('Rework',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: Colors
                                                                          .black54)),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            SizedBox(
                                                                width: 100.w,
                                                                height: 40.h,
                                                                child: Checkbox(
                                                                  value:
                                                                      isChecked,
                                                                  activeColor:
                                                                      Colors
                                                                          .green,
                                                                  onChanged:
                                                                      (selectedName ==
                                                                              null)
                                                                          ? null
                                                                          : (newValue) async {
                                                                              setState(() {
                                                                                isChecked = newValue ?? false;
                                                                                reworkValue = isChecked ? 1 : 0;
                                                                                clearTextFields();
                                                                              });
                                          
                                                                              if (reworkValue ==
                                                                                  1) {
                                                                                Provider.of<ProductAvilableQtyProvider>(context, listen: false).reset();
                                          
                                                                                await productAvilableQtyService.getAvilableQty(
                                                                                  context: context,
                                                                                  reworkflag: reworkValue ?? 0,
                                                                                  processid: widget.processid ?? 0,
                                                                                  paid: activityid ?? 0,
                                                                                  cardno: cardNoController.text,
                                                                                );
                                          
                                                                                final overallgoodQty = Provider.of<ProductAvilableQtyProvider>(context, listen: false).user?.productqty;
                                          
                                                                                if (overallgoodQty != null) {
                                                                                  print('overallgoodQty list state: $overallgoodQty');
                                                                                  avilableqty = Provider.of<ProductAvilableQtyProvider>(context, listen: false).user?.productqty?.ipcwGoodQtyAvl ?? 0;
                                          
                                                                                  final processSeq = Provider.of<ProductAvilableQtyProvider>(context, listen: false).user?.productqty?.imfgpProcessSeq;
                                          
                                                                                  setState(() {
                                                                                    overallqty = avilableqty;
                                                                                    seqNo = processSeq;
                                                                                    if ((seqNo != 1 || (seqNo == 1 && reworkValue == 1 && overallqty != 0)) && overallqty != 0) {
                                                                                      addFocusListeners();
                                                                                    } else if ((seqNo == 1 && reworkValue == 0)) {
                                                                                      return;
                                                                                    } else {
                                                                                      ShowError.showAlert(context, "Rework Qty Not Avilable", "Alert");
                                                                                    }
                                                                                  });
                                                                                } else {
                                                                                  ShowError.showAlert(context, "Skipped Previous Process");
                                                                                }
                                                                              }
                                          
                                                                              print("reworkvalue $reworkValue");
                                                                            },
                                                                ),
                                                                
                                                                ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Row(
                                                      children: [
                                                      
                                                  
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 40.h,
                                                          child:
                                                              FloatingActionButton(
                                                                
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                 
                                                                  mini: true,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(50
                                                                              .r)),
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      nonProductionActivityService
                                                                          .getNonProductionList(
                                                                        context:
                                                                            context,
                                                                      );
                                                                      _nonProductionActivityPopup(  
                                                                          fromtime,
                                                                          lastUpdatedTime);
                                                                    });
                                                                              
                                                                    // Update time after each change
                                                                  },
                                                                  child: Text("Non Productive Time",style: TextStyle(fontSize: 12.sp,fontFamily: "lexend",color: Colors.white),),)
                                                        ),
                                                      ],
                                                    )
                                          
                                          
                                                    
                                                  ],
                                                ),
                                                 SizedBox(
                                                  height: 10.h,
                                                ),
                                                 Row(     
                                          
                                                  
                                                  children: [
                                          
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 12.w),
                                                    child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            
                                                            Row(
                                                              children: [
                                                                Text('Holding Area',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "lexend",
                                                                        fontSize:
                                                                            14.sp,
                                                                        color: Colors
                                                                            .black54)),
                                                                Text(
                                                                  ' *',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize: 16.sp,
                                                                    color:
                                                                        Colors.red,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                           PopupMenuButton<String>(
                                            onSelected: (String newValue) {
                                              setState(() {
                                                locationDropdown = newValue;
                                              });
                                          
                                              final selectedLocation = location?.firstWhere(
                                                  (location) => location.ipaName == newValue);
                                          
                                              if (selectedLocation != null && selectedLocation.ipaId != null) {
                                                locationid = selectedLocation.ipaId ?? 0;
                                              }
                                            },
                                          
                                            itemBuilder: (BuildContext context) {
                                              return location?.map((location) {
                                                return PopupMenuItem<String>(
                                                  value: location.ipaName,
                                                  child: Container(
                                                    width:100.w,
                                                  
                                                    child: Text(
                                                      location.ipaName ?? "",
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontFamily: "lexend",
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList() ??
                                              [];
                                            },
                                              color: Colors.white,
                                            child: Container(
                                              width: 150.w,
                                              height: 45.h,
                                              decoration: BoxDecoration(  
                                                border: Border.all(width: 1, color: Colors.white),
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                color: Colors.white
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    locationDropdown ?? "Select",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily: "lexend",
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                  Icon(Icons.arrow_drop_down, color: Colors.black54),
                                                ],
                                              ),
                                            ),
                                          ),
                                          
                                                          ],
                                                        ),
                                                  ),
                                          
                                                ],),
                                          
                                                SizedBox(
                                                  height: 25.h,
                                                ),
                                          
                                               
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
  height: 35.h,
  child: CustomButton(
    width: 100.w,
    height: 50.h,
   onPressed: selectedName != null &&
            locationDropdown != null &&
            assetCotroller.text.isNotEmpty && errorMessage==null &&rejectederrorMessage==null && reworkerrorMessage==null
        ? () {
            if (_formkey.currentState?.validate() ?? false) {
              // If the form is valid, perform your actions
              print('Form is valid');
        if (goodQController.text !="0" || rejectedQController.text!="0"|| reworkQtyController.text!="0"){
               
            
              // Check if any TextFormField is empty or has an error message before submitting
              if (fromtime != lastUpdatedTime) {
                bool hasError = false;

                for (var i = 0; i < empTimingTextEditingControllers.length; i++) {
                  String controllerText = empTimingTextEditingControllers[i].text;
                  String? errorMessage = (i < errorMessages.length) ? errorMessages[i] : null;

                  // Only trigger hasError if the field is empty or errorMessage contains text
                  if (controllerText.isEmpty || (errorMessage != null && errorMessage.isNotEmpty)) {
                    hasError = true;
                    break;
                  }
                }

                if (hasError) {
                  ShowError.showAlert(
                    context,
                    "Enter Valid Employee Worked Minutes",
                    "Alert",
                    "Warning",
                    Colors.orange,
                  );
                } else {
                  _submitPop(context);
                }
              } else {
                ShowError.showAlert(
                  context,
                  "The fromtime and totime are the same, so you cannot submit any values.",
                  "Alert",
                  "Warning",
                  Colors.orange,
                );
              }
}
else{
   ShowError.showAlert(
                  context,
                  "Every value not allow to the 0",
                  "Alert",
                  "Warning",
                  Colors.orange,
                );
}
            }
            else {
              // Handle the invalid form case
              print('Form is not valid');
            }
          }
        : null,
    child: Text(
      'Submit',
      style: TextStyle(
        fontFamily: "lexend",
        fontSize: 14.sp,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.green,
    borderRadius: BorderRadius.circular(50),
  ),
),
                                                  ],
                                                ),
                                              ]
                                              
                                              
                                              
                                              
                                              
                                              
                                              ),
                                        ),
                                      ),
                                    )),
                                 Padding(padding:EdgeInsets.only(left: 8.w, right: 8.w),
                                 child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text("Employees",style: TextStyle(
                                                              fontFamily: "lexend",
                                                              fontSize: 16.sp,
                                                              color: Color.fromARGB(255, 80, 96, 203))),
                                   ],
                                 ), ),

                                 Padding(
                                  padding:EdgeInsets.only(left: 8.w, right: 8.w),
                                   child: Container(height: 80.h,
                                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5.r),
                                                      topRight:
                                                          Radius.circular(5.r)),
                                                  color: Color.fromARGB(
                                                      255, 45, 54, 104)),
                                   child: Padding(
                                     padding:  EdgeInsets.all(4.sp),
                                     child: Row(children: [
                                      SizedBox(
                                                        width: 40.w,
                                                        child: Center(
                                                          child: Text(
                                                            'S.No',
                                                            style: TextStyle(
                                                              
                                                                fontFamily: "lexend",
                                                                                               
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                                        SizedBox(
                                                        width: 100.w,
                                                        child: Center(
                                                          child: Text(
                                                            'Employees',
                                                            style: TextStyle(
                                                                fontFamily: "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                     
                                                        SizedBox(
                                                        width: 120.w,
                                                        child: Center(
                                                          child: Text(
                                                            'Working Minutes',
                                                            style: TextStyle(
                                                                fontFamily: "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                                        SizedBox(
                                                        width: 70.w,
                                                        child: Center(
                                                          child: Text(
                                                            'Shift',
                                                            style: TextStyle(
                                                                fontFamily: "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                     ],),
                                   ),),
                                 ),
                                                      
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                  child: Material(
                                    elevation: 3,
                                    borderRadius:   BorderRadius.only(
                                                      bottomLeft: Radius.circular(5.r),
                                                    bottomRight:
                                                          Radius.circular(5.r)),
                                    child: Container(
                                      height: 225.h,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(150, 235, 236, 255),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: ListView.builder(
                                        itemCount: listofempworkstation?.length,
                                        itemBuilder: (context, index) {
                                          final workstaion =
                                              listofempworkstation?[index];
                                          return Container(
                                            height: 110.h,
                                            decoration: BoxDecoration(
                                                color: index % 2 == 0
                                                    ? Color.fromARGB(
                                                        250, 235, 236, 255)
                                                    : Color.fromARGB(
                                                        10, 235, 236, 255),
                                                borderRadius:
                                                    BorderRadius.circular(5.r)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2.sp, right: 2.sp),
                                              child: Row(children: [
                                                SizedBox(
                                                    width: 30.w,
                                                    child: Center(
                                                      child: Text(
                                                        '${index + 1} ',
                                                        style: TextStyle(
                                                            fontFamily: "lexend",
                                                            fontSize: 14.sp,
                                                            color: Colors.black54),
                                                      ),
                                                    )),
                                                SizedBox(
                                                    width: 115.w,
                                                    child: Text(

 workstaion!.personFname![0]
                                                                            .toUpperCase() +
                                                                        workstaion
                                                                            .personFname!
                                                                            .substring(
                                                                                1,
                                                                                workstaion!.personFname!.length -
                                                                                    1)
                                                                            .toLowerCase() +
                                                                        workstaion
                                                                            .personFname!
                                                                            .substring(workstaion.personFname!.length -
                                                                                1)
                                                                            .toUpperCase() ??
                                                                    '',

                                                     
                                                          style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black54),)),

                                                              Container(
                                                                alignment: Alignment.center,
                                                                width: 105.w,
                                                                height: 50, // Container height remains fixed
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 90.w,
                                                                      height: 35, // Keep the size fixed for the TextFormField
                                                                      child: TextFormField(
                                                                        keyboardType: TextInputType.number,
                                                                        controller: empTimingTextEditingControllers[index],
                                                                        decoration: InputDecoration(
                                                                          filled: true,
                                                                          fillColor: Colors.white,
                                                                          contentPadding: EdgeInsets.all(5),
                                                                          hintText: "minutes",
                                                                          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                                                                          labelStyle: const TextStyle(fontSize: 12),
                                                                          constraints: BoxConstraints(maxHeight: 40, maxWidth: 100),
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            borderSide: BorderSide(color: Colors.grey.shade200),
                                                                          ),
                                                                          errorBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            borderSide: BorderSide(color: Colors.red.shade300),
                                                                          ),
                                                                        ),
                                                                     onChanged:
                                                                          (value) {
                                                                        DateTime fromTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromtime!);
                                                                        DateTime toTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastUpdatedTime!);
                                                                        fromMinutes = toTime
                                                                            ?.difference(fromTime!)
                                                                            .inMinutes;

                                                                    

                                                                        setState(
                                                                            () {
                                                                                  final enteredMinutes =
                                                                            int.tryParse(value) ??
                                                                               0 ;
                                                                          if (enteredMinutes < 0 ||
                                                                              enteredMinutes > fromMinutes!) {
                                                                            errorMessages[index] =
                                                                                'Value b/w 0 to $fromMinutes minutes.';
                                                                          } else {
                                                                            errorMessages[index] =
                                                                                null; // Clear error message if valid
                                                                          }
                                                                        });
                                                                      },
                                                                      // onEditingComplete: () {
                                                                      //   final value = empTimingTextEditingControllers[index].text;
                                                                      //   final enteredMinutes = int.tryParse(value) ?? -1;

                                                                      //   setState(() {
                                                                      //     if (enteredMinutes < 0 || enteredMinutes > fromMinutes!) {
                                                                      //       errorMessages[index] = 'Value 0 to $fromMinutes minutes.';
                                                                      //     } else {
                                                                      //       errorMessages[index] = null; // Clear error message if valid
                                                                      //     }
                                                                      //   });
                                                                      // },
                                                                    ),
                                                                  ),
                                                                  // This space will display the error message but won't change the TextFormField size
                                                                   if (errorMessages[
                                                                          index] !=
                                                                      null)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0,
                                                                          top:
                                                                              2.0),
                                                                      child:
                                                                          Text(
                                                                        errorMessages[
                                                                            index]!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              8.0, // Adjust the font size as needed
                                                                          color:
                                                                              Colors.red,
                                                                          height:
                                                                              1.0, // Adjust the height to control spacing
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                // SizedBox(
                                                //   width: 100.w,
                                                //   child: Text(
                                                //     ' ${workstaion?.flattstatus == 1 ? "Present" : "Absent"}  ',
                                                //     style: TextStyle(
                                                //         fontFamily: "lexend",
                                                //         fontSize: 14.sp,
                                                //         color: Colors.black54),
                                                //   ),
                                                // ),
                                                if (workstaion
                                                        ?.flattshiftstatus ==
                                                    1)
                                                  SizedBox(
                                                         width: 80.w,
                                                      height: 35.h,
                                                    child: Center(
                                                      child: CustomButton(
                                                             width: 80.w,
                                                      height: 30.h,
                                                        onPressed: () {
                                                          _closeShiftPop(
                                                              context,
                                                              ' ${workstaion?.attendanceid ?? ''}  ',
                                                              "${workstaion?.flattstatus ?? ""}");
                                                        },
                                                        child: Text('Close',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Lexend",
                                                                fontSize: 12.sp,
                                                                color:
                                                                    Colors.white)),
                                                        backgroundColor:
                                                            Colors.green,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                    ),
                                                      
                                                    // else if (shiftstatus == 2)
                                                  )
                                                else if (workstaion
                                                        ?.flattshiftstatus ==
                                                    2)
                                                  Center(
                                                    child: SizedBox(
                                                      width: 80.w,
                                                      height: 35.h,
                                                      child: CustomButton(
                                                        width: 80.w,
                                                        height: 35.h,
                                                        onPressed: () {
                                                          _EmpOpenShiftPop(
                                                              context,
                                                              ' ${workstaion?.attendanceid ?? ''}  ',
                                                              "${workstaion?.flattstatus ?? ""}");
                                                        },
                                                        child: Text('Reopen',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 12.sp,
                                                                color:
                                                                    Colors.white)),
                                                        backgroundColor: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                    ),
                                                  )
                                              ]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                               
                             
                                Padding(
                                  padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                                  child: Container(
                                    height: 50.h,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Problems",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: "Lexend",
                                              color:
                                                  Color.fromARGB(255, 80, 96, 203)),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                          height: 30.h,
                                          child: FloatingActionButton(
                                            heroTag: 'Add Issue',
                                            backgroundColor: Colors.white,
                                            tooltip: 'Add Issue',
                                            mini: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            onPressed: assetCotroller.text.isNotEmpty ?() async {
                                            
                                            
                                                        listofproblemservice
                                                            .getListofProblem(
                                                                context:
                                                                    context,
                                                                processid: widget
                                                                        .processid ??
                                                                    0,
                                                                deptid: widget
                                                                        .deptid ??
                                                                    1057,
                                                                assetid: int.tryParse(
                                                                    assetCotroller
                                                                        .text ?? "") ?? 0);

                                                        _problemEntrywidget(
                                                            fromtime,
                                                            lastUpdatedTime,
                                                            widget.processid,widget.deptid,int.tryParse(
                                                                    assetCotroller
                                                                        .text ?? ""));
                                             
                                          
                                  
                                              // Update time after each change
                                            }: (){
                                                    ShowError.showAlert(context, "Enter the Asset Id", "Alert","Warning",Colors.orange);
                                                    },
                                            child: const Icon(Icons.add,
                                                color: Colors.black, size: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding:EdgeInsets.only(left: 8.w, right: 8.w),
                                   child: Container(height: 80.h,
                                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5.r),
                                                      topRight:
                                                          Radius.circular(5.r)),
                                                  color: Color.fromARGB(
                                                      255, 45, 54, 104)),
                                   child: Padding(
                                     padding:  EdgeInsets.all(4.sp),
                                     child: Row(children: [
                                      SizedBox(
                                                        width: 40.w,
                                                        child: Center(
                                                          child: Text(
                                                            'S.No',
                                                            style: TextStyle(
                                                              
                                                                fontFamily: "lexend",
                                                                                               
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                                        SizedBox(
                                                        width: 100.w,
                                                        child: Center(
                                                          child: Text(
                                                            'Problems',
                                                            style: TextStyle(
                                                                fontFamily: "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                     
                                                        SizedBox(
                                                        width: 140.w,
                                                        child: Center(
                                                          child: Text(
                                                            'Problems Category',
                                                            style: TextStyle(
                                                                fontFamily: "lexend",
                                                                fontSize: 14.sp,
                                                                color: Colors.white),
                                                          ),
                                                        )),
                                                        // SizedBox(
                                                        // width: 50.w,
                                                        // child: Center(
                                                        //   child: Text(
                                                        //     'Delete',
                                                        //     style: TextStyle(
                                                        //         fontFamily: "lexend",
                                                        //         fontSize: 14.sp,
                                                        //         color: Colors.white),
                                                        //   ),
                                                        // )),
                                     ],),
                                   ),),
                                 ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                  child: Material(
                                    elevation: 3,
                               
                                    child: 
                                    Container(
                                      height: 200.h,
                                      width: 500.w,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(150, 235, 236, 255),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5.r),
                                            bottomRight:Radius.circular(5.r),
                                          )),
                                      child:    (StoredListOfProblem.isNotEmpty) ?
                                         
                                      
                                      ListView.builder(
                                        itemCount: StoredListOfProblem.length,
                                        itemBuilder: (context, index) {
                                         final item =
                                                          StoredListOfProblem[
                                                              index];
                                                      return GestureDetector(
                                                        onTap:() {
                                                           listofproblemservice
                                                            .getListofProblem(
                                                                context:
                                                                    context,
                                                                processid: widget
                                                                        .processid ??
                                                                    0,
                                                                deptid: widget
                                                                        .deptid ??
                                                                    1057,
                                                                    
                                                                        assetid:item.assetId ?? 0  );
                                                                        
                                                          _problemEntrywidget(
                                                              item.fromtime,
                                                              lastUpdatedTime,
                                                              widget.processid,
                                                              widget.deptid,
                                                              item.assetId,
                                                              item.problemId,
                                                              item.problemCategoryId,
                                                              item.rootCauseId,
                                                              item.reasons,
                                                              item.solutionId,
                                                              item.problemstatusId,
                                                              item.productionStoppageId,
                                                              item.ipdId ?? 0,
                                                              item.ipdIncId ?? 0,
                                                              true,
                                                              fromtime,
                                                              widget.pwsid
                                                              );
                                                        },
                                            child: Container(
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                  color: index % 2 == 0
                                                      ? Color.fromARGB(
                                                          250, 235, 236, 255)
                                                      : Color.fromARGB(
                                                          10, 235, 236, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(5.r)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.w, right: 8.w),
                                                child: Row(children: [
                                                  SizedBox(
                                                      width: 20.w,
                                                      child: Text(
                                                        '${index + 1} ',
                                                        style: TextStyle(
                                                            fontFamily: "lexend",
                                                            fontSize: 14.sp,
                                                            color:
                                                                Colors.black54),
                                                      )),
                                                  SizedBox(
                                                      width: 135.w,
                                                      child: Text(
                                                          item?.problemName ?? "",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 12.sp,
                                                              color: Colors
                                                                  .black54))),
                                                  SizedBox(
                                                      width: 120.w,
                                                      child: Text(
                                                          item?.problemCategoryname ??
                                                              "",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 12.sp,
                                                              color: Colors
                                                                  .black54))),
                                                                        Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 50.w,
                                                                    child:
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(
                                                                                  () {
                                                                                StoredListOfProblem.removeAt(index);
                                                                              });
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons
                                                                                  .delete,
                                                                              color:
                                                                                  Colors.red,
                                                                            ))),
                                                                  
                                                               
                                                ]),
                                              ),
                                            ),
                                          );
                                        },
                                      ):   Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("No Records found",style: TextStyle(fontSize: 14.sp),),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Material(
                                    elevation: 3,
                                 
                                    child: Container(
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(150, 235, 236, 255),
                                          borderRadius: BorderRadius.circular(5.r)),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Recent History",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.black54,
                                                    fontFamily: "Lexend")),
                                            CustomButton(
                                                width: 80.w,
                                                height: 30.h,
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                backgroundColor: Colors.green,
                                                onPressed: () {
             
                                                  _openBottomSheet();
                                                },
                                                child: Text(
                                                  "View",
                                                  style: TextStyle(
                                                      fontFamily: "Lexend",
                                                      color: Colors.white,
                                                      fontSize: 12.sp),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
