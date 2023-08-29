import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class SpringBootApiService {
  static const String baseURL = '192.168.0.6';

  static Future<String> login({
    required String email,
    required String password
  }) async{
    final response = await http.post(
      Uri.parse("http://${baseURL}:8080/api/login"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization, X-Request-With',
        'Access-Control-Allow-Credentials': 'false',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    if(response.statusCode == 200) {
      Map<String, String> headers = response.headers;
      String jwt = headers['authorization']!;
      print("jwt ======> ${jwt}");
    }
    else {
      print('Failed to fetch data');
    }
    return response.body;
  }

  static Future<String> makeUser({
    required String email,
    required String password,
    required String name
  }) async {
    final response = await http.post(
      Uri.parse("http://${baseURL}:8080/api/signup"),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization, X-Request-With',
        'Access-Control-Allow-Credentials': 'false',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name
      }),
    );
    return response.body;
  }

}