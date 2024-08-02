import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../constant/network_exception.dart';

class ApiConstant {
  //  static String baseUrl ="http://192.168.29.85:8080/AtmaIntegrationAPI/wsservice";

   static String baseUrl ="http://162.55.165.140:8080/AtmaInterfaceAPI/wsservice";

  static const String fromDate = "2023-08-01 10:00:00";
  static const String clientId = "vijay";

 static Future<dynamic> makeApiRequest({
    required dynamic requestBody,
    Duration timeoutDuration = const Duration(seconds: 5),
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        // ignore: avoid_print
        // print(jsonDecode(response.body));
        return jsonDecode(response.body);
      }
    } on TimeoutException {
      throw ("Sorry, the request took too long to process. Please try again later.");
    } catch (e) {
      //  print(e);
      if (e is SocketException) {
        throw NetworkException(
            'Failed to connect to the server. Please check your network connection.');
      } else if (e is http.ClientException) {
        rethrow;
      }
    }
  }

  static Future<dynamic> scannerApiRequest({
    required dynamic requestBody,
    Duration timeoutDuration = const Duration(seconds: 5),
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final responseMsg = responseJson['response_msg'];

        if (responseMsg == "Core System no response") {
          // Handle the "Core System no response" error
          final responseMsgDesc = responseJson['response_msg_desc'];
          throw Exception("Invalid barcode");
        }

        final responseData = responseJson['response_data'];

        return responseJson;
      } else {
        throw Exception("Invalid barcode");
      }
    } on TimeoutException {
      throw ("Sorry, the request took too long to process. Please try again later.");
    } on SocketException {
      throw NetworkException(
          'Failed to connect to the server. Please check your network connection.');
    } catch (e) {
      // Handle any other exceptions
      rethrow;
    }
  }


  static Future<dynamic> loginApiRequest({
    required dynamic requestBody,
    Duration timeoutDuration = const Duration(seconds: 5),
  }) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final responseMsg = responseJson['response_msg'];
        
        if (responseMsg != "Login access denied") {
          return responseJson;
        } else {
          throw http.ClientException(responseMsg);
        }
      } else {
        throw http.ClientException(
            'Failed to Login, status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ("Sorry, the request took too long to process. Please try again later.");
    } on SocketException {
      throw NetworkException(
          'Failed to connect to the server. Please check your network connection.');
    } catch (e) {
      // Handle any other exceptions
      rethrow;
    }
  }
}
