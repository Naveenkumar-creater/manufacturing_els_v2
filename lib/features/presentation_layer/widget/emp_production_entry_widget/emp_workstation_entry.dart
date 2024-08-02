// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
import 'package:prominous/constant/request_data_model/workstation_close_shift_model.dart';
import 'package:prominous/constant/request_data_model/workstation_entry_model.dart';
import 'package:prominous/constant/responsive/tablet_body.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/activity_model.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofempworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/scanforworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/edit_emp_production_details..dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_close_shift_widget.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/scanner_workstation_barcode.dart';
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
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_asset_barcode_scan.dart';
import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_cardno_barcode_scanner.dart';
import '../../api_services/product_di.dart';
import '../production_quanties/emp_production_time.dart';
import 'package:intl/intl.dart';
import '../../../../constant/show_pop_error.dart';
import '../../../data/core/api_constant.dart';
import '../../../../constant/utilities/customnum_field.dart';

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

class _EmpProductionEntryPageState
    extends State<EmpWorkstationProductionEntryPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController goodQController = TextEditingController();
  final TextEditingController rejectedQController = TextEditingController();
  final TextEditingController reworkQtyController = TextEditingController();
  final TextEditingController targetQtyController = TextEditingController();
  final TextEditingController batchNOController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController assetCotroller = TextEditingController();
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  final ActivityService activityService = ActivityService();
  final TargetQtyApiService targetQtyApiService = TargetQtyApiService();
  final EmpProductionEntryService empProductionEntryService =
      EmpProductionEntryService();
  final ListofEmpworkstationService listofEmpworkstationService =
      ListofEmpworkstationService();
  ListofworkstationService listofworkstationService =
      ListofworkstationService();
  AttendanceCountService attendanceCountService = AttendanceCountService();
   final List<Map<String, dynamic>>  incidentData = [];


  ActualQtyService actualQtyService = ActualQtyService();

  PlanQtyService planQtyService = PlanQtyService();

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
  String? workstationBarcode;

  TimeOfDay timeofDay = TimeOfDay.now();
  late DateTime currentDateTime;
  // Initialized to avoid null check

  List<Map<String, dynamic>> submittedDataList = [];

  String? dropdownProduct;
  String? activityDropdown;
  String? lastUpdatedTime;
  String? currentDate;
  int? reworkValue;
  int? productid;
  int? activityid;
  TimeOfDay? updateTimeManually;
  String? cardNo;
  String? productName;
  String? assetID;
  String? achivedTargetQty;

  EmployeeApiService employeeApiService = EmployeeApiService();

  Future<void> updateproduction(int? processid) async {
    final responsedata =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

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
        Provider.of<ListofEmpworkstationProvider>(context, listen: false)
            .user
            ?.empWorkstationEntity;

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

      final shiftFromtime =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      final shiftStartDateTiming =
          '$currentYear-$currentMonth-$currentDay $shiftFromtime';

      final fromtime = empproduction?.ipdfromtime == ""
          ? shiftStartDateTiming
          : empproduction?.ipdtotime;

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

        ipdCardNo: int.tryParse(cardNoController.text.toString()),

        ipdpaid: activityid ?? 0,
        ipdFromTime: fromtime,

        ipdToTime: lastUpdatedTime ?? currentDateTime,
        ipdDate: currentDateTime.toString(),
        ipdId: 0,
        // activityid == empproduction.ipdpaid ? empproduction.ipdid : 0,
        ipdPcId: pcid ?? empproduction.ipdpcid,
        ipdDeptId: widget.deptid ?? 1,
        ipdAssetId: int.tryParse(assetCotroller.text.toString()) ?? 0,
        //ipdcardno: empproduction.first.ipdcardno,
        ipdItemId: product_Id,
        ipdMpmId: processid,
        // emppersonId: widget.empid ?? 0,
        ipdpsid: widget.psid,
        ppid: ppId ?? 0,
        shiftid: Shiftid,
        listOfEmployeesForWorkStation: [],
        pwsid: widget.pwsid,
      );

      for (int index = 0; index < EmpWorkstation!.length; index++) {
        final empid = EmpWorkstation[index];

        final listofempworkstation =
            ListOfEmployeesForWorkStation(empId: empid.empPersonid ?? 0);
        workStationEntryReq.listOfEmployeesForWorkStation
            .add(listofempworkstation);
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
                            onPressed: () async {
                              try {
                                await workstationClose(
                                    processid: widget.processid,
                                    psid: widget.psid,
                                    pwsid: widget.pwsid);
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

                                Navigator.pop(context);
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
          // loadEmployeeList();
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
  }

  delete({
    int? ipdid,
    int? ipdpsid,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final requestBody = DeleteProductionEntryModel(
        apiFor: "delete_entry",
        clientAuthToken: token,
        ipdid: ipdid,
        ipdpsid: ipdpsid);
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
        assetCotroller.text = productionEntry?.ipdassetid?.toString() ?? "0";
        cardNoController.text = productionEntry?.ipdcardno?.toString() ?? "0";
        reworkQtyController.text =
            productionEntry?.ipdreworkableqty?.toString() ?? "0";
        // If itemid is not 0, find the matching product name
        productNameController.text = (productionEntry?.itemid != 0
            ? productname
                ?.firstWhere(
                  (product) => productionEntry?.itemid == product.productid,
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
    final shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;
    String? shiftTime;

    final shiftToTimeString =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftToTime;

    if (shiftToTimeString != null) {
      DateTime? shiftToTime;
      // Parse the shiftToTime
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

      // Get the current time
      final currentTime = DateTime.now();

      final shiftFromTimeString =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      if (shiftFromTimeString != null) {
        // Parse the shiftFromTime
        final shiftFromTimeParts = shiftFromTimeString.split(':');
        final shiftFromTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(shiftFromTimeParts[0]),
          int.parse(shiftFromTimeParts[1]),
          int.parse(shiftFromTimeParts[2]),
        );
// Check if shiftToTime is on the next day
        if (shiftToTime.isBefore(shiftFromTime)) {
          shiftToTime = shiftToTime.add(Duration(days: 1));
        }

        if (currentTime.isAfter(shiftFromTime) &&
            currentTime.isBefore(shiftToTime)) {
          // Current time is within the shift time
          final timeString =
              '$currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
          shiftTime = timeString;
        } else {
          // Current time exceeds the shift time
          print("Current time exceeds the shift time.");
          shiftTime = shiftToTimeString;
        }
      } else {
        print("shiftToTime is not available.");
        // Handle the case where shiftToTime is not available
      }
    }
// Assuming currentYear, currentMonth, and currentDay are defined earlier in your code

    lastUpdatedTime = '$currentYear-$currentMonth-$currentDay $shiftTime';
    currentDate =
        '$currentYear-$currentMonth-$currentDay $currentHour:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose text controllers
    targetQtyController.dispose();
    goodQController.dispose();
    rejectedQController.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

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

      final productionEntry =
          Provider.of<EmpProductionEntryProvider>(context, listen: false)
              .user
              ?.empProductionEntity;

      // Access fetched data and set initial values
      final initialValue = productionEntry?.ipdflagid;

      if (initialValue != null) {
        setState(() {
          isChecked = initialValue == 1;
          goodQController.text = productionEntry?.goodqty?.toString() ?? "";
          rejectedQController.text = productionEntry?.rejqty?.toString() ?? "";
          batchNOController.text = productionEntry?.ipdbatchno.toString() ??
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
                            onPressed: () async {
                              try {
                                if (dropdownProduct != null &&
                                        dropdownProduct != 'Select' &&
                                        goodQController.text.isNotEmpty ||
                                    rejectedQController.text.isNotEmpty ||
                                    reworkQtyController.text.isNotEmpty) {
                                  await updateproduction(widget.processid);
                                  await _fetchARecentActivity();
                                  Navigator.pop(context);
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

  void deletePop(BuildContext context, ipdid, ipdpsid) {
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
                                await delete(
                                    ipdid: ipdid ?? 0, ipdpsid: ipdpsid ?? 0);
                                await _fetchARecentActivity();
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

    final scannerPwsid =
        Provider.of<ScanforworkstationProvider>(context, listen: false)
            .user
            ?.workStationScanEntity
            ?.pwsId;

    final productionEntry =
        Provider.of<EmpProductionEntryProvider>(context, listen: false)
            .user
            ?.empProductionEntity;

    final totalGoodQty = productionEntry?.totalGoodqty;
    final totalRejQty = productionEntry?.totalRejqty;
    final productname = Provider.of<ProductProvider>(context, listen: false)
        .user
        ?.listofProductEntity;

    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    final listofempworkstation =
        Provider.of<ListofEmpworkstationProvider>(context, listen: false)
            .user
            ?.empWorkstationEntity;
    print(productionEntry);

    final shiftStartDateTiming =
        '$currentYear-$currentMonth-$currentDay $shiftFromtime';

    final fromtime = productionEntry?.ipdfromtime == ""
        ? shiftStartDateTiming
        : productionEntry?.ipdtotime;

    // final productname = Provider.of<ProductProvider>(context, listen: false)
    //     .user
    //     ?.listofProductEntity;

    final activity = Provider.of<ActivityProvider>(context, listen: false)
        .user
        ?.activityEntity;

    // final activityName = activity?.map((process) => process.paActivityName)?.toSet()?.toList() ??
    //         [];

    // final ProductNames =
    //     productname?.map((process) => process.productName)?.toSet()?.toList() ??
    //         [];
    // final asset = Provider.of<AssetBarcodeProvider>(context, listen: false)
    //     .user
    //     ?.scanAseetBarcode;

    // final cardNumber = Provider.of<CardNoProvider>(context, listen: false)
    //     .user
    //     ?.scanCardForItem;

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
                  child: Column(
                    children: [
                      Form(
                        key: _formkey,
                        child: Container(
                          height: 725.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.white,
                          ),
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
                                                    '${fromtime?.substring(0, fromtime.length - 3)}',
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
                                                  onTimeChanged: (time) {
                                                    setState(() {
                                                      lastUpdatedTime = time
                                                          .toString(); // Update the manually set time
                                                    });
                                                  },
                                                  shiftFromTime:
                                                      shiftFromtime ?? "",
                                                  shiftToTime:
                                                      shiftTotime ?? "",
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
                                              child: Text('Close Shift',
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
                                          height: 258.h,
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
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Row(
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
                                                              color: Colors.red,
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
                                                                    scannedProductName) {
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
                                                          SizedBox(
                                                            width: 12.w,
                                                          ),
                                                          SizedBox(
                                                            width: 150.w,
                                                            height: 40.h,
                                                            child:
                                                                CustomNumField(
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
                                                      )),
                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
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
                                                            SizedBox(
                                                                width: 26.w),
                                                            SizedBox(
                                                                width: 150.w,
                                                                height: 40.h,
                                                                child: Consumer<
                                                                    ProductProvider>(
                                                                  builder: (context,
                                                                      productProvider,
                                                                      child) {
                                                                    final productList =
                                                                        productProvider.user?.listofProductEntity ??
                                                                            [];

                                                                    return CustomNumField(
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
                                                                            value.isEmpty) {
                                                                          return 'Enter a product name';
                                                                        }

                                                                        // Convert product names in productList to lowercase for case-insensitive comparison
                                                                        final productListLowercase = productList
                                                                            .map((product) =>
                                                                                product.productName?.toLowerCase())
                                                                            .toList();

                                                                        // Check if any product name matches the entered value (case-insensitive)
                                                                        final index = productListLowercase.indexWhere((productName) =>
                                                                            productName ==
                                                                            value.toLowerCase());

                                                                        if (index !=
                                                                            -1) {
                                                                          // Product found, update the controller with product id
                                                                          final product =
                                                                              productList[index];
                                                                          product_Id =
                                                                              product.productid;
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text('Asset ID',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black54)),
                                                      SizedBox(width: 8.w),
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
                                                      SizedBox(width: 16.w),
                                                      SizedBox(
                                                        width: 150.w,
                                                        height: 40.w,
                                                        child: CustomNumField(
                                                          controller:
                                                              assetCotroller,
                                                          hintText: 'Asset id',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
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
                                                              width: 15.w,
                                                            ),
                                                            SizedBox(
                                                              width: 150.w,
                                                              height: 40.h,
                                                              child:
                                                                  CustomNumField(
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Activity',
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
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          SizedBox(width: 60.w),
                                                          Container(
                                                              width: 150.w,
                                                              height: 40.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius: BorderRadius
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
                                                                  contentPadding: EdgeInsets.symmetric(
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
                                                                isExpanded:
                                                                    true,
                                                                onChanged: (String?
                                                                    newvalue) async {
                                                                  if (newvalue !=
                                                                      null) {
                                                                    setState(
                                                                        () {
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

                                                                      await targetQtyApiService
                                                                          .getTargetQty(
                                                                        context:
                                                                            context,
                                                                        paId: activityid ??
                                                                            0,
                                                                        deptid:
                                                                            widget.deptid ??
                                                                                1,
                                                                        psid: widget.psid ??
                                                                            0,
                                                                        pwsid:
                                                                            widget.pwsid ??
                                                                                0,
                                                                      );

                                                                      final targetqty = Provider.of<TargetQtyProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .user
                                                                          ?.targetQty;

                                                                      setState(
                                                                          () {
                                                                        targetQtyController
                                                                            .text = targetqty?.targetqty
                                                                                ?.toString() ??
                                                                            '';
                                                                        achivedTargetQty =
                                                                            targetqty?.achivedtargetqty?.toString() ??
                                                                                "";
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
                                                                            return DropdownMenuItem<String>(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  selectedName = activityName.paActivityName;
                                                                                });
                                                                              },
                                                                              value: '${activityName.paActivityName}', // Append index to ensure uniqueness
                                                                              child: Text(
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
                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
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
                                                              width: 120.w,
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
                                                      ),
                                                    ],
                                                  ),
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
                                          height: 258.h,
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
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Good Qty',
                                                        style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Text(
                                                        ' *',
                                                        style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 48.w,
                                                      ),
                                                      SizedBox(
                                                        width: 150.w,
                                                        height: 40.h,
                                                        child: CustomNumField(
                                                          validation: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
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
                                                          isAlphanumeric: true,
                                                          hintText:
                                                              'Good Quantity',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                'Total Good Qty',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            SizedBox(
                                                              width: 85.w,
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
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text('Rejected Qty',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black54)),
                                                      Text(
                                                        ' *',
                                                        style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      SizedBox(
                                                        width: 150.w,
                                                        height: 40.h,
                                                        child: CustomNumField(
                                                          validation: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Enter Rejected qty';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              rejectedQController,
                                                          isAlphanumeric: true,
                                                          hintText:
                                                              'Rejected Quantity',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
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
                                                                width: 60.w),

                                                            Text(
                                                                "${totalRejQty}",
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
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Text('Rework Qty',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "lexend",
                                                              fontSize: 16.sp,
                                                              color: Colors
                                                                  .black54)),

                                                      Text(
                                                        ' *',
                                                        style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30.w,
                                                      ),
                                                      SizedBox(
                                                        width: 150.w,
                                                        height: 40.h,
                                                        child: CustomNumField(
                                                          validation: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return ' Enter rework qty';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              reworkQtyController,
                                                          isAlphanumeric: true,
                                                          hintText:
                                                              'rework qty  ',
                                                        ),
                                                      ),

                                                      // Text('Scrap Qty',
                                                      //                                                       style: TextStyle(
                                                      //                                                           fontSize: 17,
                                                      //                                                           color:
                                                      //                                                               Colors.black54)),
                                                      //                                                   SizedBox(
                                                      //                                                     width: 40,
                                                      //                                                   ),
                                                      //                                                   SizedBox(
                                                      //                                                     width: 150,
                                                      //                                                     height: 40,
                                                      //                                                     child: CustomNumField(
                                                      //                                                       controller:
                                                      //                                                           batchNOController,
                                                      //                                                       hintText: 'Scrap Qty  ',
                                                      //                                                     ),
                                                      //                                                   ),
                                                      SizedBox(
                                                        width: 30.w,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 8.h,
                                                            ),
                                                            Text(
                                                                "Remaining Target Qty",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54)),
                                                            SizedBox(
                                                                width: 30.w),
                                                            Text(
                                                              "${achivedTargetQty == null ? "0" : achivedTargetQty}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "lexend",
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
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
                                                  width: 100.w,
                                                  child: Text('S.No',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 190.w,
                                                  child: Text('Employee',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 150.w,
                                                  child: Text('Attendence',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 180.w,
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
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  width: double.infinity,
                                                  height: 262.h,
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
                                                              width: 100.w,
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
                                                              width: 180.w,
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
                                                              width: 150.w,
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

                                                                width: 180.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 120.w,
                                                                  height: 40.h,
                                                                  onPressed:
                                                                      () {
                                                                    _closeShiftPop(
                                                                        context,
                                                                        ' ${data?.attendanceid ?? ''}  ',
                                                                        "${data?.flattstatus ?? ""}");
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
                                                                width: 180.w,
                                                                child:
                                                                    CustomButton(
                                                                  width: 120.w,
                                                                  height: 40.h,
                                                                  onPressed:
                                                                      () {
                                                                    _EmpOpenShiftPop(
                                                                        context,
                                                                        ' ${data?.attendanceid ?? ''}  ',
                                                                        "${data?.flattstatus ?? ""}");
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

                                                      // Container(
                                                      //   alignment:
                                                      //       Alignment.center,
                                                      //   width: 150,
                                                      //   child: Text(
                                                      //     '  ${data?.ipdgoodqty ?? ''} ',
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .grey.shade900),
                                                      //   ),
                                                      // ),
                                                      // Container(
                                                      //   alignment:
                                                      //       Alignment.center,
                                                      //   width: 150,
                                                      //   child: Text(
                                                      //     '  ${data?.ipdrejqty ?? ''}',
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .grey.shade900),
                                                      //   ),
                                                      // ),
                                                      // Container(
                                                      //   alignment:
                                                      //       Alignment.center,
                                                      //   width: 150,
                                                      //   child: Text(
                                                      //     '  ${data?.ipdreworkflag == 0 ? 'NO' : "Yes"} ',
                                                      //     style: TextStyle(
                                                      //         color: Colors
                                                      //             .grey.shade900),
                                                      //   ),
                                                      // ),
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
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 76.h,
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.r),
                                                    topRight:
                                                        Radius.circular(5.r)),
                                                color: Color.fromARGB(
                                                    255, 45, 54, 104)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 100.w,
                                                  child: Text('S.No',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.white)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 150.w,
                                                  child: Text('Prev Time',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.white)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 140.w,
                                                  child: Text('Product',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.white)),
                                                ),
                                                // Container(
                                                //   alignment: Alignment.center,
                                                //   width: 150,
                                                //   child: Text('Good Qty',
                                                //       style: TextStyle(
                                                //           color: Colors.white)),
                                                // ),
                                                // Container(
                                                //   alignment: Alignment.center,
                                                //   width: 150,
                                                //   child: Text('Rejected Qty',
                                                //       style: TextStyle(
                                                //           color: Colors.white)),
                                                // ),
                                                // Container(
                                                //   alignment: Alignment.center,
                                                //   width: 150,
                                                //   child: Text('Rework ',
                                                //       style: TextStyle(
                                                //           color: Colors.white)),
                                                // ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 120.w,
                                                  child: Text('Edit',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.white)),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 120.w,
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          fontFamily: "lexend",
                                                          fontSize: 16.sp,
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          (recentActivity != null &&
                                                  recentActivity.isNotEmpty)
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
                                                  height: 265.h,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        recentActivity?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final data =
                                                          recentActivity?[
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
                                                        height: 80.h,
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: 100.w,
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 150.w,
                                                              child: Text(
                                                                ' ${data?.ipdtotime.toString().substring(0, data!.ipdtotime.toString().length - 4) ?? ''}  ',
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
                                                              width: 120.w,
                                                              child: Text(
                                                                '${(data?.ipditemid != 0 ? productname?.firstWhere(
                                                                      (product) =>
                                                                          data?.ipditemid ==
                                                                          product
                                                                              .productid,
                                                                    ).productName : " ")}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "lexend",
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                            // Container(
                                                            //   alignment:
                                                            //       Alignment.center,
                                                            //   width: 150,
                                                            //   child: Text(
                                                            //     '  ${data?.ipdgoodqty ?? ''} ',
                                                            //     style: TextStyle(
                                                            //         color: Colors
                                                            //             .grey.shade900),
                                                            //   ),
                                                            // ),
                                                            // Container(
                                                            //   alignment:
                                                            //       Alignment.center,
                                                            //   width: 150,
                                                            //   child: Text(
                                                            //     '  ${data?.ipdrejqty ?? ''}',
                                                            //     style: TextStyle(
                                                            //         color: Colors
                                                            //             .grey.shade900),
                                                            //   ),
                                                            // ),
                                                            // Container(
                                                            //   alignment:
                                                            //       Alignment.center,
                                                            //   width: 150,
                                                            //   child: Text(
                                                            //     '  ${data?.ipdreworkflag == 0 ? 'NO' : "Yes"} ',
                                                            //     style: TextStyle(
                                                            //         color: Colors
                                                            //             .grey.shade900),
                                                            //   ),
                                                            // ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 120.w,
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EditEmpProductionEntryPage(
                                                                          deptid:
                                                                              data?.deptid ?? 1057,
                                                                          empid:
                                                                              data?.ipdempid ?? 0,
                                                                          isload:
                                                                              true,
                                                                          processid:
                                                                              data?.processid ?? 0,
                                                                          psid:
                                                                              data?.ipdpsid,
                                                                          ipdid:
                                                                              data?.ipdid,
                                                                          attenceid:
                                                                              widget.attenceid,
                                                                          attendceStatus:
                                                                              widget.attendceStatus,
                                                                          pwsId:
                                                                              widget.pwsid,
                                                                          workstationName:
                                                                              widget.workstationName,
                                                                        ),
                                                                      ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .mode_edit_outline_outlined,
                                                                    size: 25,
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                            if (index == 0)
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 120,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // updateproduction(widget.processid);
                                                                    deletePop(
                                                                        context,
                                                                        data?.ipdid ??
                                                                            0,
                                                                        data?.ipdpsid ??
                                                                            0);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 25,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            if (index != 0)
                                                              Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 120.w,
                                                                  child:
                                                                      Text("")),
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
                                    )
                                  ],
                                ),
                              ],
                            ),
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
