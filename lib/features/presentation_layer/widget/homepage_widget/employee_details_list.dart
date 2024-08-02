// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:prominous/features/data/model/shift_status_model.dart';
// import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
// import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
// import 'package:prominous/features/presentation_layer/widget/emp_production_entry_widget/emp_close_shift_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:prominous/constant/request_data_model/send_attendence_model.dart';
// import 'package:prominous/features/presentation_layer/api_services/attendace_count_di.dart';
// import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
// import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
// import 'package:toggle_switch/toggle_switch.dart';
// import '../../../../constant/request_model.dart';
// import '../emp_production_entry_widget/emp_production_entry.dart';
// import '../../../../constant/show_pop_error.dart';
// import '../../../data/core/api_constant.dart';
// import '../../api_services/process_di.dart';
// import '../../provider/employee_provider.dart';
// import 'employe_allocation_popup.dart';

// class EmployeeDetailsList extends StatefulWidget {
//   // final int id;
//   // final int shiftid;
//   final int deptid;
//   final int? psid;

//   final Function? refreshCallback;

//   const EmployeeDetailsList({
//     Key? key,
//     // required this.id,
//     // required this.shiftid,
//     required this.deptid,
//     this.refreshCallback,
//     this.psid,
//   }) : super(key: key);

//   @override
//   State<EmployeeDetailsList> createState() => _EmployeeDetailsListState();
// }

// class _EmployeeDetailsListState extends State<EmployeeDetailsList> {
//   EmployeeApiService employeeApiService = EmployeeApiService();
//   AttendanceCountService attendanceCountService = AttendanceCountService(); 
//   ListofworkstationService listofworkstationService=ListofworkstationService();

//   late int? initialindex;
//   bool isLoading = true;

//   void showEmployeeAllocationPopup(
//     int? empPersonid,
//     int? mfgpempid,
//     int? processId,
//     int? deptid,
//     // int? shitid
//   ) async {
//     // Capture the valid context before the asynchronous operation
//     final validContext = context;
//     showDialog(
//       context: validContext,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             width: 400,
//             height: 500,
//             decoration: BoxDecoration(color: Colors.white),
//             child: EmployeeAllocationPopup(
//               empId: empPersonid,
//               mfgpempid: mfgpempid,
//               processid: processId,
//               //  shiftid: shitid,
//               deptid: deptid,
//               psid: widget.psid,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Load employee list initially
//     // loadEmployeeList();
//   }

//   // Future<void> loadEmployeeList()  async{
//   //   try {
//   //     final int? process_id =
//   //         Provider.of<ShiftStatusProvider>(context, listen: false)
//   //             .user
//   //             ?.shiftStatusdetailEntity
//   //             ?.psMpmId;

//   //     employeeApiService.employeeList(
//   //         context: context,
//   //         deptid: widget.deptid,
//   //         processid: process_id ?? 0,
//   //         psid: widget.psid ?? 0);

//   //     setState(() {
//   //       isLoading = true; // Set isLoading to false when data is fetched
//   //     });
//   //   } catch (e) {
//   //     // ignore: avoid_print
//   //     // print('Error fetching asset list: $e');
//   //     setState(() {
//   //       isLoading = false; // Set isLoading to false even if there's an error
//   //     });
//   //   }
//   // }

//   // void loadEmployeeList() {
//   //   employeeApiService.employeeList(context: context, id: widget.id);
//   // }
//   // void handleToggleAction(int index) async {
//   //   await loadEmployeeList();
//   // }

//   Future<void> sendAttendance(int? index, String? attendanceid,
//       int? empPersonid, String? flattdate) async {
//     final process_id = Provider.of<EmployeeProvider>(context, listen: false)
//         .user
//         ?.listofEmployeeEntity
//         ?.first
//         .processId;
//     final shitId = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.psShiftId;
//     final shiftStatus = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.psShiftStatus;
//     final Shiftid = Provider.of<ShiftStatusProvider>(context, listen: false)
//         .user
//         ?.shiftStatusdetailEntity
//         ?.psShiftId;

//     final attdid = Provider.of<EmployeeProvider>(context, listen: false)
//         .user
//         ?.listofEmployeeEntity
//         ?.first
//         .attendanceid;
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String token = pref.getString("client_token") ?? "";
//     DateTime now = DateTime.now();
//     //DateTime today = DateTime(now.year, now.month, now.day);;

//     int dt;

//     dt = int.tryParse(attendanceid ?? "") ?? 0;

//     final requestBody = SendAttendencereqModel(
//         apiFor: "floor_attendance",
//         clientAuthToken: token,
//         attId: dt,
//         attStatus: index,
//         deptId: widget.deptid,
//         empid: empPersonid,
//         processId: process_id,
//         psid: widget.psid,
//         shiftId: Shiftid,
//         shiftStatus: shiftStatus, pwsId: null);

//     final requestBodyjson = jsonEncode(requestBody.toJson());

//     print(requestBodyjson);

//     const timeoutDuration = Duration(seconds: 30);
//     try {
//       http.Response response = await http
//           .post(
//             Uri.parse(ApiConstant.baseUrl),
//             headers: {
//               'Content-Type': 'application/json',
//             },
//             body: requestBodyjson,
//           )
//           .timeout(timeoutDuration);

//       // ignore: avoid_print
//       print(response.body);

//       if (response.statusCode == 200) {
//         try {
//           final responseJson = jsonDecode(response.body);
//           // loadEmployeeList();
//           print(responseJson);
//           return responseJson;
//         } catch (e) {
//           // Handle the case where the response body is not a valid JSON object
//           throw ("Invalid JSON response from the server");
//         }
//       } else {
//         throw ("Server responded with status code ${response.statusCode}");
//       }
//     } on TimeoutException {
//       throw ('Connection timed out. Please check your internet connection.');
//     } catch (e) {
//       ShowError.showAlert(context, e.toString());
//     }
//   }

//   void _closeShiftPop(
//     BuildContext context,
//     String attenceid,
//     int attendceStatus,
//     int empPersonid,
//     int processid,
//   ) {
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
//                                 await employeeApiService.employeeList(
//                                   context: context,
//                                   processid: processid ?? 0,
//                                   deptid: widget.deptid ?? 1,
//                                   psid: widget.psid ?? 0,
//                                 );

//  await listofworkstationService.getListofWorkstation(context: context, deptid: widget.deptid ?? 1057, psid: widget.psid ?? 0, processid: processid );
//                                 // Call the EmpClossShift.empCloseShift method

//                                 await EmpClosesShift.empCloseShift(
//                                     'emp_close_shift',
//                                     widget.psid ?? 0,
//                                     1,
//                                     attenceid ?? " ",
//                                     attendceStatus ?? 0);

//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         EmpProductionEntryPage(
//                                       empid: empPersonid!,
//                                       processid: processid ?? 1,
//                                       deptid: widget.deptid,
//                                       isload: true,
//                                       attenceid: attenceid,
//                                       attendceStatus: attendceStatus,
//                                       // shiftId: widget.shiftid,
//                                       psid: widget.psid,
//                                     ),
//                                   ),
//                                 );

                             
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

//   @override
//   Widget build(BuildContext context) {
//     final employeeResponse =
//         Provider.of<EmployeeProvider>(context, listen: true)
//             .user
//             ?.listofEmployeeEntity;
//              final Listofworkstation =
//         Provider.of<ListofworkstationProvider>(context, listen: true)
//             .user
//             ?.listOfWorkstation;
//     print(employeeResponse);
//     final empid =
//         employeeResponse?.isNotEmpty == true ? employeeResponse!.indexed : null;

//     final int? process_id =
//         Provider.of<ShiftStatusProvider>(context, listen: false)
//             .user
//             ?.shiftStatusdetailEntity
//             ?.psMpmId;

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
//         child: Container(
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(8)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                   height: 80,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(8),
//                         topRight: Radius.circular(8)),
//                     color: Color.fromARGB(255, 45, 54, 104),
//                   ),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16.0),
//                         child: Container(
//                             width: 40,
//                             child: Text('S.NO',
//                                 style: TextStyle(color: Colors.white))),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                    alignment: Alignment.center,
//                             width: 120,
//                             child: Text('Name',
//                                 style: TextStyle(color: Colors.white))),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 120,
//                           alignment: Alignment.center,
//                           child: Text('Prev Product',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 100,
//                           alignment: Alignment.center,
//                           child: Text('Prev Time',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 120,
//                           alignment: Alignment.center,
//                           child: Text('Production Qty',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 110,
//                           alignment: Alignment.center,
//                           child: Text('Attendance',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 120,
//                           alignment: Alignment.center,
//                           child: Text('Allocation',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: 120,
//                           alignment: Alignment.center,
//                           child:
//                               Text('Production Entry', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   )),
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: employeeResponse?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     final employee = employeeResponse![index];
//                     DateTime now = DateTime.now();
//                     String today = DateFormat('yyyy-MM-dd').format(now);

//                     String? dt = employee.flattdate;
//                     int? shiftstatus = employee?.flattshiftstatus;
//                     initialindex = employee.flattstatus;

//                     String? flattDate = dt; // Parse dt to DateTime if not null

//                     String attdate =
//                         flattDate ?? ""; // Format flattDate if not null

//                     return Container(
//                       decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 width: 1, color: Colors.grey.shade300)),
//                         color: index % 2 == 0
//                             ? Colors.grey.shade50
//                             : Colors.grey.shade100,
//                       ),
//                       height: 85,
//                       width: double.infinity,
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 width: 40,
//                                 child: Text('${index + 1}',
//                                     style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontSize: 12))),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 width: 120,
//                                 child: Text(employee?.personFname ?? '',
//                                     style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontSize: 12))),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 width: 120,
//                                 child: Text(employee?.productName ?? '',
//                                     style: TextStyle(
//                                         color: Colors.grey.shade600,
//                                         fontSize: 12))),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 width: 100,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 15),
//                                   child: Text(employee.timing.toString(),
//                                       style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                           fontSize: 12)),
//                                 )),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               width: 120,
//                               alignment: Alignment.center,
//                               child: Text(employee.productQty.toString() ?? "",
//                                   style: TextStyle(
//                                       color: Colors.grey.shade600,
//                                       fontSize: 12)),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 110,
//                               child: ToggleSwitch(
//                                 minWidth: 40.0,
//                                 cornerRadius: 20.0,
//                                 activeBgColors: [
//                                   [Colors.red[800]!],
//                                   [Colors.green[800]!]
//                                 ],
//                                 activeFgColor: Colors.white,
//                                 inactiveBgColor: Colors.grey,
//                                 initialLabelIndex: initialindex,
//                                 totalSwitches: 2,
//                                 labels: ['A', 'P'],
//                                 radiusStyle: true,
//                                 onToggle: (index) async {
//                                   await sendAttendance(
//                                     index,
//                                     employee?.attendanceid ?? "",
//                                     employee.empPersonid,
//                                     employee.flattdate,
//                                   );
//                                   print('switched to: $index');

//                                   employeeApiService.employeeList(
//                                       context: context,
//                                       processid: employee.processId ?? 0,
//                                       deptid: widget.deptid ?? 1,
//                                       psid: widget.psid ?? 0);

//                                   attendanceCountService.getAttCount(
//                                       context: context,
//                                       id: employee.processId ?? 0,
//                                       deptid: widget.deptid,
//                                       psid: widget.psid ?? 0);
//                                 },
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16.0),
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 120,
//                               child: ElevatedButton(
//                                 child: Text("Change"),
//                                 onPressed: initialindex ==
//                                         0 // Disable the button if toggle label is "A"
//                                     ? null
//                                     : () {
//                                         setState(() {
//                                           showEmployeeAllocationPopup(
//                                               employee.empPersonid,
//                                               employee.mfgpempid,
//                                               employee.processId,
//                                               widget.deptid ?? 0

//                                               // widget?.shiftid ??0,

//                                               );
//                                           employeeApiService.employeeList(
//                                               context: context,
//                                               processid:
//                                                   employee.processId ?? 0,
//                                               deptid: widget.deptid ?? 1,
//                                               psid: widget.psid ?? 0);
//                                         });
//                                       },
//                               ),
//                             ),
//                           ),
//                           if (shiftstatus == 1)
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10,right: 10),
//                               child: Container(
//                                   width: 120,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ElevatedButton(
//                                       onPressed: initialindex == 0
//                                           ? null
//                                           : () {
//                                               final employeeProvider =
//                                                   Provider.of<EmployeeProvider>(
//                                                       context,
//                                                       listen: false);
                                    
//                                               // Get the employee ID of the current employee
//                                               final employeeId =
//                                                   employeeResponse[index]
//                                                       .empPersonid;
                                    
//                                               // Update the employee ID in the provider
//                                               employeeProvider
//                                                   .updateEmployeeId(employeeId!);
                                    
//                                               // Navigate to the ProductionQuantityPage
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       EmpProductionEntryPage(
//                                                     empid: employee.empPersonid!,
//                                                     processid: process_id ?? 1,
//                                                     deptid: widget.deptid,
//                                                     isload: true,
//                                                     attenceid:
//                                                         employee.attendanceid,
//                                                     attendceStatus:
//                                                         employee.flattstatus,
//                                                     // shiftId: widget.shiftid,
//                                                     psid: widget.psid,
//                                                   ),
//                                                 ),
//                                               );
                                    
//                                               // Fetch employee list
//                                               employeeApiService.employeeList(
//                                                 context: context,
//                                                 processid:
//                                                     employee.processId ?? 0,
//                                                 deptid: widget.deptid ?? 1,
//                                                 psid: widget.psid ?? 0,
//                                               );
//                                             },
//                                       child: Text("Add"),
//                                     ),
//                                   )),
//                             )
//                           else if (shiftstatus == 2)
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                  width: 120,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: ElevatedButton(
//                                     onPressed: initialindex == 0
//                                         ? null
//                                         : () {
//                                             final employeeProvider =
//                                                 Provider.of<EmployeeProvider>(context,
//                                                     listen: false);
                                  
//                                             // Get the employee ID of the current employee
//                                             final employeeId =
//                                                 employeeResponse[index].empPersonid;
                                  
//                                             // Update the employee ID in the provider
//                                             employeeProvider
//                                                 .updateEmployeeId(employeeId!);
//                                             print(shiftstatus);
                                  
//                                             _closeShiftPop(
//                                                 context,
//                                                 employee.attendanceid ?? "",
//                                                 employee.flattstatus ?? 0,
//                                                 employee.empPersonid ?? 0,
//                                                 employee.processId ?? 0);
                                  
//                                             // Navigate to the ProductionQuantityPage
//                                           },
//                                     child: Text("Reopen",
//                                         style: TextStyle(color: Colors.red)),
//                                   ),
//                                 ),
//                               ),
//                             )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
