import 'package:flutter/material.dart';

class ShowError {

  static void showAlert(BuildContext? context, String message) {
    if (context != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(backgroundColor: Colors.white,
            title: const Text('Error'),
            content: Text(message,style:TextStyle(color: Colors.black) ,),
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

