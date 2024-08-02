import 'dart:ffi' as ffi;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prominous/features/presentation_layer/page/loginpage_layout.dart';
import 'package:prominous/features/presentation_layer/provider/edit_entry_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofempworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/listofworkstation_provider.dart';
import 'package:prominous/features/presentation_layer/provider/scanforworkstation_provider.dart';
import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/page/loginpage.dart';
import 'package:prominous/features/presentation_layer/page/prominous_login_page.dart';
import 'package:prominous/features/presentation_layer/provider/activity_provider.dart';
import 'package:prominous/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/asset_barcode_provier.dart';
import 'package:prominous/features/presentation_layer/provider/attendance_count_provider.dart';
import 'package:prominous/features/presentation_layer/provider/card_no_provider.dart';
import 'package:prominous/features/presentation_layer/provider/emp_details_provider.dart';
import 'package:prominous/features/presentation_layer/provider/emp_production_entry_provider.dart';
import 'package:prominous/features/presentation_layer/provider/employee_provider.dart';
import 'package:prominous/features/presentation_layer/provider/plan_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/process_provider.dart';
import 'package:prominous/features/presentation_layer/provider/shift_status_provider.dart';
import 'package:prominous/features/presentation_layer/provider/target_qty_provider.dart';
import 'features/presentation_layer/provider/allocation_provider.dart';
import 'features/presentation_layer/provider/login_provider.dart';
import 'features/presentation_layer/provider/product_provider.dart';
import 'features/presentation_layer/provider/recent_activity_provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context as BuildContext).size.width;

      SystemChrome.setPreferredOrientations(
  screenWidth < 576
          ? [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]
          : [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
  
  );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<ProcessProvider>(
          create: (_) => ProcessProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<EmployeeProvider>(
          create: (_) => EmployeeProvider(),
        ),
        ChangeNotifierProvider<AllocationProvider>(
          create: (_) => AllocationProvider(),
        ),
        ChangeNotifierProvider<EmpProductionEntryProvider>(
          create: (_) => EmpProductionEntryProvider(),
        ),
        ChangeNotifierProvider<EmpDetailsProvider>(
          create: (_) => EmpDetailsProvider(),
        ),
          ChangeNotifierProvider<RecentActivityProvider>(
          create: (_) => RecentActivityProvider(),
        ),
        ChangeNotifierProvider<ActivityProvider>(
          create: (_) => ActivityProvider(),
        ),
          ChangeNotifierProvider<ActualQtyProvider>(
          create: (_) => ActualQtyProvider(),
        ),
         ChangeNotifierProvider<AttendanceCountProvider>(
          create: (_) => AttendanceCountProvider(),
        ),
         ChangeNotifierProvider<PlanQtyProvider>(
          create: (_) => PlanQtyProvider(), 
        ),
            ChangeNotifierProvider<AssetBarcodeProvider>(
          create: (_) => AssetBarcodeProvider(),),
            ChangeNotifierProvider<CardNoProvider>(
          create: (_) => CardNoProvider(),),

           ChangeNotifierProvider<TargetQtyProvider>(
          create: (_) => TargetQtyProvider(),),
 ChangeNotifierProvider<ShiftStatusProvider>(
          create: (_) => ShiftStatusProvider(),),

          ChangeNotifierProvider<EditEntryProvider>(
          create: (_) => EditEntryProvider(),),
            ChangeNotifierProvider<ListofworkstationProvider>(
          create: (_) => ListofworkstationProvider(),),
                 ChangeNotifierProvider<ListofEmpworkstationProvider>(
          create: (_) => ListofEmpworkstationProvider(),),
                ChangeNotifierProvider<ScanforworkstationProvider>(
          create: (_) => ScanforworkstationProvider(),),

          

          
        
      ],
      child: ScreenUtilInit(
        builder:(_,child)=> MaterialApp(
            title: 'prominous Manufacturing',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color.fromARGB(255, 45, 54, 104)),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const LoginPageLayout()),
            designSize: MediaQuery.of(context as BuildContext).size.width<576 ?Size(360,760): Size(1296, 800),
      ),
    );
  }
}
