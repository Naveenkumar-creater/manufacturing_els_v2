// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:prominous/features/presentation_layer/api_services/login_di.dart';
// import 'package:prominous/features/presentation_layer/api_services/process_di.dart';
// import 'package:prominous/features/presentation_layer/provider/login_provider.dart';
// import 'package:prominous/features/presentation_layer/provider/process_provider.dart';

// var defaultBackgroundColor = Colors.grey[300];
// var appBarColor = Color(0xFF25476A);
// var myAppBar = AppBar(
//   backgroundColor: appBarColor,
//   title: Text(' '),
//   centerTitle: false,
// );
// var drawerTextColor = TextStyle(
//   fontSize: 14,
//   color: Colors.grey[600],
// );
// var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

// class MyDrawer extends StatefulWidget {
//   const MyDrawer({Key? key}) : super(key: key);

//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }

// class _MyDrawerState extends State<MyDrawer> {
//   ProcessApiService processApiService = ProcessApiService();
//   LoginApiService logout = LoginApiService();

//   @override
//   void initState() {
//     super.initState();
//     //processApiService.getProcessdetail(context: context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String toDate = DateFormat('dd-MM-yyyy ').format(now);
//     String toTime = DateFormat(' HH:mm:ss').format(now);

//     final processList =
//         Provider.of<ProcessProvider>(context).user?.listofProcessEntity;
//     final userName = Provider.of<LoginProvider>(context).user!.loginId;

//     return Drawer(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       backgroundColor: Colors.grey[300],
//       elevation: 0,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           children: [
//             DrawerHeader(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     '$userName',
//                     style: const TextStyle(fontSize: 24, color: Colors.black54),
//                   ),
//                   SizedBox(height: 4),
//                   Text(toDate, style: drawerTextColor),
//                   SizedBox(height: 4),
//                   Text(toTime, style: drawerTextColor),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: tilePadding,
//               child: ListTile(
//                 leading: Icon(Icons.settings),
//                 title: Text(
//                   'P R O C E S S',
//                   style: drawerTextColor,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               height: 250,
//               child: ListView.builder(
//                 itemCount: processList?.length ?? 0,
//                 itemBuilder: (context, index) => ListTile(
//                   leading: Text(''),
//                   title: Text(
//                     processList![index].processName ?? "",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   onTap: () {
//                     // final processId = processList[index].processId ?? 0;
//                     // if (processId != null) {
//                     //   // Handle onTap action
//                     // }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
