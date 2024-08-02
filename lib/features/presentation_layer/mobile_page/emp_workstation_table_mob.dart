import 'dart:async';
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prominous/constant/request_data_model/workstation_change_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';

import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile%20widget/mob_production_entry.dart';

import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/request_data_model/send_attendence_model.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';



import '../../../constant/show_pop_error.dart';
import '../../data/core/api_constant.dart';

import '../provider/employee_provider.dart';

import '../widget/homepage_widget/employe_allocation_popup.dart';

class EmployeeWorkStationMobile extends StatefulWidget {
  // final int id;
  // final int shiftid;
  final int deptid;
  final int? psid;

  final Function? refreshCallback;

  const EmployeeWorkStationMobile({
    Key? key,
    // required this.id,
    // required this.shiftid,
    required this.deptid,
    this.refreshCallback,
    this.psid,
  }) : super(key: key);

  @override
  State<EmployeeWorkStationMobile> createState() =>
      _EmployeeWorkStationMobileState();
}

class _EmployeeWorkStationMobileState extends State<EmployeeWorkStationMobile> {
  EmployeeApiService employeeApiService = EmployeeApiService();
  AttendanceCountService attendanceCountService = AttendanceCountService();

  ListofworkstationService listofworkstationService =
      ListofworkstationService();

  late int? initialindex;
  bool isLoading = true;

  // void showEmployeeAllocationPopup(
  //     {int? empPersonid,
  //     int? processId,
  //     int? deptid,
  //     int? mfgpeId,
  //     String? attId}
  //     // int? shitid
  //     ) async {
  //   // Capture the valid context before the asynchronous operation
  //   final validContext = context;

  //   showDialog(
  //     context: validContext,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: EdgeInsets.all(20),
  //           width: 400,
  //           height: 500,
  //           decoration: BoxDecoration(color: Colors.white),
  //           child: EmployeeAllocationPopup(
  //             empId: empPersonid,

  //             processid: processId,
  //             //  shiftid: shitid,
  //             deptid: deptid,
  //             psid: widget.psid,
  //             attid: int.tryParse(attId ?? ""),
  //             mfgpeid: mfgpeId,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showEmployeeAllocationPopup(
      {int? empPersonid,
      int? processId,
      int? deptid,
      int? mfgpeId,
      String? attId}
      // int? shitid
      ) async {
    // Capture the valid context before the asynchronous operation
    final validContext = context;
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
                width: 250.w, // Set the width to half of the screen
                height: MediaQuery.of(context)
                    .size
                    .height, // Set the height to full screen height
                child: EmployeeAllocationPopup(
                  empId: empPersonid,

                  processid: processId,
                  //  shiftid: shitid,
                  deptid: deptid,
                  psid: widget.psid,
                  attid: int.tryParse(attId ?? ""),
                  mfgpeid: mfgpeId,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Load employee list initially
    // loadEmployeeList();
  }

  // Future<void> loadEmployeeList()  async{
  //   try {
  //     final int? process_id =
  //         Provider.of<ShiftStatusProvider>(context, listen: false)
  //             .user
  //             ?.shiftStatusdetailEntity
  //             ?.psMpmId;

  //     employeeApiService.employeeList(
  //         context: context,
  //         deptid: widget.deptid,
  //         processid: process_id ?? 0,
  //         psid: widget.psid ?? 0);

  //     setState(() {
  //       isLoading = true; // Set isLoading to false when data is fetched
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     // print('Error fetching asset list: $e');
  //     setState(() {
  //       isLoading = false; // Set isLoading to false even if there's an error
  //     });
  //   }
  // }

  // void loadEmployeeList() {
  //   employeeApiService.employeeList(context: context, id: widget.id);
  // }
  // void handleToggleAction(int index) async {
  //   await loadEmployeeList();
  // }

  Future<void> sendAttendance(int? index, String? attendanceid,
      int? empPersonid, String? flattdate, int? pwsId) async {
    final process_id = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .processId;
    final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;
    final shiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    final attdid = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .attendanceid;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    //DateTime today = DateTime(now.year, now.month, now.day);;

    int dt;

    dt = int.tryParse(attendanceid ?? "") ?? 0;

    final requestBody = SendAttendencereqModel(
        apiFor: "floor_attendance_v1",
        clientAuthToken: token,
        attId: dt,
        attStatus: index,
        deptId: widget.deptid,
        empid: empPersonid,
        processId: process_id,
        psid: widget.psid,
        shiftId: Shiftid,
        shiftStatus: shiftStatus,
        pwsId: pwsId);

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

  void _openWorkstationBottomSheet(int? processid) {
    final listofWorkstation =
        Provider.of<ListofworkstationProvider>(context, listen: false)
            .user
            ?.listOfWorkstation;

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
              height: 350.h,
              child: ListView.builder(
                itemCount: listofWorkstation?.length,
                itemBuilder: (context, index) {
                  final workstaion = listofWorkstation?[index];
                  return Padding(
                    padding:
                        EdgeInsets.only(top: 12.w, left: 12.w, right: 12.w),
                    child: Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(150, 235, 236, 255),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          //  SizedBox(width: 10.w, child: Text('${index + 1} ')),
                                          SizedBox(
                                              width: 120.w,
                                              child: Text(
                                                  workstaion?.pwsName ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "Lexend",
                                                    fontSize: 16.sp,
                                                    color: Color.fromARGB(
                                                        255, 80, 96, 203),
                                                  ))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100.w,
                                              child: Text(
                                                'No of Staff',
                                                style: TextStyle(
                                                    fontFamily: "Lexend",
                                                    fontSize: 14.sp,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${workstaion?.noOfStaff}  ',
                                              style: TextStyle(
                                                fontFamily: "lexend",
                                                fontSize: 14.sp,
                                                color: Color.fromARGB(
                                                    255, 80, 96, 203),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (workstaion?.noOfStaff != 0)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 20.w),
                                        child: Container(
                                            width: 90.w,
                                            height: 35.h,
                                            child: CustomButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MobileEmpWorkstationProductionEntryPage(
                                                      // empid: employee.empPersonid!,
                                                      processid: processid ?? 1,
                                                      deptid: widget.deptid,
                                                      isload: true,
                                                      pwsid: workstaion?.pwsId,
                                                      workstationName:
                                                          workstaion?.pwsName,
                                                      // attenceid:
                                                      //     employee.attendanceid,
                                                      // attendceStatus:
                                                      //     employee.flattstatus,
                                                      // shiftId: widget.shiftid,
                                                      psid: widget.psid,
                                                    ),
                                                  ),
                                                );
                                              },
                                              width: 40.w,
                                              height: 40.h,
                                              backgroundColor: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Text("Add",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "lexend",
                                                      fontSize: 12.sp)),
                                            )),
                                      ),
                                    ],
                                  )
                                else
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 20.w),
                                    child: Container(
                                        width: 100.w, child: Text("")),
                                  )
                              ]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  Future<void> _changeWorkstation(
      {int? pwesId,
      int? empPersonid,
      int? pwsId,
      int? attId,
      int? attstatus}) async {
    final process_id = Provider.of<EmployeeProvider>(context, listen: false)
        .user
        ?.listofEmployeeEntity
        ?.first
        .processId;
    final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";

    final requestBody = WorkstationChanges(
      clientAutToken: token,
      pwseempid: empPersonid,
      apiFor: "change_workstation_v1",
      pwsePwsId: pwsId,
      pwseId: pwesId,
      attid: attId,
      // flattstatus: attstatus
    );

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

  void _workstationPopup(
      {int? empPersonid,
      int? pwseId,
      int? processId,
      int? attid,
      int? attStatus}) {
    final listofWorkstation =
        Provider.of<ListofworkstationProvider>(context, listen: false)
            .user
            ?.listOfWorkstation;

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
                width: 250.w, // Set the width to half of the screen
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
                            'Select Workstation',
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Color.fromARGB(255, 80, 96, 203),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listofWorkstation?.length,
                              itemBuilder: (context, index) {
                                final workstation = listofWorkstation?[index];

                                return GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      top: (index == 0)
                                          ? BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300)
                                          : BorderSide.none,
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                    )), // Set unique background color for selected tile
                                    child: Text(
                                      "${workstation?.pwsName} ",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Lexend",
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                  onTap: () async {
                                    await _changeWorkstation(
                                      empPersonid: empPersonid,
                                      pwesId: pwseId,
                                      pwsId: workstation?.pwsId,
                                      attId: attid,
                                      // attstatus: attStatus ?? 0
                                    );
                                    await employeeApiService.employeeList(
                                        context: context,
                                        processid: processId ?? 0,
                                        deptid: widget.deptid ?? 1,
                                        psid: widget.psid ?? 0);

                                    await listofworkstationService
                                        .getListofWorkstation(
                                            context: context,
                                            deptid: widget.deptid ?? 1057,
                                            psid: widget.psid ?? 0,
                                            processid: processId ?? 0);

                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
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

  @override
  Widget build(BuildContext context) {
    final employeeResponse =
        Provider.of<EmployeeProvider>(context, listen: true)
            .user
            ?.listofEmployeeEntity;

    final listofWorkstation =
        Provider.of<ListofworkstationProvider>(context, listen: true)
            .user
            ?.listOfWorkstation;
    print(employeeResponse);
    final empid =
        employeeResponse?.isNotEmpty == true ? employeeResponse!.indexed : null;

    final int? process_id =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.psMpmId;
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Container(
        height: 300.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                width: 500.w,
                height: 225.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(150, 235, 236, 255),
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: employeeResponse?.length ?? 0,
                        itemBuilder: (context, index) {
                          final employee = employeeResponse![index];
                          DateTime now = DateTime.now();
                          String today = DateFormat('yyyy-MM-dd').format(now);
              
                          String? dt = employee.flattdate;
                          int? shiftstatus = employee?.flattshiftstatus;
                          initialindex = employee.flattstatus;
              
                          String? flattDate =
                              dt; // Parse dt to DateTime if not null
              
                          String attdate =
                              flattDate ?? ""; // Format flattDate if not null
              
                          return Container(
                            color: index % 2 == 0
                                ? Color.fromARGB(250, 235, 236, 255)
                                : Color.fromARGB(10, 235, 236, 255),
                            child: ExpansionTile(
                                shape: Border(bottom: BorderSide.none),
                                childrenPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 8.h),
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      child: Text('${index + 1}',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: "lexend",
                                              fontSize: 14.sp)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SizedBox(
                                      width: 150.w,
                                      child: Text(
                                          employee!.personFname![0]
                                                      .toUpperCase() +
                                                  employee!.personFname!
                                                      .substring(
                                                          1,
                                                          employee!.personFname!
                                                                  .length -
                                                              1)
                                                      .toLowerCase() +
                                                  employee!.personFname!
                                                      .substring(employee!
                                                              .personFname!
                                                              .length -
                                                          1)
                                                      .toUpperCase() ??
                                              '',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily: "lexend",
                                              fontSize: 14.sp)),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    if (initialindex == 0)
                                      SizedBox(
                                        width: 80.w,
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 100.w,
                                            child: CustomButton(
                                              child: Text(
                                                "Absent",
                                                style: TextStyle(
                                                    color: Colors.white,fontSize: 12.sp,fontFamily: "Lexend"),
                                              ),
                                              backgroundColor: Colors.red,
                                              height: 30.h,
                                              width: 80.w,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              onPressed: (employee
                                                          ?.pwsName?.isEmpty ??
                                                      true)
                                                  ? null
                                                  : () async {
                                                      await sendAttendance(
                                                          1,
                                                          employee?.attendanceid ??
                                                              "",
                                                          employee.empPersonid,
                                                          employee.flattdate,
                                                          employee.pwsId);
              
                                                      await employeeApiService
                                                          .employeeList(
                                                              context: context,
                                                              processid: employee
                                                                      .processId ??
                                                                  0,
                                                              deptid:
                                                                  widget.deptid ??
                                                                      1,
                                                              psid: widget.psid ??
                                                                  0);
                                                      await listofworkstationService
                                                          .getListofWorkstation(
                                                              context: context,
                                                              deptid:
                                                                  widget.deptid ??
                                                                      1057,
                                                              psid: widget.psid ??
                                                                  0,
                                                              processid: employee
                                                                      .processId ??
                                                                  0);
              
                                                      await attendanceCountService
                                                          .getAttCount(
                                                              context: context,
                                                              id: employee
                                                                      .processId ??
                                                                  0,
                                                              deptid:
                                                                  widget.deptid,
                                                              psid: widget.psid ??
                                                                  0);
                                                    },
                                            )),
                                      )
                                    else if (initialindex == 1)
                                      SizedBox(
                                        width: 80.w,
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 80.w,
                                            child: CustomButton(
                                              child: Text(
                                                "Present",
                                                style: TextStyle(
                                                    color: Colors.white,fontSize: 12.sp,fontFamily: "Lexend"),
                                              ),
                                              backgroundColor: Colors.green,
                                              height: 30.h,
                                              width: 80.w,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              onPressed: (employee
                                                          ?.pwsName?.isEmpty ??
                                                      true)
                                                  ? null
                                                  : () async {
                                                      await sendAttendance(
                                                          0,
                                                          employee?.attendanceid ??
                                                              "",
                                                          employee.empPersonid,
                                                          employee.flattdate,
                                                          employee.pwsId);
              
                                                      await employeeApiService
                                                          .employeeList(
                                                              context: context,
                                                              processid: employee
                                                                      .processId ??
                                                                  0,
                                                              deptid:
                                                                  widget.deptid ??
                                                                      1,
                                                              psid: widget.psid ??
                                                                  0);
                                                      await listofworkstationService
                                                          .getListofWorkstation(
                                                              context: context,
                                                              deptid:
                                                                  widget.deptid ??
                                                                      1057,
                                                              psid: widget.psid ??
                                                                  0,
                                                              processid: employee
                                                                      .processId ??
                                                                  0);
              
                                                      await attendanceCountService
                                                          .getAttCount(
                                                              context: context,
                                                              id: employee
                                                                      .processId ??
                                                                  0,
                                                              deptid:
                                                                  widget.deptid,
                                                              psid: widget.psid ??
                                                                  0);
                                                    },
                                            )),
                                      ),
                                  ],
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 120.w,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              //  showAnimatedDialog(context);
              
                                              _workstationPopup(
                                                empPersonid: employee.empPersonid,
                                                processId: employee.processId,
                                                pwseId: employee.pwseid,
                                                attid: int.tryParse(employee
                                                                .attendanceid
                                                                ?.isEmpty ??
                                                            true
                                                        ? '0'
                                                        : employee.attendanceid ??
                                                            '0') ??
                                                    0,
                                                attStatus: initialindex ?? 0,
                                              );
                                            },
                                            child: Text(
                                              (employee?.pwsName?.isEmpty ??
                                                      true)
                                                  ? "Select_WS"
                                                  : employee!.pwsName!,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 80, 96, 203),
                                                fontFamily: "lexend",
                                                fontSize: 12.sp,
                                              ),
                                            )),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 100.w,
                                        child: ElevatedButton(
                                          child: Text(
                                            "Reassign",
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          onPressed: initialindex == 0
                                              ? null
                                              : () {
                                                  setState(() {
                                                    showEmployeeAllocationPopup(
                                                      attId:
                                                          employee.attendanceid,
                                                      deptid:
                                                          widget.deptid ?? 0,
                                                      empPersonid:
                                                          employee.empPersonid,
                                                      mfgpeId:
                                                          employee.mfgpempid,
                                      
                                                      processId:
                                                          employee.processId,
                                      
                                                      // widget?.shiftid ??0,
                                                    );
                                                    employeeApiService
                                                        .employeeList(
                                                            context: context,
                                                            processid: employee
                                                                    .processId ??
                                                                0,
                                                            deptid: widget
                                                                    .deptid ??
                                                                1,
                                                            psid: widget.psid ??
                                                                0);
                                                  });
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
          Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                    color: Color.fromARGB(150, 235, 236, 255),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Workstation",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                              fontFamily: "Lexend")),
                      CustomButton(
                          width: 100.w,
                          height: 35.h,
                          borderRadius: BorderRadius.circular(50),
                          backgroundColor: Colors.green,
                          onPressed: () {
                            _openWorkstationBottomSheet(process_id);
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
          ],
        ),
      ),
    );
  }
}
