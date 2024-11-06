// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';
import 'package:prominous/constant/request_data_model/non_production_entry_model.dart';
import 'package:prominous/constant/request_data_model/workstation_entry_model.dart';
import 'package:prominous/constant/utilities/exception_handle/show_save_error.dart';
import 'package:prominous/features/presentation_layer/api_services/Editincidentlist_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_emp_list_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_nonproduction_lis_di.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_product_avilability_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/non_production_activity_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_location_di.dart';
import 'package:prominous/features/presentation_layer/provider/edit_emp_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/edit_incident_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/edit_nonproduction_provider.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/presentation_layer/api_services/edit_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofempworkstation_di.dart';
import 'package:prominous/features/presentation_layer/provider/edit_entry_provider.dart';
import 'package:prominous/features/presentation_layer/provider/edit_product_avilability_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/non_production_stroed_list_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_avilable_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_location_provider.dart';
import 'package:prominous/features/presentation_layer/widget/workstation_entry_widget/change_dateformate.dart';
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

class MobileProductionEditEntry extends StatefulWidget {
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

  MobileProductionEditEntry(
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
  State<MobileProductionEditEntry> createState() =>
      _MobileProductionEditEntryState();
}

class _MobileProductionEditEntryState extends State<MobileProductionEditEntry> {
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
  final ListofEmpworkstationService listofEmpworkstationService = ListofEmpworkstationService();

      ProductLocationService productLocationService=ProductLocationService();
        EditProductAvilableQtyService editProductAvilableQtyService=EditProductAvilableQtyService();
  FocusNode goodQtyFocusNode = FocusNode();
  FocusNode rejectedQtyFocusNode = FocusNode();
  FocusNode reworkFocusNode = FocusNode();
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


   String? fromtime;
   String? totime;
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
  late DateTime StartfromTime;
  late DateTime endTime;
  int? fromMinutes; 

  int ? overallqty ;
  int? avilableqty;
  int ?seqNo;
  int ?pcid;

  int?previousGoodValue; // Variable to store the previous value entered for Good Quantity
  int? previousRejectedValue;
  int?previousReworkValue; // Total minutes// Variable to track the error message
  String? errorMessage;
  String? rejectederrorMessage;
  String? reworkerrorMessage;
    String? locationDropdown;
  String?locationName;
  int? locationid;
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

        ipdCardNo: cardNoController.text,

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
        ipdareaid: 0,
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
            subincidentid: incident.problemCategoryId,
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
           final responsemsg=responseJson["response_msg"];

           if(responsemsg=="success"){
            return ShowSaveError.showAlert(context, "Saved Successfully","Success");
           }else{
            return ShowSaveError.showAlert(context,responsemsg.toString(),"Error");
           }
          } catch (e) {
            // Handle the case where the response body is not a valid JSON object
              return ShowSaveError.showAlert(context,e.toString(),"Error");
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
          final areaname=Provider.of<ProductLocationProvider>(context, listen: false)
          .user
          ?.itemProductionArea;


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

locationDropdown = null; // Set it to null initially

  if (EditproductionEntry?.ipdareaid != 0 && areaname != null) {
    for (var area in areaname!) {
      if (EditproductionEntry?.ipdareaid == area.ipaId) {
        locationDropdown = area.ipaName;
        break;
      }
    }
  }


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

    reworkValue ??= 0; 
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
     

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _storedNonProductionList();
    // });
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
      await editEntryApiservice.getEntryValues(
        context: context,
        psId:widget.psid ?? 0,
        ipdid:  widget.ipdid ?? 0,
        pwsId:  widget.pwsId?? 0,
        deptid: widget.deptid ?? 0,
      );
           
      await editIncidentListService.getIncidentList(
        context: context,
        ipdid: widget.ipdid ?? 0,
        deptid: widget.deptid ?? 0,
      );
      await editNonProductionListService.getNonProductionList(context:context , ipdid: widget.ipdid ?? 0);
     await editEmpListApiservice.getEditEmplist(context:context , ipdid: widget.ipdid ?? 0,psid: widget.psid ?? 0);

      await productApiService.productList(
          context: context,
          id: widget.processid ?? 1,
          deptId: widget.deptid ?? 0);

      await activityService.getActivity(
          context: context,
          id: widget.processid ?? 0,
          deptid: widget.deptid ?? 0,
          pwsId: widget.pwsId ?? 0);

                    await productLocationService.getAreaList(context: context);
                           final editEntry =
          Provider.of<EditEntryProvider>(context, listen: false)
              .editEntry
              ?.editEntry;

             fromtime = editEntry?.ipdFromTime ;
     totime = editEntry?.ipdToTime ;
    
              empTimingUpdation(fromtime! , totime!);
                _storeIncidentList();
                _storedNonProductionList();
     
  
 StartfromTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fromtime!);
 endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(totime!);
  fromMinutes = endTime.difference(StartfromTime).inMinutes ??0;
    // Initialize controllers and error messages based on list length
 
        final listofeditempworkstation =Provider.of<EditEmpListProvider>(context, listen: false)
            .user
            ?.editEmplistEntity;

      if(listofeditempworkstation !=null){
      for (int i = 0; i < listofeditempworkstation.length; i++) {
      empTimingTextEditingControllers.add(TextEditingController());
      errorMessages.add(null); // Initially no error
    }
      }


   
      // Access fetched data and set initial values
      final initialValue = editEntry?.ipdReworkFlag;

      if (initialValue != null) {
        setState(() {
          isChecked = initialValue == 1;
          goodQController.text = editEntry?.ipdGoodQty?.toString() ?? "";
          rejectedQController.text =
              editEntry?.ipdRejQty?.toString() ?? "";
          reworkQtyController.text =
              editEntry?.ipdReworkableQty.toString() ??
                  ""
                      ""; // Set isChecked based on initialValue
        });
      }
      // Update cardNo with the retrieved cardNumber
      // setState(() {
      //   cardNo = editEntry?.ipdcardno?.toString() ??"0"; // Set cardNo with the retrieved value
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

   void submitGoodQuantity() {
    final value = goodQController.text;
    final currentValue = int.tryParse(value) ?? 0;

    setState(() {
     if (currentValue > (overallqty ?? 0)) {
        errorMessage = 'Value must be between 0 and $overallqty.';
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
        rejectederrorMessage = 'Value must be between 0 and $overallqty.';
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
        reworkerrorMessage = 'Value must be between 0 and $overallqty.';
      } else {
        reworkerrorMessage = null;
        overallqty = (overallqty ?? 0) - currentValue;
        previousReworkValue = currentValue;
      }
    });
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
                               style: ElevatedButton.styleFrom(
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
                                Navigator.pop(context);
                              },
                              child:Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
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

                                  // await empProductionEntryService
                                  //     .productionentry(
                                  //         context: context,
                                  //         pwsId: widget.pwsId ?? 0,
                                  //         deptid: widget.deptid ?? 0,
                                  //         psid: widget.psid ?? 0);

                                  // await listofEmpworkstationService
                                  //     .getListofEmpWorkstation(
                                  //         context: context,
                                  //         deptid: widget.deptid ?? 0,
                                  //         psid: widget.psid ?? 0,
                                  //         processid: widget.processid ?? 1,
                                  //         pwsId: widget.pwsId ?? 0);
                                  // // await productApiService.productList(
                                  // //     context: context,
                                  // //     id: widget.processid ?? 1,
                                  // //     deptId: widget.deptid ?? 0);

                                  // await recentActivityService.getRecentActivity(
                                  //     context: context,
                                  //     id: widget.pwsId ?? 0,
                                  //     deptid: widget.deptid ?? 0,
                                  //     psid: widget.psid ?? 0);

                                  // await activityService.getActivity(
                                  //     context: context,
                                  //     id: widget.processid ?? 0,
                                  //     deptid: widget.deptid ?? 0,
                                  //     pwsId: widget.pwsId ?? 0);

                                
                                 

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
                                Navigator.pop(context);
                              },
                              child:Text("Cancel",style: TextStyle(fontFamily: "lexend",fontSize: 14.sp,color: Colors.white))),
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
      int? problemCategoryId,
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
          problemCategoryId: editIncidentList[i].subincidentId,
          problemCategoryname: editIncidentList[i].subincidentName,
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
  DateTime fromDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTime);
  DateTime toDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTime);

  Duration timeoutDuration = toDate.difference(fromDate);
  int minutes = timeoutDuration.inMinutes;

  final listofempworkstation = Provider.of<EditEmpListProvider>(context, listen: false)
      .user
      ?.editEmplistEntity;

  if (listofempworkstation != null) {
    setState(() {
      // Ensure empTimingTextEditingControllers has the correct number of controllers
      empTimingTextEditingControllers.clear();  // Clear previous controllers

      for (int i = 0; i <=listofempworkstation.length; i++) {
        TextEditingController controller = TextEditingController();
        controller.text = minutes.toString();
        empTimingTextEditingControllers.add(controller);
      }
    });
  } else {
    print("listofempworkstation is null");
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

    // final activityName =
    //     activity?.map((process) => process.paActivityName)?.toSet()?.toList() ??
    //         [];
    // "";

    // final processName = Provider.of<EmployeeProvider>(context, listen: false)
    //         .user
    //         ?.listofEmployeeEntity
    //         ?.first
    //         .processName ??
    //     "";


    
    final location =
        Provider.of<ProductLocationProvider>(context, listen: false)
            .user
            ?.itemProductionArea;

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
                toolbarHeight: 60.h,
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
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10.h, bottom:10.h),
                    child: Container(
                         decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                      child: Column(
                        children: [
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: Container(
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(150, 235, 236, 255),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.r))),
                                      child: Row(
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
                                              ' ${totime?.substring(0, totime!.length - 3)}',
                                              style: TextStyle(
                                                  fontFamily: "lexend",
                                                  fontSize: 16.sp,
                                                  color: Colors.black54)),
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
                                          padding:  EdgeInsets.only(top: 15.sp,bottom: 15.sp),
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
                                                            // CardNoScanner(
                                                            //   // empId: widget.empid,
                                                            //   // processId: widget.processid,
                                                            //   onCardDataReceived:
                                                            //       (scannedCardNo,
                                                            //           scannedProductName,itemd,cardid) {
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
                                                        SizedBox(
                                                          width: 150.w,
                                                          height: 50.h,
                                                          child: CustomNumField(
                                                                    readOnly: true,
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
                                                            hintText: 'Job Card',
                                                            // Only digits allowed
                                                          ),
                                                        )
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
                                                        SizedBox(
                                                            width: 150.w,
                                                            height: 50.h,
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
                                                                          readOnly: true,
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width: 1),
                                                                  ),
                                                                  focusedBorder:
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
                                                                  controller:
                                                                      productNameController,
                                                                  hintText:
                                                                      'Item Ref',
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
                                                                    final index = productListLowercase.indexWhere(
                                                                        (productName) =>
                                                                            productName ==
                                                                            value
                                                                                .toLowerCase());
                                                                      
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
                                                                      return 'Product not found';
                                                                    }
                                                                  },
                                                                );
                                                              },
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
                                                                fontSize: 16.sp,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            // ScanBarcode(
                                                            //   // empId: widget.empid,
                                                            //   pwsid: widget.pwsId,
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
                                                          width: 150.w,
                                                          height: 40.w,
                                                          child: CustomNumField(
                                                          readOnly: true,
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
                                                            controller:
                                                                assetCotroller,
                                                            hintText: 'Asset id',
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
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
                                                        Container(
                                                            width: 150.w,
                                                            height: 40.h,
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
                                          
                                                                          Provider.of<EditProductAvilableQtyProvider>(context,
                                                                                  listen: false)
                                                                              .reset();
                                          
                                                                          await editProductAvilableQtyService
                                                                              .getEditAvilableQty(
                                                                            context:
                                                                                context,
                                                                            reworkflag:
                                                                                reworkValue ?? 0,
                                                                            processid:
                                                                                widget.processid ?? 0,
                                                                            paid: activityid ??
                                                                                0,
                                                                            cardno:
                                                                                cardNoController.text, ipdid: widget.ipdid ?? 0,
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
                                                                                widget.pwsId ?? 0,
                                                                          );
                                          
                                                                          final targetqty = Provider.of<TargetQtyProvider>(context,
                                                                                  listen: false)
                                                                              .user
                                                                              ?.targetQty;
                                                                          final overallgoodQty = Provider.of<EditProductAvilableQtyProvider>(context,
                                                                                  listen: false)
                                                                              .user
                                                                              ?.editproductqty;
                                                                          if (overallgoodQty !=
                                                                              null) {
                                                                            print(
                                                                                'overallgoodQty list state: $overallgoodQty');
                                                                            avilableqty =
                                                                                Provider.of<EditProductAvilableQtyProvider>(context, listen: false).user?.editproductqty?.ipcwGoodQtyAvl ?? 0;
                                          
                                                                            final processSeq = Provider.of<EditProductAvilableQtyProvider>(context, listen: false)
                                                                                .user
                                                                                ?.editproductqty
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
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Enter good qty';
                                                                      } else if (RegExp(r'^0+$').hasMatch(value)) {
                                                                        return 'Cannot contain zeros';
                                                                      }
                                                                      return null; // Return null if no validation errors
                                                                    },
                                                                    controller: goodQController,
                                                                    focusNode: goodQtyFocusNode,
                                                                    isAlphanumeric: false,
                                                                    hintText: 'Good Quantity',
                                                enabled: (selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                
                                                                    onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1))?  (value) {
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
                                                                        } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0)!=0) {
                                                                          errorMessage = 'Value must be between 1 and $overallqty.';
                                                                        }else if ((overallqty ?? 0)==0) {
                                                                          errorMessage = 'Overallqty is 0 so enter 0';
                                                                        }  else {
                                                                          errorMessage = null; // Clear the error message if valid
                                                                        }
                                                                      });
                                                                    }:null
                                                                  ),
                                                                ),
                                                                if (errorMessage != null)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                                                                    child: Container(
                                                                      width: 140.w,
                                                                      height: 25.h,
                                                                      child: Text(
                                                                        errorMessage ?? "",
                                                                        style: TextStyle(
                                                                          fontSize: 9.w, // Adjust the font size as needed
                                                                          color: Colors.red,
                                                                          height: 1.0, // Adjust the height to control spacing
                                                                        ),
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
                                                                      if (value == null || value.isEmpty) {
                                                                        return 'Enter Rejected qty';
                                                                      }
                                                                      return null; // Return null if no validation errors
                                                                    },
                                                                    focusNode: rejectedQtyFocusNode,
                                                                    controller: rejectedQController,
                                                                    isAlphanumeric: false,
                                                                    hintText: 'Rejected Quantity',
                                                     enabled:(selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                    onChanged: (seqNo != 1 || (seqNo == 1 && reworkValue == 1)) ? (value) {
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
                                                                        } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0)!=0) {
                                                                          rejectederrorMessage = 'Value must be between 1 and $overallqty.';
                                                                        }else if ((overallqty ?? 0)==0) {
                                                                          rejectederrorMessage = 'Overallqty is 0 so enter 0';
                                                                        } else {
                                                                          rejectederrorMessage = null; // Clear the error message if valid
                                                                        }
                                                                      });
                                                                    }:null
                                                                  ),
                                                                ),
                                                                if (rejectederrorMessage != null)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                                                                    child: Container(
                                                                      width: 140.w,
                                                                      height: 25.h,
                                                                      child: Text(
                                                                        rejectederrorMessage ?? "",
                                                                        style: TextStyle(
                                                                          fontSize: 9.0, // Adjust the font size as needed
                                                                          color: Colors.red,
                                                                          height: 1.0, // Adjust the height to control spacing
                                                                        ),
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
                                                                    focusNode:
                                                                        reworkFocusNode,
                                                                    controller:
                                                                        reworkQtyController,
                                                                    isAlphanumeric:
                                                                        true,
                                                                    hintText:
                                                                        'rework qty  ',
                                                                           enabled:(selectedName != null &&
                                                                                  cardNoController.text.isNotEmpty &&
                                                                                  ((seqNo == 1 && reworkValue == 0) || (seqNo == 1 && reworkValue == 1 && avilableqty != 0) || (seqNo != 1 && avilableqty != 0) && avilableqty != null))
                                                                              ? true
                                                                              : false,
                                                                    onChanged:  (seqNo != 1 || (seqNo == 1 && reworkValue == 1)) ? (value) {
                                                                   final currentValue = int.tryParse(value) ?? 0;
                                                            
                                                                      setState(() {
                                                                        // Restore previous rejected value to overallqty if it was already subtracted
                                                                        if (previousReworkValue !=
                                                                            null) {
                                                                          overallqty =
                                                                              (overallqty ??
                                                                                      0) +
                                                                                  previousReworkValue!;
                                                                          previousReworkValue =
                                                                              null; // Reset the previous value after restoring
                                                                        }
                                                            
                                                                        // Validate the entered value against overallqty
                                                                           if (currentValue < 0) {
                                                                          reworkerrorMessage = 'Value must be greater than 0.';
                                                                        } else if (currentValue > (overallqty ?? 0) && (overallqty ?? 0)!=0) {
                                                                          reworkerrorMessage = 'Value must be between 1 and $overallqty.';
                                                                        }else if ((overallqty ?? 0)==0) {
                                                                          reworkerrorMessage = 'Overallqty is 0 so enter 0';
                                                                        } else {
                                                                          reworkerrorMessage =
                                                                              null; // Clear the error message if valid
                                                                        }
                                                                      });
                                                                    }: null
                                                                  ),
                                                                ),
                                                                if (reworkerrorMessage !=
                                                                    null)
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left: 8.0,
                                                                            top: 1.0),
                                                                    child: Container(
                                                                      width: 140.w,
                                                                      height: 25.h,
                                                                      child: Text(
                                                                        reworkerrorMessage ??
                                                                            "",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              9.0, // Adjust the font size as needed
                                                                          color:
                                                                              Colors.red,
                                                                          height:
                                                                              1.0, // Adjust the height to control spacing
                                                                        ),
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
                                                                  value: isChecked,
                                                                  activeColor:
                                                                      Colors.green,
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
                                                                                Provider.of<EditProductAvilableQtyProvider>(context, listen: false).reset();
                                          
                                                                            await editProductAvilableQtyService.getEditAvilableQty(
                                                            context: context,
                                                            reworkflag: reworkValue ?? 0,
                                                            processid: widget.processid ?? 0,
                                                            paid: activityid ?? 0,
                                                            cardno: cardNoController.text,
                                                            ipdid:widget.ipdid ?? 0
                                                          );
                                          
                                                                                final overallgoodQty = Provider.of<EditProductAvilableQtyProvider>(context, listen: false).user?.editproductqty;
                                          
                                                                                if (overallgoodQty != null) {
                                                                                  print('overallgoodQty list state: $overallgoodQty');
                                                                                  avilableqty = Provider.of<EditProductAvilableQtyProvider>(context, listen: false).user?.editproductqty?.ipcwGoodQtyAvl ?? 0;
                                          
                                                                                  final processSeq = Provider.of<EditProductAvilableQtyProvider>(context, listen: false).user?.editproductqty?.imfgpProcessSeq;
                                          
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
                                                      width: 10,
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
                                                                  child: Text("Non Productive Time",style: TextStyle(fontSize: 12.sp,fontFamily: "lexend",color: Colors.white)),)
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
                                              height: 50.h,
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
                                                        onPressed:
                                                            selectedName != null
                                                                ? () {
                                                                    if (_formkey
                                                                            .currentState
                                                                            ?.validate() ??
                                                                        false) {
                                                                      // If the form is valid, perform your actions
                                                                      print(
                                                                          'Form is valid');
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
                                                              fontFamily: "lexend",
                                                              fontSize: 12.sp,
                                                              color: Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                    )),

                                     Padding(
                                        padding:  EdgeInsets.only(top:5.sp,left:8.w,right: 8.w),
                                      child: Container(
                                        height: 30.h,
                                        child:   Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Employees",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontFamily: "Lexend",
                                                  color:
                                                      Color.fromARGB(255, 80, 96, 203)),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: Material(
                                    elevation: 3,
                                    child: Container(
                                      height: 200,
                                      width: 500,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(150, 235, 236, 255),
                                     borderRadius:   BorderRadius.only(
                                                      bottomLeft: Radius.circular(5.r),
                                                    bottomRight:
                                                          Radius.circular(5.r)),),
                                      child: (listofempworkstation == null || listofempworkstation.isEmpty) ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("No Records found",style: TextStyle(fontSize: 14.sp),),
                                              ],
                                            ):
                                      
                                      
                                      
                                       ListView.builder(
                               shrinkWrap: true,
                                                    itemCount:
                                                        listofempworkstation
                                                            ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final data =
                                                          listofempworkstation?[
                                                              index];
                        
                                            return  Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                     color:  index % 2 == 0
                                                          ? Color.fromARGB(
                                                              250, 235, 236, 255)
                                                          : Color.fromARGB(
                                                              10, 235, 236, 255),
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
                                                              width: 20.w,
                                                              child: Text(
                                                                ' ${index + 1}  ',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: 120.w,
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
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
Container(
  alignment: Alignment.center,
  width: 100.w,
  height: 50.h, // Container height remains fixed
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 90.w,
        height: 35.h, // Keep the size fixed for the TextFormField
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
//  fromMinutes = shiftEndtTime.difference(shiftStartTime).inMinutes;

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






                                                            // Container(
                                                            //   alignment:
                                                            //       Alignment
                                                            //           .center,
                                                            //   width: 100.w,
                                                            //   child: Text(
                                                            //     ' ${data?.flAttStatus == 1 ? "Present" : "Absent"}  ',
                                                            //     style: TextStyle(
                                                            //         fontFamily:
                                                            //             "lexend",
                                                            //         fontSize:
                                                            //             16.sp,
                                                            //         color: Colors
                                                            //             .black54),
                                                            //   ),
                                                            // ),
                                                            if (data?.flAttShiftStatus ==
                                                                1)
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,

                                                                width: 100.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 90.w,
                                                                  height: 35.h,
                                                                  onPressed:
                                                                      () {
                                                                    _EmpOpenandCloseShiftPop(
                                                                        context,
                                                                        ' ${data?.flAttId ?? ''}  ',
                                                                        "${data?.flAttStatus ?? ""}",
                                                                        2);
                                                                  },
                                                                  child: Text(
                                                                      'Close',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "lexend",
                                                                          fontSize: 12
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
                                                                width: 100.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 80.w,
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
                                                                          fontSize: 12
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
                                                                width: 100.w,
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



                                          }),
                                    ),
                                  ),
                                ),


                                    Padding(
                                      padding:  EdgeInsets.only(top:10.sp,left:8.w,right: 8.w,bottom: 5.sp),
                                      child: Container(
                                        height: 30.h,
                                        child:   Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            onPressed: () async {
                                              setState(() {
                                                listofproblemservice
                                                    .getListofProblem(
                                                        context: context,
                                                        processid:
                                                            widget.processid ?? 0,
                                                        deptid:
                                                            widget.deptid ?? 1057,
                                                            
                                                            
                                                                        assetid: int.parse(assetCotroller.text));
                                                _problemEntrywidget(fromtime,totime);
                                              });
                                  
                                              // Update time after each change
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  child: Material(
                                    elevation: 3,
                                    child: Container(
                                      height: 200,
                                      width: 500,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(150, 235, 236, 255),
                                           borderRadius:   BorderRadius.only(
                                                      bottomLeft: Radius.circular(5.r),
                                                    bottomRight:
                                                          Radius.circular(5.r)),),
                                      child: (storedListOfProblem!.isEmpty) ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("No Records found",style: TextStyle(fontSize: 14.sp),),
                                              ],
                                            ):
                                      
                                       ListView.builder(
                                          itemCount: storedListOfProblem?.length,
                                          itemBuilder: (context, index) {
                                            final item = storedListOfProblem?[index];
                                            return GestureDetector(
                                                        onTap: () {
                                                          _problemEntrywidget(
                                                            item?.fromtime,
                                                              item?.endtime,
                                                              item?.problemId,
                                                              item?.problemCategoryId,
                                                              item?.rootCauseId,
                                                              item?.reasons,
                                                              item?.solutionId,
                                                              item?.problemstatusId,
                                                              item?.productionStoppageId,
                                                              item?.ipdId ?? 0,
                                                              item?.ipdIncId ?? 0,
                                                               true,
                                                              item?.fromtime,
                                                              );
                                                        },
                                              child: Container(
                                                height: 80.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color:  index % 2 == 0
                                                          ? Color.fromARGB(
                                                              250, 235, 236, 255)
                                                          : Color.fromARGB(
                                                              10, 235, 236, 255),),
                                                child:  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.w, right: 8.w),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              fontFamily: "lexend",
                                                              fontSize: 14.sp,
                                                              color: Colors.black54),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          item?.problemName ?? "",
                                                          style: TextStyle(
                                                              fontFamily: "lexend",
                                                              fontSize: 12.sp,
                                                              color: Colors.black54),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: Text(
                                                          item?.problemCategoryname ?? "",
                                                          style: TextStyle(
                                                              fontFamily: "lexend",
                                                              fontSize: 12.sp,
                                                              color: Colors.black54),
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
                                              ),
                                            );
                                          }),
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
