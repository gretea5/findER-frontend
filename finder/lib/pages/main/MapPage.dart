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
      home: Scaffold(
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
                          mapController!.setCenter(latLng);
                        }
                      },
                      onDragChangeCallback: (latLng, zoomLevel, dragType) {
                        if(markerClicked) {
                          setState(() {
                            markerClicked = false;
                          });
                        }
                      },
                      onMapTap: (latLng) {
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
                              onPressed: () {},
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
                    child: InfoCard(
                      name: "세브란스병원",
                      distance:"1.4km",
                      address: "서울시 서대문구 연세로 50-1",
                      tel: "02-0000-0000",
                      arriveTime: "오후 01시 30분",
                      numberOfBeds : 8,
                      vh: vh
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
    );
  }
}

class InfoCard extends StatelessWidget {
  String name;
  String distance;
  String address;
  String tel;
  String arriveTime;
  int numberOfBeds;

  InfoCard({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
    required this.tel,
    required this.arriveTime,
    required this.numberOfBeds,
    required this.vh,
  });

  final double vh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 0.15 * vh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$name", 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$distance",
                    style: TextStyle(
                      color: Color(0xFF787878),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () { print("자세히 보기 클릭");},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("자세히 보기"),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("$address")
                  ],
                ),
                InkWell(
                  onTap: () {
                    print("전화번호 클릭");
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        size: 20,
                      ),
                      SizedBox(width: 5,),
                      Text("$tel"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("예상 도착 시간"),
                    SizedBox(
                      width: 5,
                    ),
                    Text("$arriveTime")
                  ],
                ),
                InkWell(
                  onTap: () {
                    print("전화번호 클릭");
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("잔여 병상 수"),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        "$numberOfBeds",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}