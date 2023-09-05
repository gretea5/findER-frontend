import 'dart:convert';
import 'package:finder/components/componentsExport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class KakaoApiService {
  final DialogFactory dialogFactory = DialogFactory();
  final String apiUrl =
      "https://dapi.kakao.com/v2/local/search/keyword.json";
  final String restApiKey = "f5ab79d5d376224730ecd3b214369a8c";
  Map<String, dynamic> responseData = {};

  Future<void> searchkeyword({
    required String query,
    required BuildContext context,
    required KakaoMapController? mapController
  }) async {
    final response = await http.get(
      Uri.parse("$apiUrl?query=${Uri.encodeComponent(query)}"),
      headers: {"Authorization": "KakaoAK $restApiKey"},
    );
    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
      if(responseData["documents"].length == 0) {
        dialogFactory.showSearchErrorDialog(context);
      }
      else {
        double searchLat = double.parse(responseData["documents"][0]['y']);
        double searchLon = double.parse(responseData["documents"][0]['x']);
        mapController!.setCenter(LatLng(searchLat, searchLon));
        mapController.setLevel(3);
      }
    } else {
      dialogFactory.showSearchErrorDialog(context);
    }
  }

  Future<void> openKaKaoMap({
    required String name,
    required double lat,
    required double lon
    }) async {
    var _url = 'https://map.kakao.com/link/to/$name,$lat,$lon';
    Uri url = Uri.parse(_url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}