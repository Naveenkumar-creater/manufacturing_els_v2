import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../constant/request_model.dart';
import 'api_constant.dart';

class EmpDetailsClient {
  dynamic getEmpDetails(String token) async {
    ApiRequestDataModel requestData = ApiRequestDataModel(
      clientAuthToken: token,
      apiFor: "emp_details_v1",
    );

    const timeoutDuration = Duration(seconds: 10);
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestData.toJson()),
          )
          .timeout(timeoutDuration);

      // ignore: avoid_print
      print(response.body);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final responseMsg = responseJson['response_msg'];

        if (responseMsg == "Core System no response") {
          // Handle the "Core System no response" error
          final responseMsgDesc = responseJson['response_msg_desc'];
          throw Exception("Core System Error: $responseMsgDesc");
        }

        final responseData = responseJson['response_data'];

        if (responseData.isEmpty) {
          // Handle the case where response_data is empty
          throw ("No Opeator");
        }

        return responseJson;
      } else {
        throw ("No Employee List");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      throw ("No Employee List");
    }
  }
}
