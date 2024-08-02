// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
import 'package:provider/provider.dart';

import 'package:prominous/features/presentation_layer/api_services/login_di.dart';
import 'package:prominous/features/presentation_layer/provider/emp_details_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';

import '../../api_services/employee_di.dart';
import '../../api_services/process_di.dart';
import 'employee_details_list.dart';

class SideDrawer extends StatefulWidget {
  // final int emp_mgr;
  final String title;

  const SideDrawer({
    Key? key,
    //required this.emp_mgr,
    required this.title,
  }) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  ProcessApiService processApiService = ProcessApiService();
  LoginApiService logout = LoginApiService();
  EmployeeApiService employeeApiService = EmployeeApiService();

  @override
  void initState() {
    super.initState();
  final  deptId=Provider.of<LoginProvider>(context).user?.userLoginEntity?.deptId;
 processApiService.getProcessdetail(
        context: context, deptid: deptId ?? 0,
      );
  }

  @override
  Widget build(BuildContext context) {
    final processList = Provider.of<ProcessProvider>(context, listen: true)
        .user
        ?.listofProcessEntity;
    final emp_mgr = Provider.of<EmpDetailsProvider>(context, listen: true)
        .user
        ?.listofEmpDetailsEntity
        ?.first
        .empmgr;

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1a1f3c)),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1a1f3c)),
              accountName: Text(
                "SuperVisor",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text("supervisor@gmail.com",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_2_sharp,
                    color: Colors.grey,
                  )),
            ),
          ),
          Center(
              child: Text(
            "Process",
            style: TextStyle(fontSize: 18),
          )),
          ListTile(
            title: Column(
              children: [
                Container(
                  height: 450,
                  width: 200,
                  child: ListView.builder(
                    itemCount: processList?.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(processList?[index].processName ?? ""),
                        onTap: () {
                          // Call the function when the processName is tapped

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(' My Course '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text(' Go Premium '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Saved Videos '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              logout.logOutUser(context);
            },
          ),
        ],
      ),
    );
  }
}
