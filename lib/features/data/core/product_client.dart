import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../constant/request_data_model/api_request_model.dart';
import 'api_constant.dart';

class ProductClient {
  dynamic getProductList(int id,int deptid, String token) async {
    ApiRequestDataModel requestData = ApiRequestDataModel(
        clientAuthToken: token, apiFor: "list_of_product_v1", processId: id,deptId: deptid);

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
          throw ("No Product");
        }

        return responseJson;
      } else {
        throw ("Product invalid ");
      }
    } on TimeoutException {
      throw ('Connection timed out. Please check your internet connection.');
    } catch (e) {
      throw ("Product invalid");
    }
  }
}