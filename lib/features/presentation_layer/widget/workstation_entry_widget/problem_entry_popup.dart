import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/constant/request_data_model/incident_entry_model.dart';
import 'package:prominous/constant/utilities/customwidgets/custom_textform_field.dart';
import 'package:prominous/constant/utilities/customwidgets/custombutton.dart';
import 'package:prominous/features/data/model/listof_problem_category_model.dart';
import 'package:prominous/features/data/model/listof_problem_model.dart';
import 'package:prominous/features/data/model/listof_rootcaue_model.dart';
import 'package:prominous/features/domain/entity/listof_rootcause_entity.dart';
import 'package:prominous/features/domain/entity/listofproblem_catagory_entity.dart';
import 'package:prominous/features/presentation_layer/api_services/listofproblem_catagory_di.dart';
import 'package:prominous/features/presentation_layer/api_services/listofrootcause_di.dart';
import 'package:prominous/features/presentation_layer/provider/list_problem_storing_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_catagory_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofproblem_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofrootcause_provider.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';

class ProblemEntryPopup extends StatefulWidget {
  ProblemEntryPopup(
      {super.key,
      this.SelectProblemId,
      this.rootcauseid,
      this.problemcatagoryId,
      this.reason});

  final int? SelectProblemId;
  final int? rootcauseid;
  final int? problemcatagoryId;
  final String? reason;

  @override
  State<ProblemEntryPopup> createState() => _ProblemEntryPopupState();
}

class _ProblemEntryPopupState extends State<ProblemEntryPopup> {
  final ListofproblemCatagoryservice listofproblemCatagoryservice =
      ListofproblemCatagoryservice();
  final ListofRootCauseService listofRootCauseService =
      ListofRootCauseService();
  final TextEditingController incidentReasonController =
      TextEditingController();

  List<Map<String, dynamic>> submittedDataList = [];
  String? selectedName;
  String? selectproblemname;
  String? selectproblemcatagoryname;
  String? selectrootcausename;
  String? dropdownProduct;
  String? activityDropdown;
  String? problemDropdown;
  int? problemid;
  String? problemCatagoryDropdown;
  int? problemcatagoryid;
  String? rootCauseDropdown;
  int? rootCauseid;
  List<ListOfIncidentCatagoryEntity>? problemcatagory;
  List<ListrootcauseEntity>? listofrootcause;

  @override
  void initState() {
    super.initState();
    final listofproblem =
        Provider.of<ListofproblemProvider>(context, listen: false)
            .user
            ?.listOfIncident;
    final deptid = Provider.of<LoginProvider>(context, listen: false)
        .user
        ?.userLoginEntity
        ?.deptId;

    final listproblemcatagory = Provider.of<ListofproblemCatagoryProvider>(
      context,
      listen: false,
    ).user?.listOfIncidentcatagory;
    final listofroot =
        Provider.of<ListofRootcauseProvider>(context, listen: false)
            .user
            ?.listrootcauseEntity;

    if (widget.SelectProblemId != null) {
      listofproblemCatagoryservice.getListofProblemCatagory(
        context: context,
        deptid: deptid ?? 1,  
        incidentid: widget.SelectProblemId ?? 0,
      );

      problemcatagory = listproblemcatagory;
      final selectproblemname = listofproblem
          ?.firstWhere((problem) => problem.incmId == widget.SelectProblemId);

      if (selectproblemname != null) {
        problemDropdown = selectproblemname.incmName;
      }
    }

    if (widget.problemcatagoryId != null) {
      listofRootCauseService.getListofRootcause(
          context: context,
          deptid: deptid ?? 1057,
          incidentid: widget.problemcatagoryId ?? 0);

      listofrootcause = listofroot;

      final selectCatagory = listproblemcatagory?.firstWhere(
          (catagory) => catagory.incmId == widget.problemcatagoryId,
          orElse: () => ListOfIncidentCatagory(
                incmDesc: '',
                incmId: 0,
                incmMpmId: 0,
                incmName: "",
                incmParentId: 0,
              ));

      if (selectCatagory != null) {
        problemCatagoryDropdown = selectCatagory.incmName;
      }
    }

    if (widget.rootcauseid != null) {
      final rootcause = listofroot
          ?.firstWhere((rootcause) => rootcause.incrcmid == widget.rootcauseid);

      if (rootcause != null) {
        rootCauseDropdown = rootcause.incrcmrootcausebrief;
      }
    }

    incidentReasonController.text = widget?.reason ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final listofproblem =
        Provider.of<ListofproblemProvider>(context, listen: false)
            .user
            ?.listOfIncident;
    final deptid =
        Provider.of<LoginProvider>(context).user?.userLoginEntity?.deptId;

        Size screenSize = MediaQuery.of(context).size;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Color.fromARGB(150, 235, 236, 255),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Problem Description',
                style: TextStyle(
                    fontSize:screenSize.width<572? 18.sp:24.sp,
                    color: Color.fromARGB(255, 80, 96, 203),
                    fontFamily: "Lexend",
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Problem',
                              style: TextStyle(
                                  fontFamily: "lexend",
                                  fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                        width: screenSize.width<572 ? 200.w:300.w,
                        height: 50.h,
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
                          hint: Text("Select"),
                          isExpanded: true,
                          onChanged: (String? newvalue) async {
                            if (newvalue != null) {
                              setState(() {
                                problemDropdown = newvalue;
                                Provider.of<ListofRootcauseProvider>(context,
                                        listen: false)
                                    .reset();
                              });

                              final selectedProblem = listofproblem?.firstWhere(
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

                                await listofproblemCatagoryservice
                                    .getListofProblemCatagory(
                                  context: context,
                                  deptid: deptid ?? 1,
                                  incidentid: problemid ?? 0,
                                );

                                final listproblemcatagory =
                                    Provider.of<ListofproblemCatagoryProvider>(
                                  context,
                                  listen: false,
                                ).user?.listOfIncidentcatagory;

                                setState(() {
                                  problemcatagory = listproblemcatagory;
                                });
                              }
                            } else {
                              setState(() {
                                problemDropdown = null;
                                // Clear problemcatagory when no problem selected
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

                                          selectrootcausename = null;
                                        });
                                      },
                                      value: problemName.incmName,
                                      child: Text(
                                        problemName.incmName ?? "",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                          Text('Problem Catagory',
                              style: TextStyle(
                                  fontFamily: "lexend",
                                  fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                        width:screenSize.width<572 ? 200.w:300.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: problemCatagoryDropdown,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            border: InputBorder.none,
                          ),
                          hint: Text("Select"),
                          isExpanded: true,
                          onChanged: (String? newvalue) async {
                            if (newvalue != null) {
                              setState(() {
                                problemCatagoryDropdown = newvalue;
                              });

                              final selectproblemCatagory =
                                  problemcatagory?.firstWhere(
                                      (problemcatagory) =>
                                          problemcatagory.incmName == newvalue,
                                      orElse: () => ListOfIncidentCatagory(
                                            incmDesc: '',
                                            incmId: 0,
                                            incmMpmId: 0,
                                            incmName: "",
                                            incmParentId: 0,
                                          ));

                              if (selectproblemCatagory?.incmName != null &&
                                  selectproblemCatagory?.incmId != null) {
                                problemcatagoryid =
                                    selectproblemCatagory?.incmId;

                                await listofRootCauseService.getListofRootcause(
                                    context: context,
                                    deptid: deptid ?? 1057,
                                    incidentid: problemcatagoryid ?? 0);

                                final listofroot =
                                    Provider.of<ListofRootcauseProvider>(
                                            context,
                                            listen: false)
                                        .user
                                        ?.listrootcauseEntity;
                                setState(() {
                                  listofrootcause = listofroot;
                                });
                              }
                            } else {
                              setState(() {
                                problemCatagoryDropdown = null;
                                problemcatagoryid = 0;
                              });
                            }
                          },
                          items: problemcatagory
                                  ?.map((problemcatagory) {
                                    return DropdownMenuItem<String>(
                                      onTap: () {
                                        setState(() {
                                          selectproblemcatagoryname =
                                              problemcatagory.incmName;
                                        });
                                      },
                                      value: problemcatagory.incmName,
                                      child: Text(
                                        problemcatagory.incmName ?? "",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "lexend",
                                          fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                                  fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                        width:screenSize.width<572 ? 200.w :300.w,
                        height: 50.h,
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
                            hint: Text("Select"),
                            isExpanded: true,
                            onChanged: (String? newvalue) {
                              if (newvalue != null) {
                                setState(() {
                                  rootCauseDropdown = newvalue;
                                });

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
                                  }
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
                                    value: listofrootcause.incrcmrootcausebrief,
                                    child: Text(
                                      listofrootcause.incrcmrootcausebrief ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "lexend",
                                        fontSize: screenSize.width<572 ? 14.sp:16.sp,
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
                      SizedBox(
                        width: screenSize.width<572 ? 200.w : 300.w,
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
                      SizedBox(
                        height: 40.h,
                        child: CustomButton(
                          width: screenSize.width<572 ? 100.w: 130.w,
                          height: 50.h,
                          onPressed: selectproblemname != null &&
                                  selectproblemcatagoryname != null &&
                                  selectrootcausename != null
                              ? () {
                                  setState(() {
                                    ListOfWorkStationIncident data =
                                        ListOfWorkStationIncident(
                                            problemCatagoryname:
                                                selectproblemcatagoryname,
                                            problemId: problemid,
                                            problemName: selectproblemname,
                                            problemcatagoryId:
                                                problemcatagoryid,
                                            reasons:
                                                incidentReasonController.text,
                                            rootCauseId: rootCauseid,
                                            rootCausename: selectrootcausename);
                                    // final data = {
                                    //   "problemname":
                                    //       selectproblemname,
                                    //   "problemcatagoryname":
                                    //       selectproblemcatagoryname,
                                    //   "rootcausename":
                                    //       selectrootcausename,
                                    //   "incident_id": problemid,
                                    //   "subincident_id":
                                    //       problemcatagoryid,
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
                                }
                              : null,
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontFamily: "lexend",
                                fontSize: screenSize.width<572 ? 14.w:16.w,
                                color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
