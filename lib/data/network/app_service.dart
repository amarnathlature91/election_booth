import 'dart:async';
import 'dart:convert';

import 'package:election_booth/viewModel/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../app_exceptions/api_exception.dart';

class ApiService {
  // Get Method
  static Future<dynamic> get(String url, BuildContext context) async {
    var u = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer ${u.token}'});
      print('body from get : ${response.body}');
      return _handleResponse(response, context);
    } catch (e) {
      print(e.toString());
      return handleException(e, context);
    }
  }

  // Post Method
  static Future<dynamic> post(
      String url, dynamic body, BuildContext context) async {
    try {
      var u = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            if (u.token != null) 'Authorization': 'Bearer ${u.token}'
          },
          body: jsonEncode(body));
      print('Body from post : ${response.body}');
      return _handleResponse(response, context);
    } catch (e) {
      return handleException(e, context);
    }
  }

  // Put Method
  static Future<dynamic> put(
      String url, dynamic body, BuildContext context) async {
    try {
      var u = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            if (u.token != null) 'Authorization': 'Bearer ${u.token}'
          },
          body: jsonEncode(body));
      print('Body from post : ${response.body}');
      return _handleResponse(response, context);
    } catch (e) {
      return handleException(e, context);
    }
  }

  // Delete Method
  static Future<dynamic> delete(String url, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse(url));
      return _handleResponse(response, context);
    } catch (e) {
      return handleException(e, context);
    }
  }

  // Response Handler
  static dynamic _handleResponse(http.Response response, BuildContext context) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return Utils.tryDecode(response.body)['message'] != null
          ? jsonDecode(response.body)
          : {'error': 'unknown error'};
    }

    // switch (response.statusCode) {
    //   case 200:
    //     return jsonDecode(response.body);
    //   case 400:
    //     throw BadRequestException();
    //   case 401:
    //     throw UnauthorizedException();
    //   case 404:
    //     throw NotFoundException();
    //   case 500:
    //     throw ServerErrorException();
    //   default:
    //     var m = jsonDecode(response.body)['message'];
    //     if (m.toString().toLowerCase().contains('error')) {
    //       Utils.showError(context, m);
    //       throw ApiException('Error occurred: $m');
    //     }
    //     throw ApiException('Error occurred: ${response.statusCode}');
    // }
  }

  static dynamic handleException(dynamic exception, BuildContext context) {
    String errorMessage = "An unexpected error occurred";

    if (exception is BadRequestException) {
      errorMessage =
          "Bad Request: The request could not be understood by the server.";
    } else if (exception is UnauthorizedException) {
      Utils.showError(context, 'You are not authorized, please login again.');
      errorMessage =
          "Unauthorized: You are not authorized to access this resource.";
    } else if (exception is NotFoundException) {
      Utils.showError(context, 'Resource Not Found.');
      errorMessage = "Not Found: The requested resource could not be found.";
    } else if (exception is ServerErrorException) {
      Utils.showError(context, 'Internal Server Error.');
      errorMessage = "Server Error: An internal server error occurred.";
    } else if (exception is TimeoutException) {
      Utils.showError(context, 'Connection timed out.');
      errorMessage = "Request Timeout: The server took too long to respond.";
    } else if (exception is http.ClientException) {
      Utils.showError(context, 'Please check your internet connection');
      errorMessage = "Network Error: Please check your internet connection.";
    }

    if (kDebugMode) {
      print("Error: $errorMessage");
    }
    return {"error": errorMessage};
  }
}
