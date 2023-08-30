import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class SpringBootApiService {
  static const String baseURL = '192.168.0.8';

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
      print(headers);
      String token = headers['authorization']!;
      String refreshToken = headers['authorization-refresh']!;
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("token", token);
      await preferences.setString("refreshToken", refreshToken);
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

  static Future<void> getHospitals({
    required double swLat,
    required double swLon,
    required double neLat,
    required double neLon
  }) async{
    final String apiUrl = 'http://${baseURL}:8080/api/hospitals/map';
    final Map<String, String> queryParams = {
      'swLat': swLat.toString(),
      'swLon': swLon.toString(),
      'neLat': neLat.toString(),
      'neLon': neLon.toString(),
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${token}'},
    );
    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      // 응답이 실패했을 때 처리
      print('Request failed with status: ${response.statusCode}');
    }
  }
}