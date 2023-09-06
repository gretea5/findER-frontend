import 'package:finder/api/servicesExport.dart';
import 'package:finder/components/componentsExport.dart';
import 'package:finder/models/modelsExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finder/styles/Colors.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../components/componentsExport.dart' as components;

class MapPage extends StatefulWidget {
  MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final searchTextController = TextEditingController();
  final UrlLauncherService urlLauncherApi = UrlLauncherService();
  final KakaoApiService kakaoApiService = KakaoApiService();
  late SpringBootApiService api;
  KakaoMapController? mapController;
  bool light = false;
  bool markerClicked = false;
  bool cardVisible = false;
  int tappedMarkerId = 0;
  var vh = 0.0;
  var vw = 0.0;
  Set<Marker> markers = {}; 
  List<HospitalMarkerModel> areaMarkers = [];

  void removePreview() {
    if(markerClicked) {
      setState(() {
        markerClicked = false;
      });
    }
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
                  removePreview();
                  LatLng curPos = await urlLauncherApi.getUserLocation();
                  mapController!.setCenter(curPos);
                  mapController!.setLevel(3);
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
                future: urlLauncherApi.getUserLocation(),
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
                            removePreview();
                          },
                          onMapTap: (latLng) {
                            FocusScope.of(context).unfocus();
                            removePreview();
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
                              onTap: removePreview,
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
                                    await kakaoApiService.searchkeyword(
                                      query: searchTextController.text,
                                      context: context,
                                      mapController: mapController
                                    );
                                    searchTextController.text = "";
                                    removePreview();
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

