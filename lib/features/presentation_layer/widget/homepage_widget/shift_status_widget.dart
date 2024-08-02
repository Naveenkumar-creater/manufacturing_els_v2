import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prominous/constant/request_data_model/close_shift_req_model.dart';
import 'package:prominous/constant/request_data_model/shift_status_model.dart';
import 'package:prominous/constant/show_pop_error.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/shift_status_di.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';

class ShitStatusWidget extends StatefulWidget {
  final int? deptid;
  final int? processid;
  final int? shiftgroupid;
  final int? psid;
  const ShitStatusWidget(
      {super.key,
      required this.deptid,
      required this.processid,
      this.shiftgroupid,
      required this.psid});

  @override
  State<ShitStatusWidget> createState() => _ProcessQtyWidgetState();
}

class _ProcessQtyWidgetState extends State<ShitStatusWidget> {
  late Stream<String> current;

  ShiftStatusService shiftStatusService = ShiftStatusService();
  EmployeeApiService employeeApiService = EmployeeApiService();
    AttendanceCountService attendanceCountService = AttendanceCountService();
    ActualQtyService actualQtyService =ActualQtyService();
  PlanQtyService planQtyService=PlanQtyService();
   ListofworkstationService listofworkstationService=ListofworkstationService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _fetchActualQty();
    current = Stream<String>.periodic(Duration(seconds: 1), (i) {
      final DateTime now = DateTime.now();
      return '${now.day}-${now.month}-${now.year}  ${now.hour}: ${now.minute}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  // Future<void> _fetchActualQty() async {
  //   try {
  //     await shiftStatusService.getShiftStatus(
  //         context: context, deptid: widget.deptid, processid: widget.processid);
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

void closeShiftPop(BuildContext context) async {
  final employeeResponse = await Provider.of<EmployeeProvider>(context, listen: false)
      .user
      ?.listofEmployeeEntity;

print(employeeResponse);
  // Check if all elements have fl_att_status == 0 and fl_att_shift_status == 0
  bool allMatchCondition = employeeResponse?.every((employee) =>
      employee.flattstatus == 0 && employee.flattshiftstatus == 0) ?? false;

// final employees = employeeResponse
//       ?.where((employee) => employee.flattstatus == 0)
//       .toList();
//   // Check if all elements have fl_att_status == 0 and fl_att_shift_status == 1 and employee.flpsid == widget.psid
//   bool allMatchFirstCondition = employees?.any((employee) =>
//        employee.flattshiftstatus == 1) ?? false;

  // Log the results for debugging
  print("allMatchCondition: $allMatchCondition");
  // print("allMatchFirstCondition: $allMatchFirstCondition");

  // Filter elements with fl_att_status == 1 and fl_att_shift_status == 1
  final employeesWithFlattstatus1AndFlattshiftstatus1 = employeeResponse
      ?.where((employee) =>
          employee.flattstatus == 1 && employee.flattshiftstatus == 1)
      .toList();

  // Filter elements with fl_att_status == 1
  final employeesWithFlattstatus1 = employeeResponse
      ?.where((employee) => employee.flattstatus == 1 && employee.flattshiftstatus == 2)
      .toList();

  // Check if all elements with fl_att_status == 1 have fl_att_shift_status == 2
  bool allSatisfySecondCondition = employeesWithFlattstatus1
      ?.every((employee) => employee.flattstatus == 1 && employee.flattshiftstatus == 2) ?? false;

  print("allSatisfySecondCondition: $allSatisfySecondCondition");
  // Display the dialog based on the conditions
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: Colors.white,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (allMatchCondition)
                      Column(
                        children: [
                          Text(
                            'Note - "At least one employee should be present on the floor to close the shift."',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Retry", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    // else if (allMatchFirstCondition)
                    //   Column(
                    //     children: [
                    //       Text(
                    //         'Note - "At least one employee should be present on the floor to close the shift."',
                    //         style: TextStyle(
                    //           fontStyle: FontStyle.italic,
                    //           color: Colors.red,
                    //         ),
                    //       ),
                    //       SizedBox(height: 32),
                    //       ElevatedButton(
                    //         onPressed: () {
                    //           Navigator.of(context).pop(); // Close the dialog
                    //         },
                    //         child: Text("Retry", style: TextStyle(color: Colors.red)),
                    //       ),
                    //     ],
                    //   )
                    else if (employeesWithFlattstatus1AndFlattshiftstatus1 != null &&
                             employeesWithFlattstatus1AndFlattshiftstatus1.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Note - "The supervisor\'s shift can only be closed once all employee shifts have been completed."',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            ),
                          ),
                          Container(
                            height: 400,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: employeesWithFlattstatus1AndFlattshiftstatus1.length,
                              itemBuilder: (context, index) {
                                final employee = employeesWithFlattstatus1AndFlattshiftstatus1[index];
                                return Container(
                                  height: 45,
                                  child: Row(
                                    children: [
                                      Text(
                                        "${index + 1}. ${employee?.personFname}",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    else if (allSatisfySecondCondition == true)
                      Column(
                        children: [
                          Text(
                            'Note - "Shifts of all present employees are closed, continue closing the shift."',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () async {
                              // Using a separate variable to manage loading state within this function
                              bool isLoading = true;
        
                              try {
                                // Perform all asynchronous operations
                                await closeShift();
                                await shiftStatusService.getShiftStatus(
                                  context: context,
                                  deptid: widget.deptid,
                                  processid: widget.processid,
                                );
        
                                await employeeApiService.employeeList(
                                  context: context,
                                  deptid: widget.deptid ?? 1,
                                  processid: widget.processid ?? 0,
                                  psid: widget.psid ?? 0,
                                );
                               await listofworkstationService.getListofWorkstation(context: context, deptid: widget.deptid ?? 1057, psid: widget.psid ?? 0, processid: widget.processid ?? 0);
        
                                
                                  await actualQtyService.getActualQty(context: context, id: widget.processid??0,psid: 0);
                                     attendanceCountService.getAttCount(
                                      context: context,
                                      id: widget.processid ?? 0,
                                      deptid: widget.deptid ??0,
                                      psid: widget.psid ?? 0);
        
              await planQtyService.getPlanQty(context: context, id: widget.processid ??0, psid: widget.psid ??0 );
              await actualQtyService.getActualQty(context: context, id: widget.processid??0,psid: widget.psid ??0);
        
                                Navigator.of(context).pop();
                              } catch (e) {
                                // Handle any errors that occur during the async operations
                                print('Error: $e');
                              } finally {
                                isLoading = false; // Indicate completion
                                // Update any other state variables as needed
                              }
                            },
                            child: Text("Close Shift", style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Text(
                            'Note - "The supervisor\'s shift can only be closed once all employee shifts have been completed."',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Retry", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}


  Future<void> closeShift() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final psId = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psId;

    final requestBody = CloseShift(
        apiFor: "close_shift",
        clientAuthToken: token,
        psid: psId,
        ShiftStatus: 2);
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

  Future<void> openShift() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";

    final requestBody = ShiftStatusreqModel(
        apiFor: "update_shift_status",
        clientAuthToken: token,
        deptId: widget.deptid,
        processId: widget.processid,
        psid: 0,
        shiftgroupId: widget.shiftgroupid);
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

  @override
  Widget build(BuildContext context) {
    final ShiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftStatus;
    final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
        .user
        ?.shiftStatusdetailEntity
        ?.psShiftId;

        Size size=MediaQuery.of(context).size;

    //  int? achivedProduct=;

    return Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
      child: Container(
      width: 506.w,
      height: 86.h,
        decoration: BoxDecoration(
           color: Color.fromARGB(150, 235, 236, 255), 
       
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<String>(
              stream: current,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: TextStyle(
                   color: Colors.black87,fontFamily: "Lexend",fontSize: 20.sp)
                  );
                } else
                  return Text(
                    'Loading',
                    style: TextStyle(fontSize: 18.sp, color: Colors.black54),
                  );
              },
            ),
            SizedBox(
              width: 8.w,
            ),
            ShiftStatus == 1
                ? Text('Shift ID:${Shiftid}',
                    style: TextStyle(color: Colors.black87,fontFamily: "Lexend",fontSize: 22.sp))
                : Text('No Shift',
                    style: TextStyle(color: Colors.black87,fontFamily: "Lexend",fontSize: 22.sp)),
            SizedBox(
              width: 8.w,
            ),
            ShiftStatus == 1
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      closeShiftPop(context);
                    },
                    child: Text('Close Shift'))
      
      : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Indicate loading
                      });
      
                      try {
                        // Perform all asynchronous operations
                        await openShift();
                        await shiftStatusService.getShiftStatus(
                            context: context,
                            deptid: widget.deptid,
                            processid: widget.processid);
                        await employeeApiService.employeeList(
                            context: context,
                            deptid: widget.deptid ?? 1,
                            processid: widget.processid ?? 0,
                            psid: widget.psid ?? 0);
       await listofworkstationService.getListofWorkstation(context: context, deptid: widget.deptid ?? 1057, psid: widget.psid ?? 0, processid: widget.processid ?? 0);
                            
                        await attendanceCountService.getAttCount(
                                        context: context,
                                        id: widget.processid ?? 0, deptid:widget.deptid ?? 1 , psid: widget.psid ?? 0);
                                         await planQtyService.getPlanQty(context: context, id: widget.processid ??0, psid: widget.psid ??0 );
        await actualQtyService.getActualQty(context: context, id: widget.processid??0,psid: widget.psid ??0);
      
      
      
                      } catch (e) {
                        // Handle any errors that occur during the async operations
                        print('Error: $e');
                      } finally {
                        setState(() {
                          isLoading = false; // Indicate completion
                          // Update any other state variables as needed
                        });
                      }
                    },
                    child: Text('Open Shift'),
                  )
          ],
        ),
      ),
    );
  }
}
