import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prominous/features/presentation_layer/widget/login_widget/login_widget.dart';

class ProminousLoginPage extends StatelessWidget {
  const ProminousLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constrains){
        return Container(
        width: constrains.maxWidth,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(64),
                child: SizedBox(
                          height: 140,
                          child: Image.asset('assets/images/Prominous-logo-white.png'),),
              ),
            ],
          ),
                        
            Padding(
              padding: const EdgeInsets.only(right:128),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 350,
                height: 400,
                alignment: Alignment.center,
                child: const Login(),
              ),
            ),
          ],
        ),
      );
      })
    ));
  }
}