import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowError {
  
   static void showAlert(
    BuildContext? context,
    String message, [
    String headerTitle = "Error",
    String dialog = "Error",
    Color buttonColor = Colors.red,
  ]) {
    if (context != null) {
      // Define the custom header icon and color based on dialog type
      Widget customHeaderIcon;
      Color headerBackgroundColor;
      String buttontext;
         

      switch (dialog) {
        case "Success":
          customHeaderIcon = Icon(Icons.check_circle, color: Colors.white, size: 35.sp);
          headerBackgroundColor = Colors.green;
          buttontext="Ok";
          break;
        case "Warning":
          customHeaderIcon = Icon(Icons.warning, color: Colors.white, size: 35.sp);
          headerBackgroundColor = Colors.orange;
          buttontext="Ok";
          break;
        case "Info":
          customHeaderIcon = Icon(Icons.info, color: Colors.white, size: 35.sp);
          headerBackgroundColor = Colors.blue;
          buttontext="Ok";
          break;
        case "Error":
        default:
          customHeaderIcon = Icon(Icons.cancel, color: Colors.white, size: 35.sp);
          headerBackgroundColor = Colors.red;
           buttontext="Try Again";
          break;
      }

      showDialog(
        context: context,

        barrierDismissible: false, 
        builder: (BuildContext context) {
          return Dialog(
               shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // Adjust the radius as needed
      ),
            child: Padding(
              padding:  EdgeInsets.only(bottom: 12.sp),
              child: Container(
                width: 150.w, // Set your desired width
                       // Set your desired height
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                     height: 50.h,
                      decoration: BoxDecoration(
                        color: headerBackgroundColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)), // Keep top corners square
                      ),
                      child: Center(child: customHeaderIcon),
                    ),
                    
                    SizedBox(height: 20.h),
              
                    Padding(
                      padding: EdgeInsets.only(left:5.sp,right: 5.sp), // No padding
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Take only necessary space
                          children: [
                            // Text(
                            //   headerTitle,
                            //   style: TextStyle(color: Colors.black, fontSize: 25.sp),
                            //   textAlign: TextAlign.center,
                            // ),
                            SizedBox(height: 10.h), // Spacing between title and message
                            Text(
                              message,
                              style: TextStyle(color: Colors.black54,fontSize: 16.sp),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35.h), // Spacing before button
                    SizedBox(
                      width: 150.w,
                      height: 35.h,
                      child: ElevatedButton(
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          
                        ),
                        child: Text(buttontext,style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                         
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
  }
