import 'dart:convert';
import 'dart:io';
import 'package:finder/models/modelsExport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class SpringBootApiService {
  final String baseURL = '52.78.159.76';
  final BuildContext context;
  SpringBootApiService({
    required this.context
  });
  Future<String> login({
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
      String token = headers['authorization']!;
      String refreshToken = headers['authorization-refresh']!;
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("token", token);
      await preferences.setString("refreshToken", refreshToken);
      Navigator.pushReplacementNamed(context,'/map');
    }
    else {
      print('Failed to fetch data');
    }
    return response.body;
  }

  Future<String> signUp({
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

  Future<bool> emailValidate({
    required String email
  }) async {
    final response = await http.get(
      Uri.parse('http://${baseURL}:8080/api/emailValidation?email=${email}'),
    );

    if (response.statusCode.toString().startsWith('2')) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> refreshToken() async{
    final String apiUrl = 'http://${baseURL}:8080/api/refresh';
    final uri = Uri.parse(apiUrl);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final refreshToken = preferences.getString("refreshToken");
    final response = await http.get(
      uri,
      headers: {'Authorization-refresh': 'Bearer ${refreshToken}'},
    );
    if (response.statusCode == 200) {
      Map<String, String> headers = response.headers;
      String newToken = headers['authorization']!;
      await preferences.remove("token");
      await preferences.setString("token", newToken);
    }
    else if (response.statusCode == 401) {
      preferences.clear();
      //여기서 로그인 페이지로 이동
    }
    else {
      
    }
  }

  Future<List<HospitalMarkerModel>> getHospitalsByMap({
    required double swLat,
    required double swLon,
    required double neLat,
    required double neLon
  }) async{
    final List<HospitalMarkerModel> HospitalMarkerInstances = [];
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
    if (response.statusCode.toString().startsWith("2")) {
      final List<dynamic> list = jsonDecode(response.body);
      for(var element in list) {
        HospitalMarkerInstances.add(HospitalMarkerModel.fromJson(element));
      }
      return HospitalMarkerInstances;
    } 
    else if (response.statusCode == 401) {

    }
    else {
      print('Request failed with status: ${response.statusCode}');
    }
    throw Error();
  }

  Future<HospitalPreviewModel> getHospitalById({
    required int id,
    required double lat,
    required double lon
  }) async {
    final String apiUrl = 'http://${baseURL}:8080/api/hospitals/preview/${id}';
    final Map<String, String> queryParams = {
      'lat': lat.toString(),
      'lon': lon.toString(),
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${token}'},
    );
    if (response.statusCode == 200) {
      final instance = jsonDecode(response.body);
      return HospitalPreviewModel.fromJson(instance);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    throw Error();
  }

  Future<List<HospitalPreviewModel>> getHospitalsByList({
    required double lat,
    required double lon
  }) async {
    final List<HospitalPreviewModel> HospitalListInstances = [];
    final String apiUrl = 'http://${baseURL}:8080/api/hospitals/list';
    final Map<String, String> queryParams = {
      'lat': lat.toString(),
      'lon': lon.toString(),
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${token}'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      for(var element in list) {
        HospitalListInstances.add(HospitalPreviewModel.fromJson(element));
      }
      return HospitalListInstances;
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    throw Error();
  }

  Future<HospitalDetailModel> getHospitalDetailById({
    required int id,
    required double lat,
    required double lon
  }) async {
    final String apiUrl = 'http://${baseURL}:8080/api/hospitals/details/${id}';
    final Map<String, String> queryParams = {
      'lat': lat.toString(),
      'lon': lon.toString(),
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${token}'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      final instance = jsonDecode(response.body);
      return HospitalDetailModel.fromJson(instance);
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    throw Error();
  }

  Future<String> writeQuestionnaire(Map<String, dynamic> questionnaire) async {
    final String apiUrl = 'http://${baseURL}:8080/api/questionnaire';

    final uri = Uri.parse(apiUrl);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json'
        },
      body: jsonEncode(questionnaire)
    );

    if (response.statusCode.toString().startsWith('2')) {
      return response.body;
    }
    else if (response.statusCode == 401) {
      return '토큰 갱신 필요';
    }
    else {
      return '${response.statusCode} error';
    }
  }

  Future<List<User> >getQuestionnaireList() async {
    final String apiUrl = 'http://${baseURL}:8080/api/questionnaire';
    final uri = Uri.parse(apiUrl);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      }
    );

    if (response.statusCode.toString().startsWith('2')) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<User> users = [];
      for (var data in jsonData) {
        users.add(User.fromJson(data));
      }
      return users;
    } else {
      return [];
    }
  }

  Future<String> editQuestionnaire({
    required Map<String, dynamic> questionnaire, required int id
    }) async {
      final String url = 'http://${baseURL}:8080/api/questionnaire/${id.toString()}';
      final Uri uri = Uri.parse(url);
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer ${token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(questionnaire)
      );

      if (response.statusCode.toString().startsWith('2')) {
        return response.body;
      } else if (response.statusCode == 401) {
        return '토큰 갱신 필요';
      } else {
        return '문진표 수정 요청 실패';
      }
  }

  Future<String> deleteQuestionnaire({required int id}) async {
    final String url = 'http://${baseURL}:8080/api/questionnaire/${id.toString()}';
    final uri = Uri.parse(url);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer ${token}'
      }
    );

    if (response.statusCode.toString().startsWith('2')) {
      return response.body;
    } else if (response.statusCode == 401) {
      return '토큰 갱신 필요';
    } else {
      return '삭제 요청 실패';
    }
  }

  Future<String> requestLink({
    required String otherUserEmail,
    required String familyRelations
    }) async {
      final String url = 'http://${baseURL}:8080/api/questionnaire/link';
      final Uri uri = Uri.parse(url);
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String> {
          'linkedUserEmail': otherUserEmail,
          'familyRelations': familyRelations
        })
      );

      print('link: '+response.body);

      if (response.statusCode.toString().startsWith('2')) {
        return response.body;
      } else if (response.statusCode == 401) {
        return '토큰 갱신 필요';
      } else {
        return '연동 요청 실패';
      }
    }

  Future<String> waitLinkingResponse({
    required String otherUserEmail
    }) async {
      final String url = 'http://${baseURL}:8080/api/questionnaire/link?linkedUserEmail=${otherUserEmail}';
      final Uri uri = Uri.parse(url);
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${token}'
        }
      );

      print('wait: '+response.body);

      if (response.statusCode.toString().startsWith('2')) {
        return response.body;
      } else if (response.statusCode == 401) {
        return '토큰 갱신 필요';
      } else {
        return '문진표 연동 응답 대기 실패';
      }
    }
  
  Future<String> unlinkQuestionnaire({
    required String otherUserEmail
  }) async {
    final String url = 'http://${baseURL}:8080/api/questionnaire/unlink?linkedUserEmail=${otherUserEmail}';
    final Uri uri = Uri.parse(url);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer ${token}',
      }
    );

    print('unlink: '+response.body);

    if (response.statusCode.toString().startsWith('2')) {
      return response.body;
    } else if (response.statusCode == 401) {
      return '토큰 갱신 필요';
    } else {
      return '문진표 연동 해제 요청 실패';
    }
  }
}