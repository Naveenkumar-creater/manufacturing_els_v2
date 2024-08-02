import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mobile widget/mobile_login_widget.dart';






class LoginPageMobile extends StatelessWidget {
  const LoginPageMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: Container(

          
        //       width: double.infinity,
        //       color: Colors.white,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       // SizedBox(
        //       //     height: 100,
        //       //     child: SizedBox(
        //       //         height: 40,
        //       //         width: 100,
        //       //         child: Image.asset('assets/images/sujashoeilogo.png'))),
        //     ],
        //   ),
        // ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover, // Adjust as needed
              ),
            ),
          ),
          SingleChildScrollView(
                      child: Column(    
                       
          children: [
            // ShaderMask(
            //   shaderCallback: (Rect bounds) {
            //     return LinearGradient(
            //       colors: [
            //         Colors.green,
            //         Colors.blue,
            //       ], // Define your gradient colors
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ).createShader(bounds);
            //   },
            //   child: Text(
            //     'Suja Manufacturing',
            //     style: TextStyle(
            //         fontSize: 36.0,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white),
            //   ),
            // ),
                  
            
            // Padding(
            //   padding: EdgeInsets.only(right: 250),
            //   // child: Text(
            //   //   'Sign in to',
            //   //   style: TextStyle(
            //   //     color: Colors.black,
            //   //     fontSize: 24,
            //   //     fontWeight: FontWeight.w300,
            //   //   ),
            //   // ),
            // ),
                       
            // Padding(
            //   padding: EdgeInsets.only(right: 170),
            //   child: Text(
            //     'Your Account',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 28,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ),
                       
            // Text(
            //   'Hello there !',
            //   style: TextStyle(color: Colors.black54, fontSize: 18),
            // ),
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding:  EdgeInsets.only(top: 100.h,left: 20.w),
                     child: SizedBox(
                      height: 80.h,
                      child: Image.asset('assets/images/Prominous-logo-white.png')),
                   ),
                 ],
               ),
                  SizedBox(height: 50.h,),  
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(98, 225, 229, 255),
                borderRadius: BorderRadius.circular(5),
              ),
              width:300.w,
              height: 350.h,
              child: MobileLogin(),
                      
            ),
          ],
                      ),
                    ),
        ]));
  }
}

