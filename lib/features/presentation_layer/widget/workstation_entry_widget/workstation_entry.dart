// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:prominous/constant/utilities/exception_handle/show_save_error.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/presentation_layer/api_services/Workstation_problem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/card_no_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_catagory_di.dart';
import 'package:prominous/features/presentation_layer/api_services/non_production_activity_di.dart';
import 'package:prominous/features/presentation_layer/api_services/problem_status_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_avilable_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_location_di.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';

import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofempworkstation_di.dart';

import 'package:prominous/features/presentation_layer/api_services/listofproblem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofrootcause_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_stroed_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_avilable_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_location_provider.dart';
import 'package:prominous/features/presentation_layer/provider/workstation_problem_provider.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/edit_workstation_entry.dart';
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
import '../timing_widget/set_timing_widget.dart';
import 'package:intl/intl.dart';
import '../../../../constant/utilities/exception_handle/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../../../constant/utilities/customwidgets/customnum_field.dart';

class EmpWorkstationProductionEntryPage extends StatefulWidget {
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

  EmpWorkstationProductionEntryPage(
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
  State<EmpWorkstationProductionEntryPage> createState() =>
      _EmpProductionEntryPageState();
}

class _EmpProductionEntryPageState extends State<EmpWorkstationProductionEntryPage> {
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
  EditEntryApiservice editEntryApiservice = EditEntryApiservice();
  final CardNoApiService cardNoApiService = CardNoApiService();

  ProductAvilableQtyService productAvilableQtyService =ProductAvilableQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  FocusNode goodQtyFocusNode = FocusNode();
  FocusNode rejectedQtyFocusNode = FocusNode();
  FocusNode reworkFocusNode = FocusNode();
  FocusNode cardNoFocusNode = FocusNode();
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
  int? fromMinutes;
  int? overallqty;
  int? avilableqty;
  int? seqNo;
  int? pcid;

  DateTime? shiftStartTime;
  DateTime? shiftEndtTime;

  int? previousGoodValue; // Variable to store the previous value entered for Good Quantity
  int? previousRejectedValue;
  int?previousReworkValue; // Total minutes// Variable to track the error message
  String? errorMessage;
  String? rejectederrorMessage;
  String? reworkerrorMessage;
  String? itemerrorMessage;
 GlobalKey _updateTimeKey = GlobalKey();


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
            solutionId: incident.solutionId);
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
                  context, "Saved Successfully", "Success","Success",Colors.green);
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
        // If itemid is not 0, find the matching product name
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

    DateTime? shiftToTime;
    if (shifttodate != null && shifttodate.isNotEmpty) {
      // Parse shifttodate if it's not empty
      shiftToTime = DateTime.parse(shifttodate);
    } else if (shiftToTimeString != null) {
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

// Get the current time
    final currentTime = DateTime.now();

// Retrieve the shift start time
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

      // Adjust the date of shiftToTime if it falls on the next day
      if (shiftFromTime != null &&
          shiftToTime != null &&
          shiftToTime.isBefore(shiftFromTime)) {
        shiftToTime = shiftToTime.add(Duration(days: 1));
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
      if (currentValue > (overallqty ?? 0)) {
        errorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        errorMessage = null;
        overallqty = (overallqty ?? 0) - currentValue;
        previousGoodValue = currentValue;
      }
    });
  }

  void submitRejectedQuantity() {
    final value = rejectedQController.text;
    final currentValue = int.tryParse(value) ?? 0;

    setState(() {
      if (currentValue > (overallqty ?? 0)) {
        rejectederrorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        rejectederrorMessage = null;
        overallqty = (overallqty ?? 0) - currentValue;
        previousRejectedValue = currentValue;
      }
    });
  }

  void submitReworkQuantity() {
    final value = reworkQtyController.text;
    final currentValue = int.tryParse(value) ?? 0;

    setState(() {
      if (currentValue > (overallqty ?? 0)) {
        reworkerrorMessage = 'Value must be between 1 and $overallqty.';
      } else {
        reworkerrorMessage = null;
        overallqty = (overallqty ?? 0) - currentValue;
        previousReworkValue = currentValue;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    storedListOfProblem =
        Provider.of<ListProblemStoringProvider>(context, listen: false);

    nonProductionList =
        Provider.of<NonProductionStoredListProvider>(context, listen: false);

    // Safely trigger the state update after the widget build phase
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

    for (var controller in empTimingTextEditingControllers) {
      controller.dispose();
    }
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

      await workstationProblemService.getListofSolution(
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
        if(shiftendTime.hour<12){
           DateTime parsedShiftToDate = DateTime.parse(shifttodate!);
           shiftToTime=parsedShiftToDate.add(Duration(days: 1));
        }else{
         shiftToTime = DateTime.parse(shifttodate);
        }

      } else if (shiftToTimeString != null) {
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

// Get the current time
      final currentTime = DateTime.now();

// Retrieve the shift start time
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
          shiftToTime = shiftToTime.add(Duration(days: 1));
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

      Provider.of<ListProblemStoringProvider>(context, listen: false).reset();

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

  void _recentActivityList() {
    final productname = Provider.of<ProductProvider>(context, listen: false)
        .user
        ?.listofProductEntity;

    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    final nonProductionlist =
        Provider.of<NonProductionStoredListProvider>(context, listen: false);
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
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
                    0.4, // Set the width to half of the screen
                height: MediaQuery.of(context)
                    .size
                    .height, // Set the height to full screen height
                child: Drawer(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Color.fromARGB(150, 235, 236, 255),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Entry',
                            style: TextStyle(
                                fontSize: 24.sp,
                                color: Color.fromARGB(255, 80, 96, 203),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          (recentActivity != null && recentActivity.isNotEmpty)
                              ? Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: recentActivity?.length,
                                      itemBuilder: (context, index) {
                                        final data = recentActivity?[index];
                                        final totime = data?.ipdtotime;

                                        return Container(
                                          width: 300.w,
                                          height: 140.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border(
                                              top: (index == 0)
                                                  ? BorderSide(
                                                      width: 1,
                                                      color:
                                                          Colors.grey.shade300)
                                                  : BorderSide.none,
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.grey.shade300),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 25,
                                                        height: 25,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(22),
                                                          color: Color.fromARGB(
                                                              255, 80, 96, 203),
                                                        ),
                                                        child: Text(
                                                            '${index + 1}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Lexend')),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Job Card",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: Colors
                                                                      .black54)),
                                                          SizedBox(
                                                            width: 20.w,
                                                          ),
                                                          Text(
                                                              '${(data?.ipdcardno)}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      'Lexend')),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        nonProductionList.reset(
                                                            notify: false);
                                                        storedListOfProblem
                                                            .reset(
                                                                notify: false);

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditEmpProductionEntryPage(
                                                                deptid:
                                                                    data?.deptid ??
                                                                        1057,
                                                                empid:
                                                                    data?.ipdempid ??
                                                                        0,
                                                                isload: true,
                                                                processid:
                                                                    data?.processid ??
                                                                        0,
                                                                psid: data
                                                                    ?.ipdpsid,
                                                                ipdid:
                                                                    data?.ipdid,
                                                                attenceid: widget
                                                                    .attenceid,
                                                                attendceStatus:
                                                                    widget
                                                                        .attendceStatus,
                                                                pwsId: widget
                                                                    .pwsid,
                                                                workstationName:
                                                                    widget
                                                                        .workstationName,
                                                              ),
                                                            ));
                                                      },
                                                      icon: Icon(
                                                          Icons.edit_sharp,
                                                          color: Color.fromARGB(
                                                              255,
                                                              80,
                                                              96,
                                                              203))),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 40.sp),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Item Ref ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "lexend",
                                                                fontSize: 18.sp,
                                                                color: Colors
                                                                    .black54)),
                                                        SizedBox(
                                                          width: 20.w,
                                                        ),
                                                        Text(
                                                            '${(data?.ipditemid != 0 ? productname?.firstWhere(
                                                                  (product) =>
                                                                      data?.ipditemid ==
                                                                      product
                                                                          .productid,
                                                                ).productName : " ")}',
                                                            style: TextStyle(
                                                                fontSize: 16.sp,
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    'Lexend')),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 40.sp),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${totime?.toString().substring(0, totime.toString().length - 7)}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "lexend",
                                                            fontSize: 16.sp,
                                                            color: Colors
                                                                .black54)),
                                                    if (index == 0)
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                // updateproduction(widget.processid);
                                                                deletePop(
                                                                    context,
                                                                    data?.ipdid ??
                                                                        0,
                                                                    data?.ipdpsid ??
                                                                        0,
                                                                    data?.processid ??
                                                                        0,
                                                                    data?.ipdcardno ??
                                                                        0,
                                                                    data?.ipdpcid ??
                                                                        0,
                                                                    data?.ipdpaid ??
                                                                        0);
                                                              },
                                                              icon: SvgPicture
                                                                  .asset(
                                                                'assets/svg/trash.svg',
                                                                color:
                                                                    Colors.red,
                                                                width: 30,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if (index != 0)
                                                      SizedBox(
                                                          height: 30,
                                                          child: Text("")),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : Center(
                                  child: Text("No data available"),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _problemEntrywidget(String? shiftFromTime, String? shiftToTime,
      [int? selectproblemid,
      int? problemCategoryId,
      int? rootcauseid,
      String? reason,
      int? solutionid,
      int? problemStatusId,
      int? productionStopageid,
      int? ipdId,
      int? ipdincId,
      bool? showButton,
      String? closeStartTime,
      int? pwsid]) async {
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
                  child: ProblemEntryPopup(
                      SelectProblemId: selectproblemid,
                      problemCategoryId: problemCategoryId,
                      reason: reason,
                      rootcauseid: rootcauseid,
                      showButton: showButton,
                      shiftFromTime: shiftFromTime,
                      shiftToTime: shiftToTime,
                      problemStatusId: problemStatusId,
                      solutionId: solutionid,
                      productionStopageId: productionStopageid,
                      ipdid: ipdId,
                      ipdincid: ipdincId,
                      closestartTime: closeStartTime,
                      pwsId: pwsid)),
            ),
          ),
        );
      },
    );
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
                      shiftFromTime: shiftfromtime, shiftToTime: shiftTotime)),
            ),
          ),
        );
      },
    );
  }

  void _EmpOpenandCloseShiftPop(
      BuildContext context, String attid, String attstatus, int shiftstatus) {
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
                    const Text("Confirm your submission"),
                    const SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style:  ElevatedButton.styleFrom(
                            backgroundColor: Colors.green
                            ),
                            onPressed: () async {
                              try {
                                await EmpClosesShift.empCloseShift(
                                    'emp_close_shift',
                                    widget.psid ?? 0,
                                    shiftstatus,
                                    attid,
                                    int.tryParse(attstatus) ?? 0);
                                _fetchARecentActivity();
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
                            child: const Text("Submit",style: TextStyle(color: Colors.white),),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style:  ElevatedButton.styleFrom(
                            backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text("Cancel",style: TextStyle(color: Colors.white),)),
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
                                 Navigator.pop(context);
                                      
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
                            child: Text("Submit",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white),),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                          
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white)),)
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
           return ShowSaveError.showAlert(context, "Workstation Closed successfully","Success","Success",Colors.green);
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

  delete(
      {int? ipdid,
      int? ipdpsid,
      int? processid,
      String? cardno,
      int? pcid,
      int? paid}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final requestBody = DeleteProductionEntryModel(
        apiFor: "delete_entry_v1",
        clientAuthToken: token,
        ipdid: ipdid,
        ipdpsid: ipdpsid,
        pcid: pcid,
        cardno: cardno,
        processid: processid,
        paid: paid);
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
          // loadEmployeeList();
        
            final responseMsg = responseJson["response_msg"];
            print(responseJson);

            if (responseMsg == "success") {
              return ShowSaveError.showAlert(
                  context, "Deleted Successfully", "Success","Success",Colors.green);
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
                                      
                                  Navigator.pop(context);

                                  await updateproduction(widget.processid);
                                
                                   _WorkStationcloseapi();
                                 
                                }
                              } catch (error) {}
                            },
                            child: const Text("Submit",style: TextStyle(color: Colors.white,fontFamily: "lexend")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",style: TextStyle(color: Colors.white,fontFamily: "lexend"),)),
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

  void _storedWorkstationProblemList() {
    final workstationProblem =
        Provider.of<WorkstationProblemProvider>(context, listen: false)
            .user
            ?.resolvedProblemInWs;

    if (workstationProblem != null) {
      for (int i = 0; i < workstationProblem.length; i++) {
        ListOfWorkStationIncident data = ListOfWorkStationIncident(
            fromtime: workstationProblem[i].fromTime,
            endtime: workstationProblem[i].endTime,
            productionStoppageId: workstationProblem[i].productionStopageId,
            problemstatusId: workstationProblem[i].problemStatusId,
            problemsolvedName: workstationProblem[i].problemStatus,
            solutionId: workstationProblem[i].solId,
            solutionName: workstationProblem[i].solDesc,
            problemCategoryname: workstationProblem[i].subincidentName,
            problemId: workstationProblem[i].incidentId,
            problemName: workstationProblem[i].incidentName,
            problemCategoryId: workstationProblem[i].subincidentId,
            reasons: workstationProblem[i].ipdincNotes,
            rootCauseId: workstationProblem[i].ipdincIncrcmId,
            rootCausename: workstationProblem[i].incrcmRootcauseBrief,
            ipdId: workstationProblem[i].ipdincipdid,
            ipdIncId: workstationProblem[i].ipdincid);
        Provider.of<ListProblemStoringProvider>(context, listen: false)
            .addIncidentList(data);
      }
    }
  }

  void deletePop(
      BuildContext context, ipdid, ipdpsid, processid, cardno, pcid, paid) {
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
                                 Navigator.pop(context);
                        
                                await delete(
                                    ipdid: ipdid ?? 0,
                                    ipdpsid: ipdpsid ?? 0,
                                    processid: processid,
                                    cardno: cardno,
                                    pcid: pcid,
                                    paid: paid);
                                         
                              
                                
                                  
                                 _fetchARecentActivity();
                _updateTimeKey = GlobalKey(); // Change key to trigger rebuild
            

                          
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
                            child: const Text("Submit",style: TextStyle(color: Colors.white, fontFamily: "lexend")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                             style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                            ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel",style: TextStyle(color: Colors.white, fontFamily: "lexend"))),
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
              backgroundColor: Colors.grey.shade300,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
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
            _WorkStationcloseapi();

                      Navigator.pop(context);
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
                          fontSize: 24.sp),
                    ),
                    ScanWorkstationBarcode(
                      deptid: widget.deptid,
                      pwsid: widget.pwsid,
                      onCardDataReceived: (scannedBarcode) {
                        setState(() {
                          workstationBarcode = scannedBarcode;
                        });
                      },
                    )
                  ],
                ),
                backgroundColor: Color.fromARGB(255, 45, 54, 104),
                automaticallyImplyLeading: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
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
                                                    '${fromtime?.substring(0, fromtime!.length - 3)}',
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
                                                    ' ${lastUpdatedTime?.substring(0, lastUpdatedTime!.length - 3)}',
                                                    style: TextStyle(
                                                        fontFamily: "lexend",
                                                        fontSize: 18.sp,
                                                        color: Colors.black54)),
                                                SizedBox(
                                                  width: 30.w,
                                                ),
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
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                            child: CustomButton(
                                              width: 150.w,
                                              height: 50.h,
                                              onPressed: () {
                                                _WorkStationcloseShiftPop(
                                                    context);
                                              },
                                              child: Text('Close',
                                                  style: TextStyle(
                                                      fontFamily: "lexend",
                                                      fontSize: 16.sp,
                                                      color: Colors.white)),
                                              backgroundColor: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          SizedBox(
  height: 40.h,
  child: CustomButton(
    width: 150.w,
    height: 50.h,
    onPressed: selectedName != null &&
            locationDropdown != null &&
            assetCotroller.text.isNotEmpty
        ? () {
            if (_formkey.currentState?.validate() ?? false) {
              // If the form is valid, perform your actions
              print('Form is valid');

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
            } else {
              // Handle the invalid form case
              print('Form is not valid');
            }
          }
        : null,
    child: Text(
      'Submit',
      style: TextStyle(
        fontFamily: "lexend",
        fontSize: 16.sp,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.green,
    borderRadius: BorderRadius.circular(50),
  ),
),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                            child: CustomButton(
                                              width: 150.w,
                                              height: 50.h,
                                              onPressed: () {
                                                _recentActivityList();
                                              },
                                              child: Text(
                                                'Recent History',
                                                style: TextStyle(
                                                    fontFamily: "lexend",
                                                    fontSize: 16.sp,
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.green,
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
                                          height: 285.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color.fromARGB(
                                                150, 235, 236, 255),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w, vertical: 4.h),
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
                                                                'Job Card',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Text(
                                                                ' *',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 2.w,
                                                              ),
                                                              CardNoScanner(
                                                                // empId: widget.empid,
                                                                // processId: widget.processid,
                                                                onCardDataReceived:
                                                                    (scannedCardNo,
                                                                        scannedProductName,
                                                                        itemid,
                                                                        cardid) {
                                                                  setState(() {
                                                                    cardNoController
                                                                            .text =
                                                                        scannedCardNo;
                                                                    productNameController
                                                                            .text =
                                                                        scannedProductName;
                                                                    product_Id =
                                                                        itemid;
                                                                    pcid =
                                                                        cardid;
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Focus(
                                                            focusNode:
                                                                cardNoFocusNode,
                                                            onKey:
                                                                (node, event) {
                                                              if (event.logicalKey ==
                                                                      LogicalKeyboardKey
                                                                          .tab ||
                                                                  event.logicalKey ==
                                                                      LogicalKeyboardKey
                                                                          .enter) {
                                                                // Trigger the API call when the Tab or Enter key is pressed
                                                                cardNoApiService
                                                                    .getCardNo(
                                                                  context:
                                                                      context,
                                                                  cardNo: int.tryParse(
                                                                          cardNoController
                                                                              .text) ??
                                                                      0,
                                                                )
                                                                    .then((_) {
                                                                  final item = Provider.of<
                                                                              CardNoProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .user
                                                                      ?.scanCardForItem;

                                                                  if (item !=
                                                                      null) {
                                                                    product_Id =
                                                                        item.pcItemId;
                                                                    pcid = item
                                                                        .pcId;
                                                                    updateProductName(
                                                                        item.itemName ??
                                                                            "");

                                                                    // Move the focus to the Item Ref field
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            itemRefFocusNode);
                                                                  }
                                                                });
                                                              }
                                                              return KeyEventResult
                                                                  .ignored;
                                                            },
                                                            child: SizedBox(
                                                              width: 170.w,
                                                              height: 40.h,
                                                              child:
                                                                  CustomNumField(
                                                                controller:
                                                                    cardNoController,
                                                                hintText:
                                                                    'Card No',
                                                                keyboardtype:
                                                                    TextInputType
                                                                        .number,
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
                                                                enabled:
                                                                    reworkValue !=
                                                                        1,
                                                                onEditingComplete:
                                                                    () {
                                                                  final item = Provider.of<
                                                                              CardNoProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .user
                                                                      ?.scanCardForItem;

                                                                  if (item !=
                                                                      null) {
                                                                    product_Id =
                                                                        item.pcItemId;
                                                                    pcid = item
                                                                        .pcId;
                                                                    updateProductName(
                                                                        item.itemName ??
                                                                            "");

                                                                    // Move the focus to the Item Ref field
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            itemRefFocusNode);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(width: 50.h),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Item Ref",
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
                                                                height: 40),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 170,
                                                          height: 40,
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
                                                                          .circular(
                                                                              5),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  borderSide: BorderSide(
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
                                                            ScanBarcode(
                                                              // empId: widget.empid,
                                                              pwsid:
                                                                  widget.pwsid,
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
                                                        SizedBox(
                                                          width: 170.w,
                                                          height: 42.h,
                                                          child: CustomNumField(
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
                                                            hint:
                                                                Text("Select"),
                                                            isExpanded: true,
                                                            onChanged: (productNameController
                                                                        .text
                                                                        .isEmpty ||
                                                                    reworkValue ==
                                                                        1)
                                                                ? null
                                                                : (String?
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
                                                                              return;
                                                                            } else {
                                                                              ShowError.showAlert(context, "Rework Qty Not Avilable");
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
                                                                  },
                                                            items: activity?.map(
                                                                    (activityName) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        selectedName =
                                                                            activityName.paActivityName;
                                                                      });
                                                                    },
                                                                    value: activityName
                                                                        .paActivityName,
                                                                    child: Text(
                                                                      activityName
                                                                              .paActivityName ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontFamily:
                                                                            "lexend",
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList() ??
                                                                [],
                                                          ),
                                                        ),
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
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Row(
                                                  children: [],
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
                                          height: 280.h,
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
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.h),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 95,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Good Qty',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' *',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 8
                                                                      .h), // Space between label and input
                                                              SizedBox(
                                                                width: double
                                                                    .infinity, // Take full width
                                                                height: 45.h,
                                                                child:
                                                                    CustomNumField(
                                                                        validation:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Enter good qty';
                                                                          } else if (RegExp(r'^0+$').hasMatch(value)) {
                                                                            return 'Cannot contain zeros';
                                                                          }
                                                                          return null; // Return null if no validation errors
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
                                                                        onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1))
                                                                            ? (value) {
                                                                                final currentValue = int.tryParse(value) ?? 0; // Parse the entered value

                                                                                setState(() {
                                                                                  // Restore previous good value to overallqty if it was already subtracted
                                                                                  if (previousGoodValue != null) {
                                                                                    overallqty = (overallqty ?? 0) + previousGoodValue!;
                                                                                    previousGoodValue = null; // Reset the previous value after restoring
                                                                                  }

                                                                                  // Validate the entered value against overallqty
                                                                                  if (currentValue < 0) {
                                                                                    errorMessage = 'Value must be greater than 0.';
                                                                                  } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0) != 0) {
                                                                                    errorMessage = 'Value must be between 1 and $overallqty.';
                                                                                  } else if ((overallqty ?? 0) == 0) {
                                                                                    errorMessage = 'Overallqty is 0 so enter 0';
                                                                                  } else {
                                                                                    errorMessage = null; // Clear the error message if valid
                                                                                  }
                                                                                });
                                                                              }
                                                                            : null),
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
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        width: 45.w,
                                                      ),

                                                      // Column for Rejected Quantity
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 95,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Rejected Qty',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' *',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 8
                                                                      .h), // Space between label and input
                                                              SizedBox(
                                                                width: double
                                                                    .infinity, // Take full width
                                                                height: 45.h,
                                                                child:
                                                                    CustomNumField(
                                                                        validation:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Enter Rejected qty';
                                                                          }
                                                                          return null; // Return null if no validation errors
                                                                        },
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
                                                                                  } else if ((overallqty ?? 0) == 0) {
                                                                                    rejectederrorMessage = 'Overallqty is 0 so enter 0';
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
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 45.w,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 95,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Rework Qty',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "lexend",
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color:
                                                                              Colors.black54)),
                                                                  Text(
                                                                    ' *',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 8.h),
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 45.h,
                                                                child:
                                                                    CustomNumField(
                                                                        validation:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return ' Enter rework qty';
                                                                          }
                                                                          return null;
                                                                        },
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
                                                                                  } else if ((overallqty ?? 0) == 0) {
                                                                                    reworkerrorMessage = 'Overallqty is 0 so enter 0';
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
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 170.w,
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
                                                            Text('Holding Area',
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
                                                        SizedBox(
                                                          height: 5.h,
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
                                                                locationDropdown,
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
                                                            hint:
                                                                Text("Select"),
                                                            isExpanded: true,
                                                            onChanged: (String?
                                                                newvalue) async {
                                                              if (newvalue !=
                                                                  null) {
                                                                setState(() {
                                                                  locationDropdown =
                                                                      newvalue;
                                                                });

                                                                final selectedlocation =
                                                                    location?.firstWhere((location) =>
                                                                        location
                                                                            .ipaName ==
                                                                        newvalue);

                                                                if (selectedlocation !=
                                                                        null &&
                                                                    selectedlocation
                                                                            .ipaId !=
                                                                        null) {
                                                                  locationid =
                                                                      selectedlocation
                                                                              .ipaId ??
                                                                          0;
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  locationDropdown =
                                                                      null;
                                                                  locationid =
                                                                      0;
                                                                });
                                                              }
                                                            },
                                                            items: location?.map(
                                                                    (location) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        locationName =
                                                                            location.ipaName;
                                                                      });
                                                                    },
                                                                    value: location
                                                                        .ipaName,
                                                                    child: Text(
                                                                      location.ipaName ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                        fontFamily:
                                                                            "lexend",
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList() ??
                                                                [],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 45.w,
                                                    ),
                                                    SizedBox(
                                                        height: 70.h,
                                                        width: 170.w,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 20.0),
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
                                                                  child: Text(
                                                                    "Non Productive Time",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "lexend",
                                                                        fontSize: 14
                                                                            .sp,
                                                                        color: Colors
                                                                            .white),
                                                                  )),
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
                                                    topLeft:
                                                        Radius.circular(5.r),
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
                                                  child: Text('Working Minutes',
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
                                                  height: 240.h,
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
                                                                data!.personFname![0]!
                                                                            .toUpperCase() +
                                                                        data!
                                                                            .personFname!
                                                                            .substring(
                                                                                1,
                                                                                data!.personFname!.length -
                                                                                    1)
                                                                            .toLowerCase() +
                                                                        data!
                                                                            .personFname!
                                                                            .substring(data!.personFname!.length -
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 150,
                                                              height:
                                                                  50, // Container height remains fixed
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 130,
                                                                    height:
                                                                        35, // Keep the size fixed for the TextFormField
                                                                    child:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      controller:
                                                                          empTimingTextEditingControllers[
                                                                              index],
                                                                      decoration:
                                                                          InputDecoration(
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        contentPadding:
                                                                            EdgeInsets.all(5),
                                                                        hintText:
                                                                            "minutes",
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.black38,
                                                                            fontSize: 16),
                                                                        labelStyle:
                                                                            const TextStyle(fontSize: 12),
                                                                        constraints: BoxConstraints(
                                                                            maxHeight:
                                                                                40,
                                                                            maxWidth:
                                                                                100),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              BorderSide(color: Colors.grey.shade200),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              BorderSide(color: Colors.red.shade300),
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
                                                                              9.0, // Adjust the font size as needed
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
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 100.w,
                                                              child: Text(
                                                                ' ${data?.flattstatus == 1 ? "Present" : "Absent"}  ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            if (data?.flattshiftstatus ==
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
                                                                        ' ${data?.attendanceid ?? ''}  ',
                                                                        "${data?.flattstatus ?? ""}",
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
                                                                    ?.flattshiftstatus ==
                                                                2)
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
                                                                        ' ${data?.attendanceid ?? ''}  ',
                                                                        "${data?.flattstatus ?? ""}",
                                                                        1);
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
                                                  height: 240.h,
                                                  child: Center(
                                                    child: Text(
                                                        "No data available"),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
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
                                                    onPressed: assetCotroller.text.isNotEmpty ?() async {
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
                                                                assetid: int.parse(
                                                                    assetCotroller
                                                                        .text));

                                                        _problemEntrywidget(
                                                            fromtime,
                                                            lastUpdatedTime);
                                                      });

                                                      // Update time after each change
                                                    }:(){
                                                      ShowError.showAlert(context, "Enter the Asset Id", "Alert","Warning",Colors.orange);
                                                    },
                                                    child: const Icon(Icons.add,
                                                        color: Colors.black,
                                                        size: 20),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Container(
                                            height: 76.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.r),
                                                    topRight:
                                                        Radius.circular(5.r)),
                                                color: Color.fromARGB(
                                                    255, 45, 54, 104)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: 60.w,
                                                  child: Text('S.No',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 240.w,
                                                  child: Text('Problems',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 210.w,
                                                  child: Text(
                                                      'Problems Category',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 100.w,
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          (StoredListOfProblem.isNotEmpty)
                                              ? Container(
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
                                                  height: 240.h,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        StoredListOfProblem
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          StoredListOfProblem[
                                                              index];
                                                      return GestureDetector(
                                                        onTap:assetCotroller.text.isNotEmpty ? () {
                                                        
                                                          _problemEntrywidget(
                                                              item.fromtime,
                                                              lastUpdatedTime,
                                                              item.problemId,
                                                              item
                                                                  .problemCategoryId,
                                                              item.rootCauseId,
                                                              item.reasons,
                                                              item.solutionId,
                                                              item
                                                                  .problemstatusId,
                                                              item
                                                                  .productionStoppageId,
                                                              item.ipdId ?? 0,
                                                              item.ipdIncId ??
                                                                  0,
                                                              true,
                                                              fromtime,
                                                              widget.pwsid);
                                                        }:(){
ShowError.showAlert(context, "Enter the Asset Id", "Alert","Warning",Colors.orange);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors.grey
                                                                    .shade50
                                                                : Colors.grey
                                                                    .shade100,
                                                          ),
                                                          height: 84.w,
                                                          width:
                                                              double.infinity,
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
                                                              SizedBox(
                                                                width: 180.w,
                                                                child: Text(
                                                                  item!.problemName![
                                                                              0]
                                                                          .toUpperCase() +
                                                                      item!
                                                                          .problemName!
                                                                          .substring(
                                                                              1,
                                                                              item!.problemName?.length)
                                                                          .toLowerCase(),
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "lexend",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width: 170.w,
                                                                child: Text(
                                                                  item.problemCategoryname![
                                                                              0]
                                                                          .toUpperCase() +
                                                                      item!
                                                                          .problemCategoryname!
                                                                          .substring(
                                                                              1,
                                                                              item.problemCategoryname!.length)
                                                                          .toLowerCase(),
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
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 100.w,
                                                                  child:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              StoredListOfProblem.removeAt(index);
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
                                                  height: 240.h,
                                                  child: Center(
                                                    child: Text(
                                                        "No data available"),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
