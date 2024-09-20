// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';
import 'package:prominous/constant/request_data_model/non_production_entry_model.dart';
import 'package:prominous/constant/request_data_model/workstation_entry_model.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_emp_list_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_nonproduction_lis_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/non_production_activity_di.dart';
import 'package:prominous/features/presentation_layer/provider/edit_emp_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/edit_nonproduction_provider.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_stroed_list_provider.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/presentation_layer/api_services/Editincidentlist_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofempworkstation_di.dart';
import 'package:prominous/features/presentation_layer/provider/edit_entry_provider.dart';
import 'package:prominous/features/presentation_layer/provider/edit_incident_list_provider.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/emp_close_shift_widget.dart';
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
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_provider.dart';
import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/provider/target_qty_provider.dart';
import 'package:prominous/features/presentation_layer/widget/barcode_widget/asset_barcode_scanner.dart';
import 'package:prominous/features/presentation_layer/widget/barcode_widget/cardno_barcode_scanner.dart';
import '../../api_services/product_di.dart';
import '../timing_widget/set_timing_widget.dart';
import 'package:intl/intl.dart';
import '../../../../constant/utilities/exception_handle/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../../../constant/utilities/customwidgets/customnum_field.dart';

class EditEmpProductionEntryPage extends StatefulWidget {
  final int? empid;
  final int? processid;
  final int? deptid;
  bool? isload;
  final int? psid;
  final int? ipdid;
  final int? attendceStatus;
  final String? attenceid;
  final int? pwsId;
  final String? workstationName;

  EditEmpProductionEntryPage(
      {Key? key,
      this.empid,
      this.processid,
      this.isload,
      this.deptid,
      this.psid,
      this.attenceid,
      this.attendceStatus,
      this.ipdid,
      this.pwsId,
      this.workstationName})
      : super(key: key);

  @override
  State<EditEmpProductionEntryPage> createState() =>
      _EditEmpProductionEntryPageState();
}

class _EditEmpProductionEntryPageState extends State<EditEmpProductionEntryPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    late ListProblemStoringProvider storedListOfProblem;
  late NonProductionStoredListProvider nonProductionList;
  final TextEditingController goodQController = TextEditingController();
  final TextEditingController rejectedQController = TextEditingController();
  // final TextEditingController reworkQController = TextEditingController();
  final TextEditingController targetQtyController = TextEditingController();
  final TextEditingController reworkQtyController = TextEditingController();

  final TextEditingController batchNOController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController assetCotroller = TextEditingController();
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  final ActivityService activityService = ActivityService();
  final TargetQtyApiService targetQtyApiService = TargetQtyApiService();
  EditEntryApiservice editEntryApiservice = EditEntryApiservice();
  EditIncidentListService editIncidentListService = EditIncidentListService();
  EditNonProductionListService editNonProductionListService=EditNonProductionListService();
    EditEmpListApiservice editEmpListApiservice=EditEmpListApiservice();
   final NonProductionActivityService nonProductionActivityService =NonProductionActivityService();
     final Listofproblemservice listofproblemservice = Listofproblemservice();
  final ListofEmpworkstationService listofEmpworkstationService =
      ListofEmpworkstationService();
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
  String? selectedName;
  int? product_Id;

  TimeOfDay timeofDay = TimeOfDay.now();
  late DateTime currentDateTime;
  // Initialized to avoid null check

  List<Map<String, dynamic>> submittedDataList = [];

  String? dropdownProduct;
  String? activityDropdown;
  // String? lastUpdatedTime;
  String? currentDate;
  int? reworkValue;
  int? productid;
  int? activityid;
  TimeOfDay? updateTimeManually;
  String? cardNo;
  String? productName;
  String? assetID;
  String? achivedTargetQty;
  int? fromMinutes; 
   List<TextEditingController> empTimingTextEditingControllers = [];

  final List<String?> errorMessages = [];

  EmpProductionEntryService empProductionEntryService =
      EmpProductionEntryService();

  EmployeeApiService employeeApiService = EmployeeApiService();

  Future<void> updateproduction(int? processid) async {
    final responsedata = Provider.of<EditEntryProvider>(context, listen: false)
        .editEntry
        ?.editEntry;

    final pcid = Provider.of<CardNoProvider>(context, listen: false)
        .user
        ?.scanCardForItem
        ?.pcId;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    final ppId = Provider.of<TargetQtyProvider>(context, listen: false)
        .user
        ?.targetQty
        ?.ppid;

                    final EmpWorkstation =
        Provider.of<EditEmpListProvider>(context, listen: false)
            .user
            ?.editEmplistEntity;
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
          '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString()}:${currentSecond.toString()}';

      final fromtime = empproduction?.ipdFromTime;
      final totime = empproduction?.ipdToTime;
      //String toDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      
      WorkStationEntryReqModel editworkStationEntryReq = WorkStationEntryReqModel(
        apiFor: "edit_entry_server_v1",
        clientAuthToken: token,
        // emppersonid: empid,
        // goodQuantities: empproduction.first.goodqty,
        // rejectedQuantities: empproduction.first.rejqty,
        // reworkQuantities: empproduction.first.ipdflagid,

ipdGoodQty:double.tryParse(goodQController.text) ?? 0, 
ipdRejQty:double.tryParse(rejectedQController.text) ?? 0 ,
ipdReworkFlag: reworkValue ?? empproduction.ipdReworkFlag ,
ipdreworkableqty: double.tryParse(reworkQtyController.text),
targetqty: double.tryParse(targetQtyController.text),

        ipdCardNo: int.tryParse(cardNoController.text.toString()),

        ipdpaid: activityid ?? 0,

        ipdFromTime: fromtime,
        // ipdFromTime: empproduction.ipdFromTime == ""
        //     ? currentDateTime.toString()
        //     : empproduction.ipdFromTime,
        ipdToTime: totime,

        // ipdToTime: lastUpdatedTime ?? currentDateTime,
        ipdDate: currentDateTime.toString(),
        ipdId: widget.ipdid,
        // activityid == empproduction.ipdpaid ? empproduction.ipdid : 0,
        ipdPcId: pcid ?? empproduction.ipdPcId,
        ipdDeptId: widget.deptid ?? 1,
        ipdAssetId: int.tryParse(assetCotroller.text.toString()),
        //ipdcardno: empproduction.first.ipdcardno,
        ipdItemId: product_Id,
        ipdMpmId: processid,
        // emppersonId: widget.empid ?? 0,
        ipdpsid: widget.psid,
        ppid: ppId ?? 0,
        shiftid: Shiftid,
        listOfEmployeesForWorkStation: [],
        listOfWorkstationIncident: [],
        nonProductionList: [],
        pwsid: widget.pwsId
      );

for (int index = 0; index < EmpWorkstation!.length; index++) {
  final empid = EmpWorkstation[index];
  final emptimingController = empTimingTextEditingControllers[index];

  // Parse the timing from the TextEditingController's text
  final emptiming = int.tryParse(emptimingController.text) ?? 0;

  print(emptiming);

  // Create a ListOfEmployeesForWorkStation object with the timing
  final listofempworkstation = ListOfEmployeesForWorkStation(
    empId: empid.empId ?? 0,
    timing:emptiming, 
    ipdeId: empid.ipdeId,  // Assign the parsed timing value
  );

  // Add the object to workStationEntryReq.listOfEmployeesForWorkStation
  editworkStationEntryReq.listOfEmployeesForWorkStation.add(listofempworkstation);
}


      for (int index = 0; index < StoredListOfProblem.length; index++) {
        final incident = StoredListOfProblem[index];
        final lisofincident = ListOfWorkStationIncidents(
            incidenid: incident.problemId,
            notes: incident.reasons,
            rootcauseid: incident.rootCauseId,
            subincidentid: incident.problemcatagoryId,
        incfromtime: incident.fromtime, 
        incendtime:incident.endtime,
        problemStatusId:incident.problemstatusId,
        productionstopageId:incident.productionStoppageId ,
        solutionId:incident.solutionId);


        editworkStationEntryReq.listOfWorkstationIncident.add(lisofincident);
      }

      for (int index = 0; index < ListofNonProduction.length; index++) {
        final nonProduction = ListofNonProduction[index];
        final nonProductionList = NonProductionList(
          fromTime: nonProduction.npamFromTime,
          notes: nonProduction.notes,
          npamId: nonProduction.npamId,
          toTime: nonProduction.npamToTime,
        );
        editworkStationEntryReq.nonProductionList.add(nonProductionList);
      }

      final requestBodyjson = jsonEncode(editworkStationEntryReq.toJson());



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
            print(responseJson);
            return responseJson;
          } catch (e) {
            // Handle the case where the response body is not a valid JSON object
            throw ("Invalid JSON response from the server");
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
      print("empproduction is empty");
    }
  }



  void updateinitial() {
    if (widget.isload == true) {
      final EditproductionEntry =
          Provider.of<EditEntryProvider>(context, listen: false)
              .editEntry
              ?.editEntry;
      final productname = Provider.of<ProductProvider>(context, listen: false)
          .user
          ?.listofProductEntity;

      setState(() {
        assetCotroller.text =
            EditproductionEntry?.ipdAssetId?.toString() ?? "0";
        cardNoController.text =
            EditproductionEntry?.ipdCardNo?.toString() ?? "0";

        // If itemid is not 0, find the matching product name
        productNameController.text = (EditproductionEntry?.ipdItemId != 0
            ? productname
                ?.firstWhere(
                  (product) =>
                      EditproductionEntry?.ipdItemId == product.productid,
                )
                .productName
            : "0")!;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchARecentActivity().then((_) {
      updateinitial();
    });

    currentDateTime = DateTime.now();
    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;


    // if (shiftToTimeString != null) {
    //   DateTime? shiftToTime;
    //   // Parse the shiftToTime
    //   final shiftToTimeParts = shiftToTimeString.split(':');
    //   final now = DateTime.now();
    //   shiftToTime = DateTime(
    //     now.year,
    //     now.month,
    //     now.day,
    //     int.parse(shiftToTimeParts[0]),
    //     int.parse(shiftToTimeParts[1]),
    //     int.parse(shiftToTimeParts[2]),
    //   );

    //   // Get the current time
    //   final currentTime = DateTime.now();


    // lastUpdatedTime = '$currentYear-$currentMonth-$currentDay $shiftTime';
    currentDate =
           '${currentYear.toString().padLeft(4, '0')}-'
      '${currentMonth.toString().padLeft(2, '0')}-'
      '${currentDay.toString().padLeft(2, '0')} ' 
      '${currentHour.toString().padLeft(2, '0')}:'
        '${currentMinute.toString().padLeft(2, '0')}:'
        '${currentSecond.toString().padLeft(2, '0')}';


         SchedulerBinding.instance.addPostFrameCallback((_) {
      _storedNonProductionList();
    });
   // Using addPostFrameCallback to ensure this runs after the initial build



  
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

    // Use the stored reference
    storedListOfProblem.reset(notify: false);
    nonProductionList.reset(notify: false);
    super.dispose();
  }





  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  // }

  Future<void> _fetchARecentActivity() async {
    try {

      await editIncidentListService.getIncidentList(
        context: context,
        ipdid: widget.ipdid ?? 0,
        deptid: widget.deptid ?? 0,
      );
      await editNonProductionListService.getNonProductionList(context:context , ipdid: widget.ipdid ?? 0);
     await editEmpListApiservice.getEditEmplist(context:context , ipdid: widget.ipdid ?? 0);

      await productApiService.productList(
          context: context,
          id: widget.processid ?? 1,
          deptId: widget.deptid ?? 0);

      await activityService.getActivity(
          context: context,
          id: widget.processid ?? 0,
          deptid: widget.deptid ?? 0,
          pwsId: widget.pwsId ?? 0);
                _storeIncidentList();
                      final productionEntry =
          Provider.of<EditEntryProvider>(context, listen: false)
              .editEntry
              ?.editEntry;
                    final fromtime = productionEntry?.ipdFromTime ;
    final totime = productionEntry?.ipdToTime ;
    DateTime StartfromTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromtime!);
  DateTime endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(totime!);
   fromMinutes = endTime.difference(StartfromTime).inMinutes;

   



      // Access fetched data and set initial values
      final initialValue = productionEntry?.ipdReworkFlag;

      if (initialValue != null) {
        setState(() {
          isChecked = initialValue == 1;
          goodQController.text = productionEntry?.ipdGoodQty?.toString() ?? "";
          rejectedQController.text =
              productionEntry?.ipdRejQty?.toString() ?? "";
          reworkQtyController.text =
              productionEntry?.ipdReworkableQty.toString() ??
                  ""
                      ""; // Set isChecked based on initialValue
        });
      }
      // Update cardNo with the retrieved cardNumber
      // setState(() {
      //   cardNo = productionEntry?.ipdcardno?.toString() ??"0"; // Set cardNo with the retrieved value
      // });

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


    void _storedNonProductionList() {
    final editNonProduction =
        Provider.of<EditNonproductionProvider>(context, listen: false)
            .listOfNonproduction
            ?.listOfNonProductionEntity;
           

    if (editNonProduction != null) {
      for (int i = 0; i < editNonProduction.length; i++) {
         NonProductionEntryModel data = NonProductionEntryModel(
                                                  notes: editNonProduction[i].inpaNotes,
                                                  npamFromTime: editNonProduction[i].inpaFromTime,
                                                  npamId: editNonProduction[i].inpaNpamId,
                                                  npamToTime: editNonProduction[i].inpaToTime,
                                                  npamName: editNonProduction[i].npamName);

       Provider.of<NonProductionStoredListProvider>(
                                                    context,
                                                    listen: false)
                                                .addNonProductionList(data);
      }
    }
  }

   void _EmpOpenandCloseShiftPop(BuildContext context, String attid, String attstatus,int shiftstatus) {
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
                            onPressed: () async {
                              try {
                                await EmpClosesShift.empCloseShift(
                                    'emp_close_shift',
                                    widget.psid ?? 0,
                                    shiftstatus,
                                    attid,
                                    int.tryParse(attstatus) ?? 0);

                                await _fetchARecentActivity();
                                await employeeApiService.employeeList(
                                    context: context,
                                    deptid: widget.deptid ?? 1,
                                    processid: widget.processid ?? 0,
                                    psid: widget.psid ?? 0);

                                Navigator.pop(context);
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
                            child: const Text("Submit"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Go back")),
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
      [
      int? selectproblemid,
      int? problemcatagoryId,
      int? rootcauseid,
      String? reason,
      int?solutionid,
      int? problemStatusId,
      int? productionStopageid,
      int?ipdId,
      int?ipdincId,
      bool? showButton,
      String?closeStartTime
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
                      0.3, // Set the width to half of the screen
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set the height to full screen height
                  child: ProblemEntryPopup(
                    SelectProblemId: selectproblemid,
                    problemcatagoryId: problemcatagoryId,
                    reason: reason,
                    rootcauseid: rootcauseid,
                    showButton: showButton,
                    shiftFromTime: shiftFromTime,
                    shiftToTime: shiftToTime,
                    problemStatusId: problemStatusId,
                    solutionId: solutionid,
                    productionStopageId:productionStopageid,
                    ipdid: ipdId,
                    ipdincid:ipdincId ,
                    closestartTime: closeStartTime,

                  )),
            ),
          ),
        );
      },
    );
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
                    borderRadius: BorderRadius.circular(5.r)),
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
                            onPressed: () async {
                              try {
                                if (dropdownProduct != null &&
                                        dropdownProduct != 'Select' &&
                                        goodQController.text.isNotEmpty ||
                                    rejectedQController.text.isNotEmpty ||
                                    reworkQtyController.text.isNotEmpty) {
                                  await updateproduction(widget.processid);
                                  await empProductionEntryService
                                      .productionentry(
                                          context: context,
                                          pwsId: widget.pwsId ?? 0,
                                          deptid: widget.deptid ?? 0,
                                          psid: widget.psid ?? 0);

                                  await listofEmpworkstationService
                                      .getListofEmpWorkstation(
                                          context: context,
                                          deptid: widget.deptid ?? 0,
                                          psid: widget.psid ?? 0,
                                          processid: widget.processid ?? 1,
                                          pwsId: widget.pwsId ?? 0);
                                  // await productApiService.productList(
                                  //     context: context,
                                  //     id: widget.processid ?? 1,
                                  //     deptId: widget.deptid ?? 0);

                                  await recentActivityService.getRecentActivity(
                                      context: context,
                                      id: widget.pwsId ?? 0,
                                      deptid: widget.deptid ?? 0,
                                      psid: widget.psid ?? 0);

                                  await activityService.getActivity(
                                      context: context,
                                      id: widget.processid ?? 0,
                                      deptid: widget.deptid ?? 0,
                                      pwsId: widget.pwsId ?? 0);

                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>

                                  //     EmpWorkstationProductionEntryPage(
                                  //                       // empid: employee.empPersonid!,
                                  //                       processid: widget.processid ?? 1,
                                  //                       deptid: widget.deptid,
                                  //                       isload: true,
                                  //                       pwsid: widget.pwsId,
                                  //                       workstationName:widget.workstationName,
                                  //                       // attenceid:
                                  //                       //     employee.attendanceid,
                                  //                       // attendceStatus:
                                  //                       //     employee.flattstatus,
                                  //                       // shiftId: widget.shiftid,
                                  //                       psid: widget.psid,
                                  //                     ),

                                  // ));
                                }
                              } catch (error) {
                                // Handle and show the error message here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              }
                            },
                            child: const Text("Submit"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Go back")),
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
                      0.32, // Set the width to half of the screen
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set the height to full screen height
                  child: NonProductionActivityPopup(
                      shiftFromTime: shiftfromtime, shiftToTime: shiftTotime,showList: false,)),
            ),
          ),
        );
      },
    );
  }

  void _storeIncidentList() {
    final editIncidentList =
        Provider.of<EditIncidentListProvider>(context, listen: false)
            .user
            ?.editIncidentList;

    if (editIncidentList != null) {
      for (int i = 0; i < editIncidentList.length; i++) {
        ListOfWorkStationIncident data = ListOfWorkStationIncident(
          problemId: editIncidentList[i].incidentId,
            problemName: editIncidentList[i].incmName,
          problemcatagoryId: editIncidentList[i].subincidentId,
          problemCatagoryname: editIncidentList[i].subincidentName,
          reasons: editIncidentList[i].ipdincNotes,
          rootCauseId: editIncidentList[i].ipdincIncrcmId,
          rootCausename: editIncidentList[i].rootcauseName,
          endtime:editIncidentList[i].ipdincProblemEndTime ,
          fromtime: editIncidentList[i].fromTime,
          problemstatusId: editIncidentList[i].problemStatusId,
          productionStoppageId: editIncidentList[i].ipdincProductionStoppage,
          solutionId: editIncidentList[i].solId,
          ipdId: editIncidentList[i].ipdincIpdId,
          ipdIncId: editIncidentList[i].ipdincId
        );

        Provider.of<ListProblemStoringProvider>(context, listen: false)
            .addIncidentList(data);
      }
    }
  }



void empTimingUpdation(String startTime, String endTime) {
  DateTime fromDate =(startTime != null && startTime.isNotEmpty)
    ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTime)
    : DateTime.now();
  DateTime toDate = (endTime != null && endTime.isNotEmpty)
    ? DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTime)
    : DateTime.now();

  Duration timeoutDuration = toDate.difference(fromDate);
  int minutes = timeoutDuration.inMinutes;

  final listofempworkstation = Provider.of<ListofEmpworkstationProvider>(context, listen: false)
      .user
      ?.empWorkstationEntity;

  if (listofempworkstation != null && listofempworkstation.isNotEmpty) {
    setState(() {
      // Ensure empTimingTextEditingControllers has the correct number of controllers
      empTimingTextEditingControllers.clear();  // Clear previous controllers

      // Add controllers based on the length of listofempworkstation
      for (int i = 0; i < listofempworkstation.length; i++) {
        TextEditingController controller = TextEditingController();
        controller.text = minutes.toString();
        empTimingTextEditingControllers.add(controller);
      }
    });
  } else {
    print("listofempworkstation is null or empty");
  }
}



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final editEntry = Provider.of<EditEntryProvider>(context, listen: false)
        .editEntry
        ?.editEntry;

        // final nonProductionlist =
        // Provider.of<NonProductionStoredListProvider>(context, listen: true)
        //     ?.getNonProductionList;

// Access stored data and use it
final storedListOfProblem =
    Provider.of<ListProblemStoringProvider>(context, listen: true)
        .getIncidentList;

    final shiftFromtime =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftFromTime;

    final shiftStartDateTiming =
        '$currentYear-$currentMonth-$currentDay $shiftFromtime';

    final fromtime = editEntry?.ipdFromTime ;
    final totime = editEntry?.ipdToTime ;
                                    
    
    empTimingUpdation(fromtime ?? shiftStartDateTiming , totime ?? "");

    final totalGoodQty = editEntry?.totalGoodqty;
    final totalRejQty = editEntry?.totalRejqty;

        final listofempworkstation =
        Provider.of<EditEmpListProvider>(context, listen: false)
            .user
            ?.editEmplistEntity;

    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    print(editEntry);

    final activity = Provider.of<ActivityProvider>(context, listen: false)
        .user
        ?.activityEntity;

    final activityName =
        activity?.map((process) => process.paActivityName)?.toSet()?.toList() ??
            [];
    "";

    final processName = Provider.of<EmployeeProvider>(context, listen: false)
            .user
            ?.listofEmployeeEntity
            ?.first
            .processName ??
        "";
    // Set cardNo with the retrieved value

    // Update cardNo with the retrieved cardNumber

    // Assuming 1 means true // Assuming ipdid is an int

// final matchingProduct = productname?.firstWhere(
//   (product) => product.productid == (productionEntry?.ipdid ?? 0),

// );
// if (matchingProduct != null) {
//   dropdownProduct = matchingProduct.productName;
// }

 
 DateTime shiftStartTime=DateTime.parse(fromtime!);
    DateTime shiftEndtTime=DateTime.parse(totime!);

   final startTime = DateFormat('HH:mm:ss').format(shiftStartTime);
 

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
              // backgroundColor: Colors.grey.shade300,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text(
                  '${widget.workstationName}',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color.fromARGB(255, 45, 54, 104),
                automaticallyImplyLeading: true,
              ),
              body: SingleChildScrollView(
                child: Container(
                             
                 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: Colors.white,
                        ),
                  child: Column(
                    children: [
                      Form(
                        key: _formkey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          child: Column(
                            children: [
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(5.r),
                                child: Container(
                                  height: 86.h,
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromARGB(150, 235, 236, 255),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.r))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.w, right: 15.w, top: 5.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Text('Timing :',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 18.sp,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  '${fromtime?.substring(0, fromtime.length - 3) ?? ""}',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 18.sp,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text('to',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 18.sp,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                  ' ${totime?.substring(0, totime!.length - 3) ?? ""}',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 18.sp,
                                                      color: Colors.black54)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: CustomButton(
                                            width: 150,
                                            height: 50,
                                            onPressed: selectedName != null
                                                ? () {
                                                    if (_formkey.currentState
                                                            ?.validate() ??
                                                        false) {
                                                      // If the form is valid, perform your actions
                                                      print('Form is valid');
                                                      _submitPop(
                                                          context); // Call _submitPop function or perform actions here
                                                    } else {
                                                      // If the form is not valid, you can handle this case as needed
                                                      print(
                                                          'Form is not valid');
                                                      // Optionally, show an error message or handle the invalid case
                                                    }
                                                  }
                                                : null,
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Color(0xFF4CAF50),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              
                        Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      elevation: 3,
                                      borderRadius:
                                          BorderRadius.circular(5.r),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 8.w),
                                        width: 506.w,
                                        height: 270.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color.fromARGB(
                                              150, 235, 236, 255),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 15.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Card No',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
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
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          // CardNoScanner(
                                                          //   // empId: widget.empid,
                                                          //   // processId: widget.processid,
                                                          //   onCardDataReceived:
                                                          //       (scannedCardNo,
                                                          //           scannedProductName) {
                                                          //     setState(() {
                                                          //       cardNoController
                                                          //               .text =
                                                          //           scannedCardNo;
                                                          //       productNameController
                                                          //               .text =
                                                          //           scannedProductName;
                                                          //     });
                                                          //   },
                                                          // ),
                                                        ],
                                                      ),
                                                          SizedBox(height: 5.h,),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                          readOnly: true,
                                                          validation:
                                                              (value) {
                                                            if (value ==
                                                                    null ||
                                                                value
                                                                    .isEmpty) {
                                                              return 'Enter card No.';
                                                            } else if (RegExp(
                                                                    r'^0+$')
                                                                .hasMatch(
                                                                    value)) {
                                                              return 'Cannot contain zeros';
                                                            }
                                                            return null;
                                                          },
                        
                                                          controller:
                                                              cardNoController,
                                                          hintText:
                                                              'Card No ',
                                                          // Only digits allowed
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 50.h,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("Item Ref",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
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
                                                      SizedBox(height: 5.h,),
                                                      SizedBox(
                                                          width: 170.w,
                                                          height: 45.h,
                                                          child: Consumer<
                                                              ProductProvider>(
                                                            builder: (context,
                                                                productProvider,
                                                                child) {
                                                              final productList =
                                                                  productProvider
                                                                          .user
                                                                          ?.listofProductEntity ??
                                                                      [];
                        
                                                              return CustomNumField(
                                                                controller:
                                                                    productNameController,
                                                                hintText:
                                                                    'Item Ref',
                                                                      readOnly: true,
                                                                keyboardtype:
                                                                    TextInputType
                                                                        .streetAddress,
                                                                isAlphanumeric:
                                                                    true,
                                                                validation:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Enter a product name';
                                                                  }
                        
                                                                  // Convert product names in productList to lowercase for case-insensitive comparison
                                                                  final productListLowercase = productList
                                                                      .map((product) => product
                                                                          .productName
                                                                          ?.toLowerCase())
                                                                      .toList();
                        
                                                                  // Check if any product name matches the entered value (case-insensitive)
                                                                  final index =
                                                                      productListLowercase.indexWhere((productName) =>
                                                                          productName ==
                                                                          value.toLowerCase());
                        
                                                                  if (index !=
                                                                      -1) {
                                                                    // Product found, update the controller with product id
                                                                    final product =
                                                                        productList[
                                                                            index];
                                                                    product_Id =
                                                                        product
                                                                            .productid;
                                                                    return null; // Valid input
                                                                  } else {
                                                                    // Product not found
                                                                    return 'Product name not found';
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(width: 50.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Asset ID',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black54)),
                                                          SizedBox(
                                                              width: 8.w),
                                                          // ScanBarcode(
                                                          //   // empId: widget.empid,
                                                          //   pwsid:
                                                          //       widget.pwsId,
                                                          //   onCardDataReceived:
                                                          //       (scannedAssetId) {
                                                          //     setState(() {
                                                          //       assetCotroller
                                                          //               .text =
                                                          //           scannedAssetId;
                                                          //     });
                                                          //   },
                                                          // ),
                                                        ],
                                                      ),
                                                        SizedBox(
                                                            height:5.h ,
                                                          ),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                            readOnly: true,
                                                          controller:
                                                              assetCotroller,
                                                          hintText:
                                                              'Asset id',
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
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'Production Activity',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
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
                                                          SizedBox(
                                                              height: 40.h),
                                                        ],
                                                      ),
                                                      Container(
                                                          width: 170.w,
                                                          height: 45.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
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
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          2.h),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            hint: Text(
                                                                "Select"),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newvalue) async {
                                                              if (newvalue !=
                                                                  null) {
                                                                setState(() {
                                                                  activityDropdown =
                                                                      newvalue;
                                                                });
                        
                                                                final selectedActivity =
                                                                    activity
                                                                        ?.firstWhere(
                                                                  (activity) =>
                                                                      activity
                                                                          .paActivityName ==
                                                                      newvalue,
                                                                  orElse: () => ProcessActivity(
                                                                      paActivityName:
                                                                          "",
                                                                      mpmName:
                                                                          "",
                                                                      pwsName:
                                                                          "",
                                                                      paId: 0,
                                                                      paMpmId:
                                                                          0),
                                                                );
                        
                                                                if (selectedActivity !=
                                                                        null &&
                                                                    selectedActivity
                                                                            .paId !=
                                                                        null) {
                                                                  activityid =
                                                                      selectedActivity.paId ??
                                                                          0;
                        
                                                                  await targetQtyApiService
                                                                      .getTargetQty(
                                                                    context:
                                                                        context,
                                                                    paId:
                                                                        activityid ??
                                                                            0,
                                                                    deptid:
                                                                        widget.deptid ??
                                                                            1,
                                                                    psid:
                                                                        widget.psid ??
                                                                            0,
                                                                    pwsid:
                                                                        widget.pwsId ??
                                                                            0,
                                                                  );
                        
                                                                  final targetqty = Provider.of<TargetQtyProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .user
                                                                      ?.targetQty;
                        
                                                                  setState(
                                                                      () {
                                                                    targetQtyController
                                                                        .text = targetqty
                                                                            ?.targetqty
                                                                            ?.toString() ??
                                                                        '';
                                                                    achivedTargetQty =
                                                                        targetqty?.achivedtargetqty?.toString() ??
                                                                            "";
                                                                  });
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  activityDropdown =
                                                                      null;
                                                                  activityid =
                                                                      0;
                                                                });
                                                              }
                                                            },
                                                            items: activity
                                                                    ?.map(
                                                                      (activityName) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              selectedName = activityName.paActivityName;
                                                                            });
                                                                          },
                                                                          value:
                                                                              '${activityName.paActivityName}', // Append index to ensure uniqueness
                                                                          child:
                                                                              Text(
                                                                            activityName.paActivityName ?? "",
                                                                            style: TextStyle(
                                                                              color: Colors.black87,
                                                                              fontFamily: "lexend",
                                                                              fontSize: 16.sp,
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
                                                  SizedBox(width: 40.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Target Qty',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
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
                                                          SizedBox(
                                                            height: 40,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                          validation:
                                                              (value) {
                                                            if (value ==
                                                                    null ||
                                                                value
                                                                    .isEmpty) {
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
                                                  SizedBox(width: 50.w),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Rework',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black54)),
                                                          SizedBox(
                                                            width: 2.w,
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
                                                                  (newValue) {
                                                                setState(() {
                                                                  isChecked =
                                                                      newValue ??
                                                                          false;
                                                                  reworkValue =
                                                                      isChecked
                                                                          ? 1
                                                                          : 0;
                                                                });
                                                                print(
                                                                    "reworkvalue  ${reworkValue}");
                                                                // Perform any additional actions here, such as updating the database
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
 SizedBox(
                                                  height: 20.h,
                                                ),
                                               
                                            
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Expanded(
                                    child: Material(
                                      elevation: 3,
                                      borderRadius:
                                          BorderRadius.circular(5.r),
                                      child: Container(
                                        width: 506.w,
                                        height: 270.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          color: Color.fromARGB(
                                              150, 235, 236, 255),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 8.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Good Qty',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
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
                                                          SizedBox(
                                                            height: 40.h,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                          validation:
                                                              (value) {
                                                            if (value ==
                                                                    null ||
                                                                value
                                                                    .isEmpty) {
                                                              return 'Enter good qty';
                                                            } else if (RegExp(
                                                                    r'^0+$')
                                                                .hasMatch(
                                                                    value)) {
                                                              return 'Cannot contain zeros';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              goodQController,
                                                          isAlphanumeric:
                                                              true,
                                                          hintText:
                                                              'Good Quantity',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 45.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Rejected Qty',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
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
                                                          SizedBox(
                                                            height: 40.h,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                          validation:
                                                              (value) {
                                                            if (value ==
                                                                    null ||
                                                                value
                                                                    .isEmpty) {
                                                              return 'Enter Rejected qty';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              rejectedQController,
                                                          isAlphanumeric:
                                                              true,
                                                          hintText:
                                                              'Rejected Quantity',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 45.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Rework Qty',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
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
                                                          SizedBox(
                                                            height: 40.h,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 170.w,
                                                        height: 45.h,
                                                        child: CustomNumField(
                                                          validation:
                                                              (value) {
                                                            if (value ==
                                                                    null ||
                                                                value
                                                                    .isEmpty) {
                                                              return ' Enter rework qty';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              reworkQtyController,
                                                          isAlphanumeric:
                                                              true,
                                                          hintText:
                                                              'rework qty  ',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 170.w,
                                                    height: 70.h,
                                                    child: Column(
                                                      children: [
                                                        Text('Total Good Qty',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize:
                                                                    16.sp,
                                                                color: Colors
                                                                    .black54)),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Text(
                                                            "${totalGoodQty}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize:
                                                                    16.sp,
                                                                color: Colors
                                                                    .black87)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 45.w,
                                                  ),
                                                  SizedBox(
                                                    width: 170.w,
                                                    height: 70.h,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            'Total Rejected Qty',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize:
                                                                    16.sp,
                                                                color: Colors
                                                                    .black54)),
                        
                                                        SizedBox(
                                                            height: 10.h),
                        
                                                        Text("${totalRejQty}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize:
                                                                    16.sp,
                                                                color: Colors
                                                                    .black87)),
                        
                                                        // Text('  ${cardNo}' ?? "0"),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 45,
                                                  ),
                                                  SizedBox(
                                                    width: 170.w,
                                                    height: 70.h,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "Remaining Target",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize:
                                                                    16.sp,
                                                                color: Colors
                                                                    .black54)),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Text(
                                                          "${achivedTargetQty == null ? "0" : achivedTargetQty}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 10,),
                                               Row(
                                                        children: [
                                                        
                                                          SizedBox(
                                                                height: 50.h,
                                                                width: 170.w,
                                                                child: FloatingActionButton(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                mini: true,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.r)),
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    nonProductionActivityService
                                                                        .getNonProductionList(
                                                                      context:
                                                                          context,
                                                                    );
                                                                    _nonProductionActivityPopup(
                                                                        fromtime,
                                                                        totime
                                                                        );
                                                                  });

                                                                  // Update time after each change
                                                                },
                                                                child: Text("Non Productive Time")
                                                              )),
                                                        ],
                                                      ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        
                        
                        
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                 Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Employees",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: "Lexend",
                                                color: Color.fromARGB(
                                                    255, 80, 96, 203)),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            height: 76.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.r),
                                                    topRight:
                                                        Radius.circular(5.r)),
                                                color: Color.fromARGB(
                                                    255, 45, 54, 104)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 50.w,
                                                  child: Text('S.No',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 160.w,
                                                  child: Text('Employee',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                  Container(
                                                  alignment: Alignment.center,
                                                  width: 150.w,
                                                  child: Text('Work Timing',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 120.w,
                                                  child: Text('Attendence',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 130.w,
                                                  child: Text('Shift',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          (listofempworkstation != null &&
                                                  listofempworkstation
                                                      .isNotEmpty)
                                              ? Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          150, 235, 236, 255),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                  width: double.infinity,
                                                  height: 215.h,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        listofempworkstation
                                                            ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final data =
                                                          listofempworkstation?[
                                                              index];
                                                      
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                          color: index % 2 == 0
                                                              ? Colors
                                                                  .grey.shade50
                                                              : Colors.grey
                                                                  .shade100,
                                                        ),
                                                        height: 84.w,
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 50.w,
                                                              child: Text(
                                                                ' ${index + 1}  ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: 150.w,
                                                              child: Text(
                                                                data!.empName![0]!
                                                                            .toUpperCase() +
                                                                        data!
                                                                            .empName!
                                                                            .substring(
                                                                                1,
                                                                                data!.empName!.length -
                                                                                    1)
                                                                            .toLowerCase() +
                                                                        data!
                                                                            .empName!
                                                                            .substring(data!.empName!.length -
                                                                                1)
                                                                            .toUpperCase() ??
                                                                    '',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
  Container(
  alignment: Alignment.center,
  width: 150,
  height: 50, // Container height remains fixed
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 130,
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
          onChanged: (value) {
  // DateTime fromTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromtime!);
  // DateTime toTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastUpdatedTime!);
 fromMinutes = shiftEndtTime.difference(shiftStartTime).inMinutes;

            final enteredMinutes = int.tryParse(value) ?? -1;
      
            setState(() {
              if (enteredMinutes < 0 || enteredMinutes > fromMinutes!) {
                errorMessages[index] = 'Value b/w 0 to $fromMinutes minutes.';
              } else {
                errorMessages[index] = null; // Clear error message if valid
              }
            });
          },
          onEditingComplete: () {
            final value = empTimingTextEditingControllers[index].text;
            final enteredMinutes = int.tryParse(value) ?? -1;
      
            setState(() {
              if (enteredMinutes < 0 || enteredMinutes > fromMinutes!) {
                errorMessages[index] = 'Value 0 to $fromMinutes minutes.';
              } else {
                errorMessages[index] = null; // Clear error message if valid
              }
            });
          },
        ),
      ),
      // This space will display the error message but won't change the TextFormField size
      if (errorMessages[index] != null) 
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 2.0),
          child: Text(
            errorMessages[index]!,
            style: TextStyle(
              fontSize: 9.0, // Adjust the font size as needed
              color: Colors.red,
              height: 1.0, // Adjust the height to control spacing
            ),
          ),
        ),
    ],
  ),
),






                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 100.w,
                                                              child: Text(
                                                                ' ${data?.flAttStatus == 1 ? "Present" : "Absent"}  ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            if (data?.flAttShiftStatus ==
                                                                1)
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,

                                                                width: 130.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 120.w,
                                                                  height: 40.h,
                                                                  onPressed:
                                                                      () {
                                                                    _EmpOpenandCloseShiftPop(
                                                                        context,
                                                                        ' ${data?.flAttId ?? ''}  ',
                                                                        "${data?.flAttStatus ?? ""}",
                                                                        2);
                                                                  },
                                                                  child: Text(
                                                                      'Close Shift',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "lexend",
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color:
                                                                              Colors.white)),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ),

                                                                // else if (shiftstatus == 2)
                                                              )
                                                            else if (data
                                                                    ?.flAttShiftStatus ==
                                                                2)
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 180.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 120.w,
                                                                  height: 40.h,
                                                                  onPressed:
                                                                      () {
                                                                    _EmpOpenandCloseShiftPop(
                                                                        context,
                                                                        ' ${data?.flAttId ?? ''}  ',
                                                                        "${data?.flAttStatus ?? ""}",1);
                                                                  },
                                                                  child: Text(
                                                                      'Reopen',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "lexend",
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color:
                                                                              Colors.white)),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ),

                                                                // else if (shiftstatus == 2)
                                                              )
                                                            else
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 180.w,
                                                                child: Text('',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "lexend",
                                                                        fontSize: 16
                                                                            .sp,
                                                                        color: Colors
                                                                            .white)),
                                                                // else if (shiftstatus == 2)
                                                              ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          150, 235, 236, 255),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  width: double.infinity,
                                                  height: 258.h,
                                                  child: Center(
                                                    child: Text(
                                                        "No data available"),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),

                                  SizedBox(width: 10,),
                                   Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Container(
                                            height: 40.h,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Problems",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontFamily: "Lexend",
                                                      color: Color.fromARGB(
                                                          255, 80, 96, 203)),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: FloatingActionButton(
                                                    heroTag: 'Add Issue',
                                                    backgroundColor:
                                                        Colors.white,
                                                    tooltip: 'Add Issue',
                                                    mini: true,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                    onPressed: () async {
                                                      setState(() {
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
                                                                    
                                                                        assetid: int.parse(assetCotroller.text)
                                                                    );
                                          _problemEntrywidget(fromtime,totime);
                                                      });

                                                      // Update time after each change
                                                    },
                                                    child: const Icon(Icons.add,
                                                        color: Colors.black,
                                                        size: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Container(
                                          height: 76.h,
                                          width: 635.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5.r),
                                                topRight:
                                                    Radius.circular(5.r),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 45, 54, 104)),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100.w,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "S.No",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: "Lexend",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: 250.w,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Problem",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: "Lexend",
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: 250.w,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Problem Area",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: "Lexend",
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        (storedListOfProblem != null &&
                                                storedListOfProblem.isNotEmpty)
                                            ? Container(
                                                height:210  .h,
                                                width: 635.w,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        150, 235, 236, 255)),
                                                child: ListView.builder(
                                                  itemCount: storedListOfProblem
                                                      ?.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final incidentlist =
                                                        storedListOfProblem?[
                                                            index];
                        
                                                    final problemname=incidentlist?.problemName;
                                                    final problemcatagoryname=incidentlist?.problemCatagoryname;
                        
                                                    return GestureDetector(
                                                        onTap: () {
                                                          _problemEntrywidget(
                                                            incidentlist?.fromtime,
                                                              incidentlist?.endtime,
                                                              incidentlist?.problemId,
                                                              incidentlist?.problemcatagoryId,
                                                              incidentlist?.rootCauseId,
                                                              incidentlist?.reasons,
                                                              incidentlist?.solutionId,
                                                              incidentlist?.problemstatusId,
                                                              incidentlist?.productionStoppageId,
                                                              incidentlist?.ipdId ?? 0,
                                                              incidentlist?.ipdIncId ?? 0,
                                                               true,
                                                              incidentlist?.fromtime,
                                                              );
                                                        },
                                                      child: Container(
                                                        height: 86,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.grey
                                                                    .shade50
                                                                : Colors.grey
                                                                    .shade100),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 100.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "${index + 1}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontFamily:
                                                                        "Lexend",
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 270.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                problemname![0].toUpperCase() + problemname!.substring(1,problemname.length).toLowerCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontFamily:
                                                                        "Lexend",
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: 200.w,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                             problemcatagoryname![0].toUpperCase() + problemcatagoryname.substring(1,problemcatagoryname.length).toLowerCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontFamily:
                                                                        "Lexend",
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                             Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 50.w,
                                                                    child:
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                 storedListOfProblem.removeAt(index);
                                                                              });
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              color:
                                                                                  Colors.red,
                                                                            ))),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ))
                                            : Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        150, 235, 236, 255),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(8),
                                                            bottomRight:
                                                                Radius
                                                                    .circular(
                                                                        8))),
                                                height: 215.h,
                                                width: 635.w,
                                                child: Center(
                                                  child: Text(
                                                      "No data available"),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),


                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

    }