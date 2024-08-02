import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prominous/features/presentation_layer/widget/login_widget/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                image: AssetImage('assets/images/prominousshoei.jpeg'),
                fit: BoxFit.cover)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(
                    height: 100,
                    child: SizedBox(
                        height: 150,
                        width: 250,
                        child: Image.asset('assets/images/prominousshoeilogo.png'))),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(224, 224, 224, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 350,
              height: 400,
              alignment: Alignment.center,
              child: const Login(),
            ),
          ],
        ),
      );
      })
    ));
  }
}