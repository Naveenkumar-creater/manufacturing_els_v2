import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:prominous/features/presentation_layer/widget/homepage_widget/employe_allocation_popup.dart';


import '../widget/homepage_widget/side_drawer.dart';

class PreviousHomePage extends StatefulWidget {
  const PreviousHomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PreviousHomePage> {
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: size.height,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideDrawer(
                    title: '',
                    //emp_mgr: 0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 400,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 50, left: 50),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Container(
                                      width: constraints.maxWidth / 2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: CircularPercentIndicator(
                                                animation: true,
                                                animationDuration: 2000,
                                                radius: 40,
                                                lineWidth: 8,
                                                percent: 0.8,
                                                progressColor:
                                                    Colors.deepPurple,
                                                backgroundColor:
                                                    Colors.deepPurple.shade200,
                                                circularStrokeCap:
                                                    CircularStrokeCap.round,
                                              ),
                                            ),
                                            const Text(
                                              'Attendance',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {},
                                                child: Text('View'))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                                height: 300,
                                width: 500,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                  
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
