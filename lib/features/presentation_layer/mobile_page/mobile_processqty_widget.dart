import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/plan_qty_provider.dart';

class MobileProcessQtyWidget extends StatefulWidget {
  final int? id;
  final int? psid;
  const MobileProcessQtyWidget({super.key, required this.id, this.psid});

  @override
  State<MobileProcessQtyWidget> createState() => _MobileProcessQtyWidgetState();
}

class _MobileProcessQtyWidgetState extends State<MobileProcessQtyWidget> {
  ActualQtyService actualQtyService = ActualQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchActualQty();
  }

  Future<void> _fetchActualQty() async {
    try {
      await actualQtyService.getActualQty(
          context: context, id: widget.id ?? 0, psid: widget.psid ?? 0);

      await planQtyService.getPlanQty(
          context: context, id: widget.id ?? 0, psid: widget.psid ?? 0);
      setState(() {
        isLoading = true; // Set isLoading to false when data is fetched
      });
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching asset list: $e');
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final planQty = Provider.of<PlanQtyProvider>(context, listen: true)
        .user
        ?.planQtyCountEntity
        ?.planQty;

    final actualQty = Provider.of<ActualQtyProvider>(context, listen: true)
        .user
        ?.actualQtyCountEntity
        ?.actualQty;

    //  int? achivedProduct=;

    return Padding(
      padding:  EdgeInsets.only(top: 8.h,left: 8.w,right:8.w ),
      child: Container(
        width: double.infinity,
        height:220.h,
       
        child: Column(
          children: [
           Row(
  children: [
    Expanded(
      child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          alignment: Alignment.center,
          height: 100.h,
        
            decoration: BoxDecoration(
                            color: Color.fromARGB(150, 235, 236, 255),
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(width: 1.w, color: Color.fromARGB(150, 235, 236, 255))
                            
                            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                planQty?.toString() ?? "0",
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.black,
                  fontFamily: 'Lexend',
                ),
              ),
              Text(
                'Planned Qty',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    SizedBox(
      width: 8.w,
    ),
    Expanded(
      child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: Color.fromARGB(150, 235, 236, 255),
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              width: 1.w,
              color: Colors.grey.shade100,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                actualQty?.toString() ?? "0",
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.black,
                  fontFamily: 'Lexend',
                ),
              ),
              Text(
                'Actual Qty',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                  fontFamily: 'Lexend',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),

             SizedBox(
                  height: 8.h,
                ),
                     Row(
              children: [
                Expanded(
                  child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
                    child: Container(
                      alignment: Alignment.center,
                      height: 100.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(150, 235, 236, 255),
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(width: 1.w, color: Color.fromARGB(150, 235, 236, 255))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("0",
                              style:
                                  TextStyle(fontSize: 22.sp, color: Colors.black,fontFamily: 'Lexend')),
                          Text('Team Productivity',
                              style:
                                   TextStyle(fontSize: 14.sp, color: Colors.black54,fontFamily: 'Lexend')),
                        ],
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
                    child: Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        color:   Color.fromARGB(150, 235, 236, 255),
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(width: 1.w, color: Colors.grey.shade100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("0%",
                              style:  TextStyle(fontSize: 22.sp, color: Colors.black,fontFamily: 'Lexend')),
                          Text('Forecast Completion %',
                              style:  TextStyle(fontSize: 14.sp, color: Colors.black54,fontFamily: 'Lexend')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


          // SizedBox(
                //   width: 8,
                // ),
                  //                                                   Expanded(
                  //                                                     child: Container(
                  
                  //                                                       height: 170,
                  //                                                       decoration: BoxDecoration(
                  //                                                           color: Colors.white,
                  //                                                           borderRadius:
                  //                                                               BorderRadius.all(
                  //                                                                   Radius.circular(
                  //                                                                       8))),
                  //                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  //                                                         children: [
                  //                                                          Text(
                  //   // '${((actualQty ?? 0) / (planQty ?? 1) * 100).toStringAsFixed(2)}%' ?? "0%",
                  
                  // "0",
                  //                                                               style:
                  //                                                                   const TextStyle(
                  //                                                                       fontSize:
                  //                                                                           42,
                  //                                                                       color: Colors
                  //                                                                           .grey)),
                  //                                                                           Text('Team Productivity',
                  //                                                               style:
                  //                                                                   const TextStyle(
                  //                                                                       fontSize:
                  //                                                                           14,
                  //                                                                       color: Colors
                  //                                                                           .grey)),
                  //                                                         ],
                  //                                                       ),
                  //                                                     ),
                  //                                                   ),
                  //                                                   SizedBox(
                  //                                                     width: 8,
                  //                                                   ),
                  //                                                   Expanded(
                  //                                                     child: Container(
                  
                  //                                                       height: 170,
                  //                                                       decoration: BoxDecoration(
                  //                                                           color: Colors.white,
                  //                                                           borderRadius:
                  //                                                               BorderRadius.all(
                  //                                                                   Radius.circular(
                  //                                                                       8))),
                  //                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  //                                                         children: [
                  //                                                           Text(
                  //                                                             '0',
                  //                                                               style:
                  //                                                                   const TextStyle(
                  //                                                                       fontSize:
                  //                                                                           42,
                  //                                                                       color: Colors
                  //                                                                           .grey)),
                  //                                                                           Text('Forecast Completion Percentage ',
                  //                                                               style:
                  //                                                                   const TextStyle(
                  //                                                                       fontSize:
                  //                                                                           14,
                  //                                                                       color: Colors
                  //                                                                           .grey)),
                  //                                                         ],
                  //                                                       ),
                  //                                                     ),
                  //                                                   ),