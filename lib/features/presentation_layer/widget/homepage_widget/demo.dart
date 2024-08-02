// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:prominous/constant/request_data_model/emp_process_change_model.dart';
// import 'package:prominous/features/presentation_layer/api_services/listofworkstation_di.dart';
// import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:prominous/features/presentation_layer/api_services/allocatio_di.dart';
// import 'package:prominous/features/domain/entity/AllocationEntity.dart';
// import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
// import 'package:prominous/features/presentation_layer/provider/allocation_provider.dart';
// import 'package:http/http.dart' as http;
// import '../../../../constant/request_model.dart';
// import '../../../../constant/show_pop_error.dart';
// import '../../../data/core/api_constant.dart';
// import '../../api_services/process_di.dart';
// import 'employee_details_list.dart';

// class EmployeeAllocationPopup extends StatefulWidget {
//   final int? empId;

//   final int? processid;
//   // final int? shiftid;
//   final int? deptid;
//   final int? psid;

//   final int? attid;
//   final int? mfgpeid;

//   EmployeeAllocationPopup(
//       {required this.empId,
//       required this.processid,
//       // required this.shiftid,
//       this.deptid,
//       required this.psid,
//       this.attid,
//       this.mfgpeid});

//   @override
//   _EmployeeAllocationPopupState createState() =>
//       _EmployeeAllocationPopupState();
// }

// class _EmployeeAllocationPopupState extends State<EmployeeAllocationPopup> {
//   String? selectedItem;
//   int? selectedProcessId;
//   AllocationService allocationService = AllocationService();
//   EmployeeApiService employeeApiService = EmployeeApiService();
//     ListofworkstationService listofworkstationService =
//       ListofworkstationService();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAllocationList();
//     // employeeApiService.employeeList(context: context, id: widget.processid!, shiftid: widget.shiftid);
//   }

//   Future<void> _fetchAllocationList() async {
//     try {
//       await allocationService.changeallocation(
//           context: context, id: widget.empId ?? 0, deptid: widget.deptid ?? 0);
//       setState(() {
//         isLoading = true; // Set isLoading to false when data is fetched
//       });
//     } catch (e) {
//       // ignore: avoid_print
//       // print('Error fetching asset list: $e');
//       setState(() {
//         isLoading = false; // Set isLoading to false even if there's an error
//       });
//     }
//   }

//   Future<void> sendProcess() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String token = pref.getString("client_token") ?? "";
//     DateTime now = DateTime.now();

//     final requestBody = EmpProcessChange(
//         apiFor: "change_process_v1",
//         clientAutToken: token,
//         flAttId: widget.attid,
//         mfgpeId: widget.mfgpeid,
//         mfgpeMpmId: selectedProcessId,
//         mfgpePersonId: widget.empId,
//         pwsePwsId: 0);

//     // final requestBody = ApiRequestDataModel(
//     //     apiFor: "change_process",
//     //     clientAuthToken: token,
//     //     mfgPmpmId: selectedProcessId,
//     //     mfgPersonId: widget.empId,
//     //     mfgpEmpId: widget.mfgpempid);
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



 


//   @override
//   Widget build(BuildContext context) {
//     final productResponse =
//         Provider.of<AllocationProvider>(context, listen: true)
//             .User
//             ?.allocationEntity;

//     // Convert the list to a set to remove duplicates, then back to list
//     final ProcessNames = productResponse
//             ?.map((process) => process.processname)
//             ?.toSet()
//             ?.toList() ??
//         [];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: showGeneralDialog(
//              barrierDismissible: true,
//              barrierLabel: '',
//              transitionDuration: const Duration(milliseconds: 400),
//              context: context,
//              pageBuilder: (context, animation1, animation2) {
//                return Container();
//              },
//              transitionBuilder: (context, animation, secondaryAnimation, child) {
//                return SlideTransition(
//                  position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
//                      .animate(animation),
//                  child: FadeTransition(
//                    opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
//                    child: Align(
//                      alignment: Alignment.centerRight, // Align the drawer to the right
//                      child: Container(
//                        color: Colors.white,
//                        width: MediaQuery.of(context).size.width *
//                            0.4, // Set the width to half of the screen
//                        height: MediaQuery.of(context)
//                            .size
//                            .height, // Set the height to full screen height
//                        child: Drawer(
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(8)),
//                          backgroundColor: Color.fromARGB(150, 235, 236, 255),
//                          child: SafeArea(
//                            child: Padding(
//                              padding: EdgeInsets.only(left: 16.w),
//                              child: Column(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text(
//                                    'Select Workstation',
//                                    style: TextStyle(
//                                     fontSize: 24.sp,
//                                          color: Color.fromARGB(255, 80, 96, 203),
//                                          fontFamily: "Lexend",
//                                          fontWeight: FontWeight.w500
//                                    ),
//                                  ),
//                                  Expanded(
//                                    child: ListView.builder(
//                                      itemCount: listofWorkstation?.length,
//                                      itemBuilder: (context, index) {
//                                        final workstation = listofWorkstation?[index];
        
//                                        return GestureDetector(
//                                          child: Container(
//                                            padding: EdgeInsets.symmetric(
//                                                vertical: 16.h, ),
//                                            decoration:
//                                                BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: Colors.grey.shade400))), // Set unique background color for selected tile
//                                            child: Text(
//                                              "${workstation?.pwsName} ",
//                                              style: TextStyle(color: Colors.black54,
//                                          fontFamily: "Lexend",
//                                          fontSize: 15.sp),
//                                            ),
//                                          ),
//                                          onTap: () async {
//                                            await _changeWorkstation(
//                                                empPersonid: empPersonid,
//                                                pwesId: pwseId,
//                                                pwsId: workstation?.pwsId,
//                                                attId: attid,
//                                                attstatus: attStatus ?? 0);
//                                            await employeeApiService.employeeList(
//                                                context: context,
//                                                processid: processId ?? 0,
//                                                deptid: widget.deptid ?? 1,
//                                                psid: widget.psid ?? 0);
        
//                                            await listofworkstationService
//                                                .getListofWorkstation(
//                                                    context: context,
//                                                    deptid: widget.deptid ?? 1057,
//                                                    psid: widget.psid ?? 0,
//                                                    processid: processId ?? 0);
        
//                                            Navigator.of(context).pop();
//                                          },
//                                        );
//                                      },
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                );
//              },
//            ),
//       ),
//     );
//   }
// }
