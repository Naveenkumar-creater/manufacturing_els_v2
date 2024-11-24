import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowError {
  static void showAlert(
    BuildContext context, // Make sure to pass a valid context (e.g., from a parent widget)
    String message, [
    String headerTitle = "Error",
    String dialog = "Error",
    Color buttonColor = Colors.red,
  ]) {
    if (context.mounted) {
      // Define the custom header icon and color based on dialog type
      Widget customHeaderIcon;
      Color headerBackgroundColor;
      String buttonText;

      switch (dialog) {
        case "Success":
          customHeaderIcon = Icon(Icons.check_circle, color: Colors.white, size: 35);
          headerBackgroundColor = Colors.green;
          buttonText = "Ok";
          break;
        case "Warning":
          customHeaderIcon = Icon(Icons.warning, color: Colors.white, size: 35);
          headerBackgroundColor = Colors.orange;
          buttonText = "Ok";
          break;
        case "Info":
          customHeaderIcon = Icon(Icons.info, color: Colors.white, size: 35);
          headerBackgroundColor = Colors.blue;
          buttonText = "Ok";
          break;
        case "Error":
        default:
          customHeaderIcon = Icon(Icons.cancel, color: Colors.white, size: 35);
          headerBackgroundColor = Colors.red;
          buttonText = "Try Again";
          break;
      }

      // Using Future.delayed to ensure the context is valid
      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: headerBackgroundColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Center(child: customHeaderIcon),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  message,
                                  style: TextStyle(color: Colors.black54, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        SizedBox(
                          width:MediaQuery.of(context).size.width<576 ? 100.w:130.h,
                          height:MediaQuery.of(context).size.width< 576? 30.h : 35.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                            child: Text(buttonText, style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width<576 ? 12.sp:14.sp,)),
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
      });
    }
  }
}
