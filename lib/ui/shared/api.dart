import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Api {
  final String URL = 'https://10.0.2.2:3000';
  final String URLVERSION = '/api/v1';
  final String ADDDRIVER = '/addDriver';
  final String LOGINDRIVER = '/loginDriver';
  final String ADDUSER = '/addUser';
  final String LOGINUSER = '/loginUser';
  final String GETBYEMAIL = '/getByEmail';

  Future<http.Response> registerUser(Map body) async {
    late http.Response response;
    try {
      response = await http.post(Uri.parse('users/register2'), body: body);
    } catch (error) {
      rethrow;
    }
    return response;
  }

  Future<List> filterUserByEmail(String email) async {
    print("FILTERING METHO CALLED");
    var response = await http.get(Uri.parse('$URL$URLVERSION/users'));
    List result = json.decode(response.body);
    List data = result.where((v) => v['email'] == email).toList();
    return data;
  }

  Future<http.Response> loginUser(Map body) async {
    var response = await http.get(Uri.parse('$URL$URLVERSION/users$LOGINUSER'));  

    return response;
  }
}
