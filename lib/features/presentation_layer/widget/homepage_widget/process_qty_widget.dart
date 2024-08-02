import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:prominous/features/presentation_layer/api_services/actual_qty_di.dart';
import 'package:prominous/features/presentation_layer/api_services/plan_qty_di.dart';
import 'package:prominous/features/presentation_layer/provider/actual_qty_provider.dart';
import 'package:prominous/features/presentation_layer/provider/plan_qty_provider.dart';

class ProcessQtyWidget extends StatefulWidget {
  final int? id;
  final int? psid;
  const ProcessQtyWidget({super.key, required this.id, this.psid});

  @override
  State<ProcessQtyWidget> createState() => _ProcessQtyWidgetState();
}

class _ProcessQtyWidgetState extends State<ProcessQtyWidget> {
  ActualQtyService actualQtyService = ActualQtyService();
  PlanQtyService planQtyService = PlanQtyService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchActualQty();
  }

  Future<void> _fetchActualQty() async {
    try {
      await actualQtyService.getActualQty(
          context: context, id: widget.id ?? 0, psid: widget.psid ?? 0);

      await planQtyService.getPlanQty(
          context: context, id: widget.id ?? 0, psid: widget.psid ?? 0);

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        isLoading = true; // Set isLoading to true when data is fetched
      });
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
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
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: 170,
      child: Row(
        children: [
          Expanded(
            child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                alignment: Alignment.center,
                width: 245.w,
                height: 172.h,
                decoration: BoxDecoration(
                    color: Color.fromARGB(150, 235, 236, 255),
                    borderRadius:BorderRadius.circular(5.r),
             ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${planQty == null ? 0 : planQty}' ?? "0",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Lexend",
                            fontSize: 40.sp)),
                    Text('Planned Qty',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                          fontFamily: "Lexend",
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                width: 245.w,
                height: 172.h,
                decoration: BoxDecoration(
                    color: Color.fromARGB(150, 235, 236, 255),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${actualQty == null ? 0 : actualQty}" ?? "0",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Lexend",
                            fontSize: 40.sp)),
                    Text('Actual Qty',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                          fontFamily: "Lexend",
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                width: 245.w,
                height: 172.h,
                decoration: BoxDecoration(
                    color: Color.fromARGB(150, 235, 236, 255),
                    borderRadius: BorderRadius.all(Radius.circular(5.r))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        // '${((actualQty ?? 0) / (planQty ?? 1) * 100).toStringAsFixed(2)}%' ?? "0%",
              
                        "0",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Lexend",
                            fontSize: 40.sp)),
                    Text('Team Productivity',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                          fontFamily: "Lexend",
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child:Material(
        
        elevation: 3,
        borderRadius: BorderRadius.circular(5.r),
              child: Container(
                width: 245.w,
                height: 172.h,
                decoration: BoxDecoration(
                    color: Color(0x96EBECFF),
                    borderRadius: BorderRadius.all(Radius.circular(5.r))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('0%',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Lexend",
                            fontSize: 40.sp)),
                    Container(
                      alignment: Alignment.center,
                      child: Text('Forecasted Completion % ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                            fontFamily: "Lexend",
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
