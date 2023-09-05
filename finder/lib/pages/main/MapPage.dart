import 'dart:convert';
import 'package:finder/api/SpringBootApiService.dart';
import 'package:finder/components/HospitalPreview.dart';
import 'package:finder/models/modelsExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../components/componentsExport.dart' as components;
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Color themeColor = Color.fromARGB(255, 79, 112, 229);
  final searchTextController = TextEditingController();
  KakaoMapController? mapController;
  final String apiUrl =
      "https://dapi.kakao.com/v2/local/search/keyword.json";
  final String restApiKey = "f5ab79d5d376224730ecd3b214369a8c";
  bool light = false;
  bool markerClicked = false;
  bool cardVisible = false;
  int tappedMarkerId = 0;
  var vh = 0.0;
  var vw = 0.0;
  Set<Marker> markers = {}; 
  Map<String, dynamic> responseData = {};
  late SpringBootApiService api;
  List<HospitalMarkerModel> areaMarkers = [];
  


  Future<void> searchkeyword(String query, BuildContext context) async {
    final response = await http.get(
      Uri.parse("$apiUrl?query=${Uri.encodeComponent(query)}"),
      headers: {"Authorization": "KakaoAK $restApiKey"},
    );
    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
      if(responseData["documents"].length == 0) {
        showSearchErrorDialog(context);
      }
      else {
        double searchLat = double.parse(responseData["documents"][0]['y']);
        double searchLon = double.parse(responseData["documents"][0]['x']);
        mapController!.setCenter(LatLng(searchLat, searchLon));
        mapController!.setLevel(3);
      }
    } else {
      showSearchErrorDialog(context);
    }
  }

  Future<LatLng> getUserLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied) {
        return LatLng(37.3608681, 126.9306506);
      }
    }
    if (status == LocationPermission.deniedForever) {
      return LatLng(37.3608681, 126.9306506);
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    api = SpringBootApiService(context: context);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void showSearchErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('검색 오류'),
          content: Text('입력하신 검색어를 찾을 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: themeColor
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "병원 찾기",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 79, 112, 229),
            leading: DrawerButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
            ),
            actions: [ 
              IconButton(
                onPressed: () async {
                  LatLng curPos = await getUserLocation();
                  mapController!.setCenter(curPos);
                },
                icon: Icon(Icons.my_location),
                color: Colors.white,
              ),
              Switch(
                value: light,
                activeColor: Colors.black,
                onChanged: (bool value) {
                  if(value == true) {
                    Navigator.pushNamed(context, '/list');
                  }
                },
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Icon(Icons.reorder);
                  }
                  return const Icon(Icons.map);
                },
              ),
              ),
            ],
          ),
          
          body: WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop(); // 앱 종료
              return false; // 뒤로 가기 이벤트를 무시
            },
            child: SafeArea(
              child: FutureBuilder(
                future: getUserLocation(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        KakaoMap(
                          onMapCreated: ((controller) async {
                            mapController = controller;
                            mapController!.setCenter(LatLng(snapshot.data!.latitude, snapshot.data!.longitude));
                            final bounds = await mapController!.getBounds();
                            final swLatLng = bounds.getSouthWest();
                            final neLatLng = bounds.getNorthEast();
                            areaMarkers = await api.getHospitalsByMap(
                              swLat: swLatLng.latitude,
                              swLon: swLatLng.longitude,
                              neLat: neLatLng.latitude,
                              neLon: neLatLng.longitude
                            );
                            print("onMapCreated called");
                            for(var areaMarker in areaMarkers) {
                              markers.add(
                                Marker(
                                  markerId: areaMarker.hospitalId.toString(),
                                  latLng: LatLng(areaMarker.lat, areaMarker.lon)
                                )
                              );
                            }
                            setState(() {});
                          }),
                          onMarkerTap: (markerId, latLng, zoomLevel) {
                            print("marker Tapped =====>${markerId}");
                            if(!markerClicked) {
                              setState(() {
                                tappedMarkerId = int.parse(markerId);
                                markerClicked = true;
                              });
                              mapController!.panTo(latLng);
                            }
                          },
                          onZoomChangeCallback: (zoomLevel, zoomType) async{
                            final bounds = await mapController!.getBounds();
                              final swLatLng = bounds.getSouthWest();
                              final neLatLng = bounds.getNorthEast();
                              areaMarkers = await api.getHospitalsByMap(
                                swLat: swLatLng.latitude,
                                swLon: swLatLng.longitude,
                                neLat: neLatLng.latitude,
                                neLon: neLatLng.longitude
                              );
                              print("onZoomChangeCallback DragType.end called");
                              for(var areaMarker in areaMarkers) {
                                markers.add(
                                  Marker(
                                    markerId: areaMarker.hospitalId.toString(),
                                    latLng: LatLng(areaMarker.lat, areaMarker.lon)
                                  )
                                );
                              }
                              setState(() {});
                          },
                          onDragChangeCallback: (latLng, zoomLevel, dragType) async{
                            if (dragType == DragType.end) {
                              final bounds = await mapController!.getBounds();
                              final swLatLng = bounds.getSouthWest();
                              final neLatLng = bounds.getNorthEast();
                              areaMarkers = await api.getHospitalsByMap(
                                swLat: swLatLng.latitude,
                                swLon: swLatLng.longitude,
                                neLat: neLatLng.latitude,
                                neLon: neLatLng.longitude
                              );
                              print("onDragChangeCallback DragType.end called");
                              for(var areaMarker in areaMarkers) {
                                markers.add(
                                  Marker(
                                    markerId: areaMarker.hospitalId.toString(),
                                    latLng: LatLng(areaMarker.lat, areaMarker.lon)
                                  )
                                );
                              }
                              setState(() {});
                            }
                            FocusScope.of(context).unfocus();
                            if(markerClicked) {
                              setState(() {
                                markerClicked = false;
                              });
                            }
                          },
                          onMapTap: (latLng) {
                            FocusScope.of(context).unfocus();
                            if(markerClicked) {
                              setState(() {
                                markerClicked = false;
                              });
                            }
                          },
                          markers: markers.toList(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: Colors.transparent,
                            width: vw * 0.95,
                            //height: vh * 0.1,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: searchTextController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: '지명을 검색하세요.',
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  color: Color.fromARGB(255, 79, 112, 229),
                                  icon: Icon(Icons.search),
                                  onPressed: () async {
                                    await searchkeyword(searchTextController.text, context);
                                    searchTextController.text = "";
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 79, 112, 229),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 79, 112, 229),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        markerClicked ?
                        HospitalPreview(
                          hospitalId: tappedMarkerId,
                          latitude: snapshot.data!.latitude,
                          longitude: snapshot.data!.longitude,
                        )
                        : const SizedBox()
                      ]
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor)
                    )
                  );
                },
              ),
            ),
          ),
          drawer: components.CustomDrawer(currentPage: 'map').build(context)
        ),
      );
  }
}

