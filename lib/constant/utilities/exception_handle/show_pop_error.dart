import 'package:flutter/material.dart';

class ShowError {

  static void showAlert(BuildContext? context, String message,[ String ? headerTitle = "Error"]) {
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Colors.white,
            title:  Text(headerTitle ?? ""),
            content: Text(message,style:TextStyle(color: Colors.black),),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

