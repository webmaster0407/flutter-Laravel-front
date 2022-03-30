import 'package:front_app/scope_models/UserModel.dart';
import 'package:front_app/config/AppConfig.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppModel extends Model with UserModel {

  Future<Map<String, dynamic>> login (String? email, String? password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String url = "/auth";
    final Map<String, dynamic> credentials = {"email" : email, "password": password};

    try {
      final http.Response response = await http.post(
        Uri.parse(AppConfig.BASE_URL + url + "?token=${prefs.getString('token')}"),
        body: json.encode(credentials),
        headers: {"Content-Type": "application/json"}
      );
      final Map<String, dynamic> data = json.decode(response.body);
      return {"error": data["error"], "msg": data["token"]};
    } catch (e) {
      print(e);
      return {"error": true, "msg": e.toString()};
    }
  }
}