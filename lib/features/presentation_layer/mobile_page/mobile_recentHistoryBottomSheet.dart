import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/delete_production_entry.dart';
import 'package:prominous/constant/utilities/exception_handle/show_deletepopup_error.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/constant/utilities/exception_handle/show_save_error.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/presentation_layer/api_services/emp_production_entry_di.dart';
import 'package:prominous/features/presentation_layer/api_services/employee_di.dart';
import 'package:prominous/features/presentation_layer/api_services/product_di.dart';
import 'package:prominous/features/presentation_layer/api_services/recent_activity.dart';
import 'package:prominous/features/presentation_layer/mobile_page/mobile_workstation_widget/mob_workstation_edit_entry.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/product_provider.dart';
import 'package:prominous/features/presentation_layer/provider/recent_activity_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentHistoryBottomSheet extends StatefulWidget {
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
  RecentHistoryBottomSheet(
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
  State<RecentHistoryBottomSheet> createState() =>
      _RecentHistoryBottomSheetState();
}

class _RecentHistoryBottomSheetState extends State<RecentHistoryBottomSheet> {
  final ProductApiService productApiService = ProductApiService();
  final RecentActivityService recentActivityService = RecentActivityService();
  EmpProductionEntryService empProductionEntryService =
      EmpProductionEntryService();
  EmployeeApiService employeeApiService = EmployeeApiService();

  // Future<void> _fetchARecentActivity() async {
  //   try {
  //     // Fetch data
  //     await empProductionEntryService.productionentry(
  //         context: context,
  //         id: widget.empid ?? 0,
  //         deptid: widget.deptid ?? 0,
  //         psid: widget.psid ?? 0);

  //     await recentActivityService.getRecentActivity(
  //         context: context,
  //         id: widget.empid ?? 0,
  //         deptid: widget.deptid ?? 0,
  //         psid: widget.psid ?? 0);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

delete({
     int? ipdid,
    int? ipdpsid,
    int?processId,
    String?cardNo,
    int?pcId,
    int? paId
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
          int? orgid=Provider.of<LoginProvider>(context, listen: false).user?.userLoginEntity?.orgId  ?? 0;
    final requestBody = DeleteProductionEntryModel(
        apiFor: "delete_entry_v1",
        clientAuthToken: token,
        ipdid: ipdid,
        ipdpsid: ipdpsid, pcid: pcId, cardno: cardNo, processid: processId, paid: paId, orgid: orgid);
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
                final responseMsg = responseJson["response_msg"];
          if (responseMsg == "success") {
              return ShowDeleteError.showAlert(
                  context, "Deleted Successfully","Success","Success",Colors.green);
            } else {
              return ShowDeleteError.showAlert(context, responseMsg);
            }
          } catch (e) {
            // Handle the case where the response body is not a valid JSON object
            ShowDeleteError.showAlert(context, e.toString());
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

  void deletePop(BuildContext context, ipdid, ipdpsid, processid,cardno,pcid,paid) {
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
                                    ipdid: ipdid ?? 0, ipdpsid: ipdpsid ?? 0,cardNo:cardno ,paId:paid ,pcId:pcid ,processId:processid );
                      
               
    
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
                                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final recentActivity =
        Provider.of<RecentActivityProvider>(context, listen: false)
            .user
            ?.recentActivitesEntityList;

    final productname = Provider.of<ProductProvider>(context, listen: false)
        .user
        ?.listofProductEntity;
    return Container(
      height: 500.h,
        
      child: (recentActivity != null && recentActivity.isNotEmpty)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: recentActivity?.length,
              itemBuilder: (context, index) {
                final data = recentActivity?[index];
                final totime = data?.ipdtotime;
    
                return Container(
                                          width: 300.w,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                      
                                         
                                            border: Border(
                                              top:
                                              
                                                   BorderSide.none,
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.grey.shade300),
                                            ),
                                          ),
                  child: Padding(
                    padding: EdgeInsets.only(top:10.h,left: 10.w,right: 10.w),
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
                                                                  16.sp,
                                                              color: Colors
                                                                  .black54)),
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      Text(
                                                          '${(data?.ipdcardno)}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  16.sp,
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
                                                    // nonProductionList.reset(
                                                    //     notify: false);
                                                    // storedListOfProblem
                                                    //     .reset(
                                                    //         notify: false);
                                
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MobileProductionEditEntry(
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
                                                            fontSize: 16.sp,
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
                                            height: 5.h,
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
                                                        fontSize: 14.sp,
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
                  ),
                );
              })
          : Center(
              child: Text("No data available"),
            ),
    );
  }
}
