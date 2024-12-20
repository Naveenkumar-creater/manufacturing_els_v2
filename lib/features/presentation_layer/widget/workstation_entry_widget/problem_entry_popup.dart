import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';
import 'package:prominous/constant/request_data_model/update_problem_request_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custom_textform_field.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/constant/utilities/exception_handle/show_pop_error.dart';
import 'package:prominous/constant/utilities/exception_handle/show_save_error.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:prominous/features/data/model/listof_problem_category_model.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';
import 'package:prominous/features/data/model/listof_rootcaue_model.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';

import 'package:prominous/features/domain/entity/rootcause_solution_entity.dart';
import 'package:prominous/features/presentation_layer/api_services/Workstation_problem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_catagory_di.dart';

import 'package:prominous/features/presentation_layer/api_services/listofproblem_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofrootcause_di.dart';
import 'package:prominous/features/presentation_layer/api_services/problem_status_di.dart';
import 'package:prominous/features/presentation_layer/api_services/rootcause_solution_di.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_catagory_provider.dart';

import 'package:prominous/features/presentation_layer/provider/listofproblem_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofrootcause_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:prominous/features/presentation_layer/provider/problem_status_provider.dart';
import 'package:prominous/features/presentation_layer/provider/rootcause_solution_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/provider/workstation_problem_provider.dart';
import 'package:prominous/features/presentation_layer/widget/timing_widget/update_time.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProblemEntryPopup extends StatefulWidget {
  ProblemEntryPopup(
      {super.key,
      required this.processid,
      required this.deptid,
      required this.assetid,
      this.SelectProblemId,
      this.rootcauseid,
      this.problemCategoryId,
      this.shiftFromTime,
      this.shiftToTime,
      this.reason,
      this.showButton,
      this.solutionId,
      this.problemStatusId,
      this.productionStopageId,
      this.ipdid,
      this.ipdincid,
      this.closestartTime,
      this.pwsId});

  final int? SelectProblemId;
  final int? rootcauseid;
  final int? problemCategoryId;
  final String? shiftFromTime;
  final String? shiftToTime;
  final String? reason;
  final int? productionStopageId;
  final int? solutionId;
  final int? problemStatusId;
  bool? showButton;
  final int? ipdincid;
  final int? ipdid;
  final String? closestartTime;
  final int? pwsId;
  final int processid;
  final int deptid;
  final int assetid;

  @override
  State<ProblemEntryPopup> createState() => _ProblemEntryPopupState();
}

class _ProblemEntryPopupState extends State<ProblemEntryPopup> {
  final ListofproblemCategoryservice listofproblemCategoryservice =
      ListofproblemCategoryservice();
  final ListofRootCauseService listofRootCauseService =
      ListofRootCauseService();
  final RootcauseSolutionService rootcauseSolutionService =
      RootcauseSolutionService();
  final TextEditingController incidentReasonController =
      TextEditingController();
  final ProblemStatusService problemStatusService = ProblemStatusService();
  final Listofproblemservice listofproblemservice = Listofproblemservice();
  final WorkstationProblemService workstationProblemService =
      WorkstationProblemService();
  bool isChecked = false;

  int? productionStoppageid;

  List<Map<String, dynamic>> submittedDataList = [];
  String? fromTime; // This will store the selected time
  String? lastupdatedTime;
  String? selectedName;
  String? selectproblemname;
  String? selectproblemCategoryname;
  String? selectrootcausename;
  String? selectProblemStatusDesc;
  String? selectSolution;
  String? dropdownProduct;
  String? activityDropdown;
  String? problemDropdown;
  String? problemStatusDropdown;
  int? problemStatusid;
  int? problemid;
  String? problemCategoryDropdown;
  int? problemCategoryid;
  String? rootCauseDropdown;
  String? solutionDropdown;
  int? rootCauseid;
  int? solutionid;

  List<ListOfIncidentCategoryEntity>? problemCategory;
  List<ListrootcauseEntity>? listofrootcause;
  List<SolutionEntity>? listofrootcausesolution;

  late DateTime now;
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  late int currentHour;
  late int currentMinute;
  late String currentTime;
  late int currentSecond;
  late DateTime currentDateTime;
  String? currentDate;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true; // Set loading state to true at the beginning
    });

    // Fetch problem status
    await problemStatusService.getProblemStatus(context: context);

    if (widget.showButton == true) {
      await listofproblemservice.getListofProblem(
        context: context,
        processid: widget.processid ?? 0,
        deptid: widget.deptid ?? 1057,
        assetid: widget.assetid,
      );
    }


    if (widget.SelectProblemId != null) {
          final deptid = Provider.of<LoginProvider>(context, listen: false)
          .user
          ?.userLoginEntity
          ?.deptId;
        await listofproblemCategoryservice.getListofProblemCategory(
        context: context,
        deptid: deptid ?? 1,
        incidentid: widget.SelectProblemId ?? 0,
      );
      final listofproblem =
          Provider.of<ListofproblemProvider>(context, listen: false)
              .user
              ?.listOfIncident;
  
      final listproblemCategory =
          Provider.of<ListofproblemCategoryProvider>(context, listen: false)
              .user
              ?.listOfIncidentCategory;
      final listofsolution =
          Provider.of<RootcauseSolutionProvider>(context, listen: false)
              .user
              ?.solutionEntity;
      final listofroot =
          Provider.of<ListofRootcauseProvider>(context, listen: false)
              .user
              ?.listrootcauseEntity;
      final listofproblemStatus =
          Provider.of<ProblemStatusProvider>(context, listen: false)
              .user
              ?.listofProblemStatusEntity;

    

      problemCategory = listproblemCategory;

      ListOfIncident? selectproblemname;
      if (listofproblem != null) {
        for (var problem in listofproblem) {
          if (problem is ListOfIncident &&
              problem.incmId == widget.SelectProblemId) {
            selectproblemname = problem;
            break;
          }
        }
      }

      if (selectproblemname != null) {
        problemDropdown = selectproblemname.incmName;
        problemid = selectproblemname.incmId;
      } else {
        print(
            'No problem found for SelectProblemId: ${widget.SelectProblemId}');
      }

      if (widget.problemCategoryId != null) {
        await listofRootCauseService.getListofRootcause(
          context: context,
          deptid: deptid ?? 1057,
          incidentid: widget.problemCategoryId ?? 0,
        );

        listofrootcause = listofroot;

        final selectCategory = listproblemCategory?.firstWhere(
          (Category) => Category.incmId == widget.problemCategoryId,
          orElse: () => ListOfIncidentCategory(
            incmDesc: '',
            incmId: 0,
            incmMpmId: 0,
            incmName: "",
            incmParentId: 0,
            incmassetid: 0,
            incmassettype: 0,
            incmparentid: 0,
          ),
        );

        if (selectCategory != null) {
          problemCategoryDropdown = selectCategory.incmName;
          problemCategoryid = selectCategory.incmId;
        }
      }

      final rootcause = listofrootcause
          ?.firstWhere((rootcause) => rootcause.incrcmid == widget.rootcauseid);
      if (rootcause != null) {
        rootCauseDropdown = rootcause.incrcmrootcausebrief;
        rootCauseid = rootcause.incrcmid;
      }

      if (widget.rootcauseid != null) {
        await rootcauseSolutionService.getListofSolution(
          context: context,
          deptid: deptid ?? 1057,
          rootcauseid: widget.rootcauseid ?? 0,
        );

        listofrootcausesolution = listofsolution;

        final solution = listofsolution?.firstWhere(
          (listofsolution) => listofsolution.solId == widget.solutionId,
        );

        if (solution != null) {
          solutionDropdown = solution.solDesc;
          solutionid = solution.solId;
        }
      }

      final problemstatus = listofproblemStatus?.firstWhere(
        (listofproblemStatus) =>
            listofproblemStatus.statusId == widget.problemStatusId,
      );

      if (problemstatus != null) {
        problemStatusDropdown = problemstatus.statusName;
        problemStatusid = problemstatus.statusId;
      }

      productionStoppageid = widget.productionStopageId;

      if (productionStoppageid != null) {
        isChecked = productionStoppageid == 1;
      }

      incidentReasonController.text = widget?.reason ?? "";
    }

    await _handleShiftTimes();

    setState(() {
      isLoading = false; // Set loading state to false after all data is loaded
    });
  }

  Future<void> _handleShiftTimes() async {
    String? shiftTime;

    currentDateTime = DateTime.now();
    now = DateTime.now();
    currentYear = now.year;

    currentMonth = now.month;
    currentDay = now.day;
    currentHour = now.hour;
    currentMinute = now.minute;
    currentSecond = now.second;
    final shiftToTimeString =
        Provider.of<ShiftStatusProvider>(context, listen: false)
            .user
            ?.shiftStatusdetailEntity
            ?.shiftToTime;

    if (shiftToTimeString != null) {
      DateTime? shiftToTime;
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

      final currentTime = DateTime.now();
      final shiftFromTimeString =
          Provider.of<ShiftStatusProvider>(context, listen: false)
              .user
              ?.shiftStatusdetailEntity
              ?.shiftFromTime;

      if (shiftFromTimeString != null) {
        final shiftFromTimeParts = shiftFromTimeString.split(':');
        final shiftFromTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(shiftFromTimeParts[0]),
          int.parse(shiftFromTimeParts[1]),
          int.parse(shiftFromTimeParts[2]),
        );

        if (shiftToTime.isBefore(shiftFromTime)) {
          shiftToTime = shiftToTime.add(Duration(days: 1));
        }

        if (currentTime.isAfter(shiftFromTime) &&
            currentTime.isBefore(shiftToTime)) {
          final timeString =
              '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}:${currentSecond.toString().padLeft(2, '0')}';
          shiftTime = timeString;
        } else {
          shiftTime = shiftToTimeString;
        }
      }
    }

    fromTime = widget.shiftFromTime;
    lastupdatedTime = widget.shiftToTime;
  }

// void _storedWorkstationProblemList() {

//   Provider.of<ListProblemStoringProvider>(context, listen: false).reset();
//    final workstationProblem = Provider.of<WorkstationProblemProvider>(context, listen: false)
//         .user
//         ?.resolvedProblemInWs;

//     if (workstationProblem != null) {
//       for (int i = 0; i < workstationProblem.length; i++) {
//          ListOfWorkStationIncident data =
//                                           ListOfWorkStationIncident(
//                                               fromtime: workstationProblem[i].fromTime,
//                                               endtime: workstationProblem[i].endTime,
//                                               productionStoppageId:
//                                                   workstationProblem[i].productionStopageId,
//                                               problemstatusId: workstationProblem[i].problemStatusId,
//                                               problemsolvedName:
//                                                   workstationProblem[i].problemStatus,
//                                               solutionId: workstationProblem[i].solId,
//                                               solutionName: workstationProblem[i].solDesc,
//                                               problemCategoryname:
//                                                  workstationProblem[i].subincidentName,
//                                               problemId: workstationProblem[i].incidentId,
//                                               problemName: workstationProblem[i].incidentName,
//                                               problemCategoryId:
//                                                   workstationProblem[i].subincidentId,
//                                               reasons:
//                                                   workstationProblem[i].ipdincNotes,
//                                               rootCauseId: workstationProblem[i].ipdincIncrcmId,
//                                               rootCausename:
//                                                   workstationProblem[i].incrcmRootcauseBrief,
//                                                   ipdId:workstationProblem[i].ipdincipdid,
//                                                   ipdIncId: workstationProblem[i].ipdincid,
//                                                   assetId:workstationProblem[i].incmAssetId  );
//        Provider.of<ListProblemStoringProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .addIncidentList(data);
//       }
//     }
//   }

  Future<void> _fetchProblemDetails() async {}

  updateProblemList(
      {String? fromtime,
      String? endTime,
      int? incidentid,
      int? ipdincid,
      int? ipdincIpdid,
      String? note,
      int? problemSolvedstatus,
      int? productionstopage,
      int? rootcauseid,
      int? solutionid,
      int? subincidentId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    final requestBody = UpdateProblemModel(
        apiFor: "update_problem_v1",
        clientAutToken: token,
        incEndTime: endTime,
        incFromTime: fromtime,
        incidentId: incidentid,
        ipdincId: ipdincid,
        ipdincIpdId: ipdincIpdid,
        notes: note,
        problemSolvedStatus: problemSolvedstatus,
        productionStopage: productionstopage,
        rootcauseId: rootcauseid,
        solutionId: solutionid,
        subincidentId: subincidentId);
    final requestBodyjson = jsonEncode(requestBody);

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
            return ShowSaveError.showAlert(context, "Updated Successfully",
                "Success", "Success", Colors.green);
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
  }

  @override
  Widget build(BuildContext context) {
    final listofproblem =
        Provider.of<ListofproblemProvider>(context, listen: false)
            .user
            ?.listOfIncident;

    final problemStatus =
        Provider.of<ProblemStatusProvider>(context, listen: false)
            .user
            ?.listofProblemStatusEntity;

    final deptid =
        Provider.of<LoginProvider>(context).user?.userLoginEntity?.deptId;
    DateTime fromDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.shiftFromTime!);

    final shiftStarttime = DateFormat('yyyy-MM-dd HH:mm:ss').format(fromDate);
// final enddate=ChaneDateformate.formatDate(widget.shiftToTime!)
// DateTime date = DateTime.parse(enddate);
// String shiftEndtime = DateFormat('HH:mm:ss').format(date);
    String correctedShiftToTime =
        widget.shiftToTime!.replaceAll(RegExp(r'\s+'), ' ');
    DateTime toDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(correctedShiftToTime);

    final shiftEndtime = DateFormat('yyyy-MM-dd HH:mm:ss').format(toDate);

    // final shiftEndtime =widget.shiftToTime!.substring(10, fromTime!.length - 0);

    // final setStartTime = fromTime!.substring(10, fromTime!.length - 0);

    final setStartTime = widget.closestartTime;

    Size screenSize = MediaQuery.of(context).size;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Color.fromARGB(150, 235, 236, 255),
      child: isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: screenSize.width < 572
                    ? EdgeInsets.only(top: 20.h, left: 12.w, bottom: 20.w)
                    : EdgeInsets.only(left: 12.w, bottom: 20.w, top: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Problem Description',
                      style: TextStyle(
                          fontSize: screenSize.width < 572 ? 18.sp : 24.sp,
                          color: Color.fromARGB(255, 80, 96, 203),
                          fontFamily: "Lexend",
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'From Time :',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                    screenSize.width < 572 ? 12.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              fromTime != null
                                  ? fromTime!.substring(0, fromTime!.length - 3)
                                  : 'No Time Selected',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize:
                                    screenSize.width < 572 ? 11.sp : 16.sp,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 10),
                            (widget.showButton == true)
                                ? Text("")
                                : UpdateFromTime(
                                    onTimeChanged: (time) {
                                      setState(() {
                                        fromTime = time.toString();
                                      });
                                    },
                                    shiftFromTime: shiftStarttime ?? "",
                                    shiftToTime: shiftEndtime ?? "",
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Problem',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.sp : 16.sp,
                                    color: Colors.black54)),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: problemDropdown,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.h),
                              border: InputBorder.none,
                            ),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontSize:
                                    screenSize.width < 572 ? 12.sp : 16.sp,
                              ),
                            ),
                            isExpanded: true,
                            onChanged: (String? newvalue) async {
                              if (newvalue != null) {
                                setState(() {
                                  problemDropdown = newvalue;

                                  problemCategoryDropdown = null;
                                  problemCategory = [];
                                  Provider.of<ListofRootcauseProvider>(context,
                                          listen: false)
                                      .reset();
                                });

                                final selectedProblem =
                                    listofproblem?.firstWhere(
                                  (activity) => activity.incmName == newvalue,
                                  orElse: () => ListOfIncident(
                                    incmDesc: '',
                                    incmId: 0,
                                    incmMpmId: 0,
                                    incmName: "",
                                    incmParentId: 0,
                                  ),
                                );

                                if (selectedProblem != null &&
                                    selectedProblem.incmId != null) {
                                  problemid = selectedProblem.incmId;

                                  await listofproblemCategoryservice
                                      .getListofProblemCategory(
                                    context: context,
                                    deptid: deptid ?? 1,
                                    incidentid: problemid ?? 0,
                                  );

                                  final listproblemCategory = Provider.of<
                                      ListofproblemCategoryProvider>(
                                    context,
                                    listen: false,
                                  ).user?.listOfIncidentCategory;

                                  setState(() {
                                    problemCategory = listproblemCategory;
                                  });
                                }
                              } else {
                                setState(() {
                                  problemDropdown = null;
                                  problemCategoryDropdown = null;
                                  problemCategory = [];
                                });
                              }
                            },
                            items: listofproblem
                                    ?.map((problemName) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            selectproblemname =
                                                problemName.incmName;
                                            selectproblemCategoryname =
                                                null; // Reset the problem category name
                                            selectrootcausename =
                                                null; // Reset the root cause name
                                          });
                                        },
                                        value: problemName.incmName,
                                        child: Text(
                                          problemName.incmName ?? "",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "lexend",
                                            fontSize: screenSize.width < 572
                                                ? 12.sp
                                                : 16.sp,
                                          ),
                                        ),
                                      );
                                    })
                                    .toSet()
                                    .toList() ??
                                [],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Problem Category',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.sp : 16.sp,
                                    color: Colors.black54)),
                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: problemCategoryDropdown,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.h),
                              border: InputBorder.none,
                            ),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontSize:
                                    screenSize.width < 572 ? 12.sp : 16.sp,
                              ),
                            ),
                            isExpanded: true,
                            onChanged: (String? newvalue) async {
                              if (newvalue != null) {
                                setState(() {
                                  problemCategoryDropdown = newvalue;
                                  rootCauseDropdown = null;
                                  listofrootcause = [];
                                });

                                final selectproblemCategory =
                                    problemCategory?.firstWhere(
                                  (problemCategory) =>
                                      problemCategory.incmName == newvalue,
                                  orElse: () => ListOfIncidentCategory(
                                    incmDesc: '',
                                    incmId: 0,
                                    incmMpmId: 0,
                                    incmName: "",
                                    incmParentId: 0,
                                    incmassettype: 0,
                                    incmassetid: 0,
                                    incmparentid: 0,
                                  ),
                                );

                                if (selectproblemCategory?.incmName != null &&
                                    selectproblemCategory?.incmId != null) {
                                  problemCategoryid =
                                      selectproblemCategory?.incmId;

                                  await listofRootCauseService
                                      .getListofRootcause(
                                    context: context,
                                    deptid: deptid ?? 1057,
                                    incidentid: problemCategoryid ?? 0,
                                  );

                                  final listofroot =
                                      Provider.of<ListofRootcauseProvider>(
                                    context,
                                    listen: false,
                                  ).user?.listrootcauseEntity;

                                  setState(() {
                                    listofrootcause = listofroot;
                                  });
                                }
                              } else {
                                setState(() {
                                  problemCategoryDropdown = null;
                                  problemCategoryid = 0;
                                  rootCauseDropdown = null;
                                  listofrootcause = [];
                                });
                              }
                            },
                            items: problemCategory
                                    ?.map((problemCategory) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            selectproblemCategoryname =
                                                problemCategory.incmName;

                                            selectrootcausename = null;
                                          });
                                        },
                                        value: problemCategory.incmName,
                                        child: Text(
                                          problemCategory.incmName ?? "",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "lexend",
                                            fontSize: screenSize.width < 572
                                                ? 12.sp
                                                : 16.sp,
                                          ),
                                        ),
                                      );
                                    })
                                    .toSet()
                                    .toList() ??
                                [],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Root Cause',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.sp : 16.sp,
                                    color: Colors.black54)),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                              value: rootCauseDropdown,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h)),
                              hint: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize:
                                      screenSize.width < 572 ? 12.sp : 16.sp,
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (String? newvalue) async {
                                if (newvalue != null) {
                                  setState(() {
                                    rootCauseDropdown = newvalue;
                                  });

                                  final rootcause = listofrootcause?.firstWhere(
                                      (listofrootcause) =>
                                          listofrootcause
                                              .incrcmrootcausebrief ==
                                          newvalue,
                                      orElse: () => ListOfRootcause(
                                            incrcmid: 0,
                                            incrcmincmid: 0,
                                            incrcmmpmid: 0,
                                            incrcmrootcausebrief: "",
                                            increcmrootcausedetails: "",
                                          ));

                                  if (rootcause?.incrcmrootcausebrief != null &&
                                      rootcause?.incrcmid != null) {
                                    rootCauseid = rootcause?.incrcmid;

                                    await rootcauseSolutionService
                                        .getListofSolution(
                                      context: context,
                                      deptid: deptid ?? 1057,
                                      rootcauseid: rootCauseid ?? 0,
                                    );

                                    final listofsolution =
                                        Provider.of<RootcauseSolutionProvider>(
                                      context,
                                      listen: false,
                                    ).user?.solutionEntity;

                                    setState(() {
                                      listofrootcausesolution = listofsolution;
                                    });
                                  }
                                } else {
                                  rootCauseDropdown = null;
                                  rootCauseid = null;
                                }
                              },
                              items: listofrootcause
                                  ?.map((listofrootcause) {
                                    return DropdownMenuItem<String>(
                                      onTap: () {
                                        setState(() {
                                          selectrootcausename = listofrootcause
                                              .incrcmrootcausebrief;
                                        });
                                      },
                                      value:
                                          listofrootcause.incrcmrootcausebrief,
                                      child: Text(
                                        listofrootcause.incrcmrootcausebrief ??
                                            "",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 12.sp
                                              : 16.sp,
                                        ),
                                      ),
                                    );
                                  })
                                  .toSet()
                                  .toList()),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Solution',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.sp : 16.sp,
                                    color: Colors.black54)),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                              value: solutionDropdown,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h)),
                              hint: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize:
                                      screenSize.width < 572 ? 12.sp : 16.sp,
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (String? newvalue) {
                                if (newvalue != null) {
                                  setState(() {
                                    solutionDropdown = newvalue;
                                  });

                                  final solution =
                                      listofrootcausesolution?.firstWhere(
                                    (listofrootcausesolution) =>
                                        listofrootcausesolution.solDesc ==
                                        newvalue,
                                  );

                                  if (solution?.solDesc != null &&
                                      solution?.solId != null) {
                                    solutionid = solution?.solId;
                                  }
                                } else {
                                  solutionDropdown = null;
                                  solutionid = null;
                                }
                              },
                              items: listofrootcausesolution
                                  ?.map((listofrootcausesolution) {
                                    return DropdownMenuItem<String>(
                                      onTap: () {
                                        setState(() {
                                          selectSolution =
                                              listofrootcausesolution.solDesc;
                                        });
                                      },
                                      value: listofrootcausesolution.solDesc,
                                      child: Text(
                                        listofrootcausesolution.solDesc ?? "",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 12.sp
                                              : 16.sp,
                                        ),
                                      ),
                                    );
                                  })
                                  .toSet()
                                  .toList()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Problem Status',
                                style: TextStyle(
                                    fontFamily: "lexend",
                                    fontSize:
                                        screenSize.width < 572 ? 12.sp : 16.sp,
                                    color: Colors.black54)),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: screenSize.height < 572 ? 35.h : 40.h,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: DropdownButtonFormField<String>(
                              value: problemStatusDropdown,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 5.h)),
                              hint: Text(
                                "Select",
                                style: TextStyle(
                                  fontSize:
                                      screenSize.width < 572 ? 12.sp : 16.sp,
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (String? newvalue) {
                                if (newvalue != null) {
                                  setState(() {
                                    problemStatusDropdown = newvalue;
                                  });

                                  final problemdesc = problemStatus?.firstWhere(
                                    (problemStatus) =>
                                        problemStatus.statusName == newvalue,
                                  );

                                  if (problemdesc?.statusName != null &&
                                      problemdesc?.statusId != null) {
                                    problemStatusid = problemdesc?.statusId;
                                  }
                                } else {
                                  problemStatusDropdown = null;
                                  problemStatusid = null;
                                }
                              },
                              items: problemStatus
                                  ?.map((problemStatus) {
                                    return DropdownMenuItem<String>(
                                      onTap: () {
                                        setState(() {
                                          selectProblemStatusDesc =
                                              problemStatus.statusName;
                                        });
                                      },
                                      value: problemStatus.statusName,
                                      child: Text(
                                        problemStatus.statusName ?? "",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 12.sp
                                              : 16.sp,
                                        ),
                                      ),
                                    );
                                  })
                                  .toSet()
                                  .toList()),
                        ),
                        (problemStatusid == 2 || problemStatusid == 4)
                            ? Column(
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Closed Time:',
                                        style: TextStyle(
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 12.sp
                                              : 16.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        lastupdatedTime != null
                                            ? lastupdatedTime!.substring(
                                                0, lastupdatedTime!.length - 3)
                                            : 'No Time Selected',
                                        style: TextStyle(
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 11.sp
                                              : 16.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      UpdateFromTime(
                                        onTimeChanged: (time) {
                                          setState(() {
                                            lastupdatedTime = time.toString();
                                          });
                                        },
                                        shiftFromTime: shiftStarttime ?? "",
                                        shiftToTime: shiftEndtime ?? "",
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : SizedBox(height: 5.h, child: Text("")),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40.h,
                          child: Row(
                            children: [
                              Text('Production Stoppage',
                                  style: TextStyle(
                                      fontFamily: "lexend",
                                      fontSize: screenSize.width < 572
                                          ? 12.sp
                                          : 16.sp,
                                      color: Colors.black54)),
                              SizedBox(
                                  width:
                                      screenSize.width < 572 ? 100.w : 150.w),
                              SizedBox(
                                width: screenSize.width < 572 ? 30.w : 50.w,
                                height: screenSize.height < 572 ? 10.w : 40.w,
                                child: Checkbox(
                                  value: isChecked,
                                  activeColor: Colors.green,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isChecked = newValue ?? false;
                                      productionStoppageid = isChecked ? 1 : 0;
                                    });
                                    print(
                                        "reworkvalue  ${productionStoppageid}");
                                    // Perform any additional actions here, such as updating the database
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: screenSize.width < 572 ? 270.w : 365.w,
                          height: 100.h,
                          child: CustomTextFormfield(
                            maxline: 5,
                            controller: incidentReasonController,
                            hintText: "Description",
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        SizedBox(
                          height: 20.w,
                        ),
                        (widget.showButton == true && widget.ipdincid != 0 )
                            ? CustomButton(
                                width: screenSize.width < 572 ? 80.w : 100.w,
                                height: screenSize.width < 572 ? 30.h : 40.h,
                                onPressed: () async {
                                  try {
                                    await updateProblemList(
                                      endTime: lastupdatedTime,
                                      fromtime: fromTime,
                                      incidentid: problemid,
                                      ipdincIpdid: widget.ipdid,
                                      ipdincid: widget.ipdincid,
                                      note: incidentReasonController.text,
                                      problemSolvedstatus: problemStatusid,
                                      productionstopage: productionStoppageid,
                                      rootcauseid: rootCauseid,
                                      solutionid: solutionid,
                                      subincidentId: problemCategoryid,
                                    );

                                    print("Problem list updated");

                                    // // Reset and update the list
                                    // final problemProvider = Provider.of<ListProblemStoringProvider>(context, listen: false);

                                    // problemProvider.reset();

                                    // final workstationProblem = Provider.of<WorkstationProblemProvider>(context, listen: false)
                                    //     .user
                                    //     ?.resolvedProblemInWs;

                                    // if (workstationProblem != null) {
                                    //   for (int i = 0; i < workstationProblem.length; i++) {
                                    //     ListOfWorkStationIncident data = ListOfWorkStationIncident(
                                    //       fromtime: workstationProblem[i].fromTime,
                                    //       endtime: workstationProblem[i].endTime,
                                    //       productionStoppageId: workstationProblem[i].productionStopageId,
                                    //       problemstatusId: workstationProblem[i].problemStatusId,
                                    //       problemsolvedName: workstationProblem[i].problemStatus,
                                    //       solutionId: workstationProblem[i].solId,
                                    //       solutionName: workstationProblem[i].solDesc,
                                    //       problemCategoryname: workstationProblem[i].subincidentName,
                                    //       problemId: workstationProblem[i].incidentId,
                                    //       problemName: workstationProblem[i].incidentName,
                                    //       problemCategoryId: workstationProblem[i].subincidentId,
                                    //       reasons: workstationProblem[i].ipdincNotes,
                                    //       rootCauseId: workstationProblem[i].ipdincIncrcmId,
                                    //       rootCausename: workstationProblem[i].incrcmRootcauseBrief,
                                    //       ipdId: workstationProblem[i].ipdincipdid,
                                    //       ipdIncId: workstationProblem[i].ipdincid,
                                    //       assetId: workstationProblem[i].incmAssetId,
                                    //     );
                                    //     problemProvider.addIncidentList(data);
                                    //   }
                                    // }
                                  } catch (e) {
                                    print("Error: $e");
                                  }
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      fontFamily: "lexend",
                                      fontSize:
                                          screenSize.width < 572 ? 12.w : 14.w,
                                      color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                              )
                            : (widget.showButton == true &&
                                    widget.ipdincid == 0)
                                ? Text("")
                                : CustomButton(
                                    width:
                                        screenSize.width < 572 ? 80.w : 100.w,
                                    height:
                                        screenSize.width < 572 ? 30.h : 40.h,
                                    onPressed: selectproblemname != null &&
                                            selectproblemCategoryname != null &&
                                            selectrootcausename != null
                                        ? () {
                                            setState(() {
                                              ListOfWorkStationIncident data =
                                                  ListOfWorkStationIncident(
                                                      fromtime: fromTime,
                                                      endtime: lastupdatedTime,
                                                      productionStoppageId:
                                                          productionStoppageid ??
                                                              0,
                                                      problemstatusId:
                                                          problemStatusid,
                                                      problemsolvedName:
                                                          selectProblemStatusDesc,
                                                      solutionId: solutionid,
                                                      solutionName:
                                                          selectSolution,
                                                      problemCategoryname:
                                                          selectproblemCategoryname,
                                                      problemId: problemid,
                                                      problemName:
                                                          selectproblemname,
                                                      problemCategoryId:
                                                          problemCategoryid,
                                                      reasons:
                                                          incidentReasonController
                                                              .text,
                                                      rootCauseId: rootCauseid,
                                                      rootCausename:
                                                          selectrootcausename,
                                                      ipdId: 0,
                                                      ipdIncId: 0,
                                                      assetId: widget.assetid);

                                              // final data = {
                                              //   "problemname":
                                              //       selectproblemname,
                                              //   "problemCategoryname":
                                              //       selectproblemCategoryname,
                                              //   "rootcausename":
                                              //       selectrootcausename,
                                              //   "incident_id": problemid,
                                              //   "subincident_id":
                                              //       problemCategoryid,
                                              //   "rootcause_id": rootCauseid,
                                              //   "reason":
                                              //       incidentReasonController
                                              //           .text
                                              // };

                                              Provider.of<ListProblemStoringProvider>(
                                                      context,
                                                      listen: false)
                                                  .addIncidentList(data);

                                              print(data);
                                            });
                                            Navigator.pop(context);
                                          }
                                        : null,
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width < 572
                                              ? 12.w
                                              : 16.w,
                                          color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                    borderRadius: BorderRadius.circular(50),
                                  )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
