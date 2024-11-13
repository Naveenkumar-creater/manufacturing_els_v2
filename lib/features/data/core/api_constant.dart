  import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../../constant/utilities/exception_handle/network_exception.dart';

class ApiConstant {
  
  static String baseUrl ="http://192.168.1.32:8080/AtmaIntegrationAPI/wsservice";
  
  //  static String baseUrl ="http://159.69.188.148:8080/AtmaInterfaceAPI/wsservice";

  static const String fromDate = "2023-08-01 10:00:00";
  static const String clientId = "vijay";


static Future<dynamic> makeApiRequest({
  required dynamic requestBody,
  Duration timeoutDuration = const Duration(seconds: 10),
}) async {
  final stopwatch = Stopwatch()..start();
  final requestStopwatch = Stopwatch();

  try {
    print("API request started");

    // Start measuring request time
    requestStopwatch.start();

    // Making the API request
    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        )
        .timeout(timeoutDuration);

    requestStopwatch.stop();

    // Stop the total stopwatch
    stopwatch.stop();

    // Log request time and response time
    print("Request time: ${requestStopwatch.elapsedMilliseconds} ms");
    print("Total API fetch time (request + response): ${stopwatch.elapsedMilliseconds} ms");

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw FormatException("Failed to decode JSON response: ${e.toString()}");
      }
    } else {
      throw HttpException(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  } on TimeoutException {
    throw TimeoutException("The request timed out. Please try again later.");
  } on SocketException {
    throw NetworkException('No internet connection. Please check your network.');
  } on HttpException catch (e) {
    throw Exception('HTTP error: ${e.message}');
  } on FormatException catch (e) {
    throw Exception('JSON format error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
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
        final stopwatch = Stopwatch()..start();
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      stopwatch.stop();
    
  print("API fetch time: ${stopwatch.elapsedMilliseconds} ms");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final responseMsg = responseJson['response_msg'];
        
        if (responseMsg != "Login access denied") {
          return responseJson;
        } else {
          throw http.ClientException("Invalid Username or Password");
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
