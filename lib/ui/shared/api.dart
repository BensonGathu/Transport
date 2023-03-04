import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Api {
  final String URL = 'http://192.168.3.102:3000';
  final String URLVERSION = '/api/v1';
  final String ADDDRIVER = '/addDriver';
  final String LOGINDRIVER = '/loginDriver';
  final String ADDUSER = '/addUser';
  final String LOGINUSER = '/loginUser';
  final String GETBYEMAIL = '/getByEmail';

  Future<http.Response> registerUser(Map body) async {
    late http.Response response;
     print("reg BODY");
      print(body);
    try {
      response = await http.post(Uri.parse('$URL$URLVERSION/users/$ADDUSER'),
          body: body);
      print("reg BODY");
      print(body);
      
    } catch (error) {
      rethrow;
    }
    return response;
  }

  Future<List> filterUserByEmail(String email) async {
    try {
      var response = await http.get(Uri.parse('$URL$URLVERSION/users'));
      print(response.body);
      List result = json.decode(response.body);
      List data = result.where((v) => v['email'] == email).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<http.Response> loginUser(Map body) async {
    late http.Response response;
    try {
      response = await http.post(Uri.parse('$URL$URLVERSION/users$LOGINUSER'),
          body: body);
    } catch (error) {
      rethrow;
    }
    return response;
  }
}
