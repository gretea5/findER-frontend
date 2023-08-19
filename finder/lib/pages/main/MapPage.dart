import 'package:finder/components/HospitalCard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../components/componentsExport.dart' as components;

class MapPage extends StatefulWidget {
  MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool light = true;
  bool markerClicked = false;
  bool cardVisible = false;
  KakaoMapController? mapController;
  Set<Marker> markers = {}; // 마커 변수
  var vh = 0.0;
  var vw = 0.0;
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
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text("병원 찾기"),
            backgroundColor: Color.fromARGB(255, 79, 112, 229),
            leading: DrawerButton(),
            actions: [ 
              IconButton(
                onPressed: () async {
                  LatLng curPos = await getUserLocation();
                  print("${curPos.latitude}");
                  mapController!.setCenter(curPos);
                },
                icon: Icon(Icons.my_location),
              ),
              Switch(
                value: light,
                activeColor: Colors.black,
                onChanged: (bool value) {
                  if(value == false) {
                    Navigator.pushNamed(context, '/list');
                  }
                },
              ),
            ],
          ),
          
          body: SafeArea(
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
                          markers.add(
                            Marker(
                              markerId: UniqueKey().toString(),
                              latLng: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),                          
                            )
                          );
                          setState(() {});
                        }),
                        onMarkerTap: (markerId, latLng, zoomLevel) {
                          if(!markerClicked) {
                            setState(() {
                              markerClicked = true;
                            });
                            mapController!.panTo(latLng);
                          }
                        },
                        onDragChangeCallback: (latLng, zoomLevel, dragType) {
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
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '지명을 검색하세요.',
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                color: Color.fromARGB(255, 79, 112, 229),
                                icon: Icon(Icons.search),
                                onPressed: () {
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
                      Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0,0,0, vh * 0.095),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 0.15 * vh,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: HospitalCard(
                          name: "세브란스병원",
                          distance:"1.4km",
                          address: "서울시 서대문구 연세로 50-1",
                          tel: "02-0000-0000",
                          arriveTime: "오후 01시 30분",
                          numberOfBeds : 8,
                          vh: vh
                        ),
                      ),
                      )
                      : const SizedBox()
                    ]
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          drawer: components.CustomDrawer(currentPage: 'map').build(context)
        ),
      ),
    );
  }
}

