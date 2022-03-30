import 'package:front_app/config/AppConfig.dart';
import 'package:front_app/models/User.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

mixin UserModel on Model {
  // User? _authUser;
  // String? _token;
  String apiBaseUrl = AppConfig.BASE_URL;
  //
  // User get authUser {
  //   return _authUser;
  // }

  Future<Map<String, dynamic>> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> data = {"token": token};
    final http.Response response = await http.post(
      Uri.parse(apiBaseUrl + "/logout"),
      body: json.encode(data),
      headers: {
        "Content-Type" : "application/json"
      }
    );
    if (response.statusCode != 500) {
      return {"error": false};
    }
    return {"error": true};
  }

  // Get Token
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> sendFCMTokenToServer(String token) async {
    String url = "/fcm/token";
    final Map<String, dynamic> reqData = {"fcm_token": token};
    try {
      final http.Response response = await http.post(
        Uri.parse(AppConfig.BASE_URL + url),
        body: json.encode(reqData),
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      return {"msg": resData["msg"]};
    } catch (e) {
      print(e);
      return {"error": true, "msg": e.toString()};
    }
  }

  Future<Map<String?, dynamic>> dashboard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse(apiBaseUrl + "/dashboard?token=${prefs.getString('token')}"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataFound = json.decode(response.body);
      num len = dataFound["data"].length;
      if (len == 0) {
        return {'success' : true, 'data': [] };
      }
      return {'success': true, 'data': dataFound['data']};
    } else {
      return {'success': false};
    }
  }


  Future<Map<String, dynamic>> changePassword(String password) async {
    final Map<String, dynamic> authData = {"password": password};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(apiBaseUrl);
    final http.Response response = await http.post(
      Uri.parse(apiBaseUrl + '/settings/changePassword?token=${prefs.getString('token')}'),
      body: json.encode(authData),
      headers: {"Content-Type" : "application/json"}
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> dataFound = json.decode(response.body);
      print(dataFound);
      return {'success': true, 'data': dataFound['message']};
    } else {
      return {'success': false};
    }
  }

  // Invalidate User
  void setAuthUserNull() {
    // _authUser = null;
  }


}