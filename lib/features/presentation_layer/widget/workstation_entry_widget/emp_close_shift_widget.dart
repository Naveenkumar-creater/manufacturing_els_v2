import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prominous/constant/request_data_model/emp_close_shift_model.dart';
import 'package:prominous/features/data/core/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpClosesShift {
  static Future<void> empCloseShift(String apifor, int psid, int shiftstatus,
      String attid, int attstatus) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("client_token") ?? "";
    DateTime now = DateTime.now();
    //DateTime today = DateTime(now.year, now.month, now.day)
    int dt;

    dt = int.tryParse(attid ?? "") ?? 0;

    final requestBody = EmpCloseShift(
      apiFor: apifor,
      clientAuthToken: token,
      psid: psid,
      attShiftStatus: shiftstatus,
      attid: dt,
      attendenceStatus: attstatus,
    );

    final requestBodyjson = jsonEncode(requestBody.toJson());

    print(requestBodyjson);

    const timeoutDuration = Duration(seconds: 30);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBodyjson,
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          // loadEmployeeList();
          print(responseJson);
          return responseJson;
        } catch (e) {
          // Handle the case where the response body is not a valid JSON object
          throw ("Invalid JSON response from the server");
        }
      } else {
        throw ("Server responded with status code ${response.statusCode}");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    }
  }
}