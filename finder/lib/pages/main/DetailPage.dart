import 'package:d_chart/d_chart.dart';
import 'package:finder/api/SpringBootApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailPage extends StatefulWidget {
  final int hospitalId;
  final String name;

  DetailPage({
    super.key,
    required this.hospitalId,
    required this.name
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Color themeColor = Color.fromARGB(255, 79, 112, 229);
  final Color elementColor = Color(0xFF787878);
  final Color bedColor = Color(0xFFFF0000);
  int segmentedControlValue = 0;
  Set<Marker> markers = {}; // 마커 변수
  var vh = 0.0;
  var vw = 0.0;
  var name = "한성대학교";
  var lat = 37.582620285171856;
  var lon = 127.00819672835458;
  late SpringBootApiService api;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    api = SpringBootApiService(context: context);
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
  
  String convertPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll('-', '');
  }

  void launchCaller(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: themeColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "${widget.name}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.chevron_left
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
            iconSize: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getUserLocation(),
            builder: (context, getLocationSnapShot) {
              if(getLocationSnapShot.hasData) {
                return FutureBuilder(
                  future: api.getHospitalDetailById(
                    id: widget.hospitalId,
                    lat: getLocationSnapShot.data!.latitude, 
                    lon: getLocationSnapShot.data!.longitude
                  ),
                  builder: (context, getHospitalDetailSnapshot) {
                    if (getHospitalDetailSnapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            height: vh * 0.4,
                            child: KakaoMap(
                              onMapCreated: ((controller) async {
                                KakaoMapController mapController = controller;
                                mapController.setCenter(LatLng(getHospitalDetailSnapshot.data!.lat, getHospitalDetailSnapshot.data!.lon));
                                markers.add(
                                  Marker(
                                    markerId: UniqueKey().toString(),
                                    latLng: LatLng(getHospitalDetailSnapshot.data!.lat, getHospitalDetailSnapshot.data!.lon),                          
                                  )
                                );
                                setState(() {});
                              }),
                              markers: markers.toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: elementColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          getHospitalDetailSnapshot.data!.address.length > 25 ? 
                                          "${getHospitalDetailSnapshot.data!.address.substring(0, 25)}..."
                                          :"${getHospitalDetailSnapshot.data!.address}",
                                          style: TextStyle(
                                            color: elementColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: getHospitalDetailSnapshot.data!.address
                                              ),
                                            );
                                            showToast("주소 복사 완료!");
                                          },
                                          child: Text(
                                            "주소복사",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: elementColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/kakao_navi.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      onTap: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          title: const Text('카카오맵 이동'),
                                          content: const Text('카카오맵 앱으로 이동하시겠습니까?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                openKaKaoMap(
                                                  name: getHospitalDetailSnapshot.data!.name,
                                                  lat: getHospitalDetailSnapshot.data!.lat,
                                                  lon: getHospitalDetailSnapshot.data!.lon
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: themeColor,
                                              ),
                                              child: const Text('OK'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'Cancel'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: themeColor,
                                              ),
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 20,
                                      color: elementColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${getHospitalDetailSnapshot.data!.simpleAddress}",
                                      style: TextStyle(
                                        color: elementColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 20,
                                      color: elementColor,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () => launchCaller(convertPhoneNumber(getHospitalDetailSnapshot.data!.representativeContact)),
                                      child: Text(
                                        "${getHospitalDetailSnapshot.data!.representativeContact}",
                                        style: TextStyle(
                                          color: elementColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/bed.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(elementColor, BlendMode.srcIn),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "현재 잔여 병상 수",
                                      style: TextStyle(
                                        color: elementColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${getHospitalDetailSnapshot.data!.hvec}",
                                      style: TextStyle(
                                        color: bedColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: vh * 0.13,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "현위치에서 ${widget.name}까지는",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${getHospitalDetailSnapshot.data!.distance}km",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF3469F0),
                                            ),
                                          ),
                                          Text(
                                            " 거리에 있으며, 예상 도착 시간은",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${getHospitalDetailSnapshot.data!.arrivalTime}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF3469F0),
                                            ),
                                          ),
                                          Text(
                                            " 입니다.",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: vw * 0.6,
                                  child: CupertinoSegmentedControl<int>(
                                  selectedColor: themeColor,
                                  borderColor: Colors.white,
                                  children: {
                                    0: Text('병원 정보'),
                                    1: Text('병상 추이'),
                                  },
                                  onValueChanged: (int val) {
                                    setState(() {
                                      segmentedControlValue = val;
                                    });
                                  },
                                  groupValue: segmentedControlValue,
                                  ),
                                ),
                                segmentedControlValue == 0 ? 
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [               
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Text(
                                            "구급차 가용 여부",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 7, top: 10),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/ambulance.svg',
                                                width: 20,
                                                height: 20,
                                                colorFilter: 
                                                getHospitalDetailSnapshot.data!.ambulance ?
                                                  ColorFilter.mode(themeColor, BlendMode.srcIn)
                                                :
                                                  ColorFilter.mode(bedColor, BlendMode.srcIn),
                                              ),
                                              SizedBox(width: 5),
                                              getHospitalDetailSnapshot.data!.ambulance ?
                                              Text(
                                                "구급차 가용 가능",
                                                style: TextStyle(
                                                  color: themeColor,
                                                ),
                                              )
                                              :
                                              Text(
                                                "구급차 가용 불가",
                                                style: TextStyle(
                                                  color: bedColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Text(
                                            "CT, MRI 가용 여부",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10, top: 10),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "CT",
                                                    style: TextStyle(
                                                      color: getHospitalDetailSnapshot.data!.ct ? Color(0xFF3469F0) : Color(0xFFFF0000),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "MRI",
                                                    style: TextStyle(
                                                      color: getHospitalDetailSnapshot.data!.mri ? Color(0xFF3469F0) : Color(0xFFFF0000),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 15),
                                              Column(
                                                children: [
                                                  Text(
                                                    getHospitalDetailSnapshot.data!.ct ? "O" : "X",
                                                    style: TextStyle(
                                                      color: getHospitalDetailSnapshot.data!.ct ? Color(0xFF3469F0) : Color(0xFFFF0000),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    getHospitalDetailSnapshot.data!.mri ? "O" : "X",
                                                    style: TextStyle(
                                                      color: getHospitalDetailSnapshot.data!.mri ? Color(0xFF3469F0) : Color(0xFFFF0000),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                :
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "최근",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "4",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF3469F0),
                                                    ),
                                                  ),
                                                  Text(
                                                    "시간 중 병상을 이용 가능했던 시간은",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "3시간 30분",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF3469F0),
                                                    ),
                                                  ),
                                                  Text(
                                                    " 입니다.",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 0.4 * vh,
                                          width: 0.9 * vw,
                                          margin: EdgeInsets.only(top: 20),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: DChartPie(
                                                  data: [
                                                    {'domain': 'OnTime', 'measure': 85},
                                                    {'domain': 'OffTime', 'measure': 15},
                                                  ],
                                                  fillColor: (pieData, index) {
                                                    switch(pieData['domain']) {
                                                      case 'OnTime':
                                                        return Color(0xFF5CDC2F);
                                                      default:
                                                        return Colors.white;
                                                    }
                                                  },
                                                  pieLabel: (pieData, index) {
                                                    return "${pieData['measure']}%";
                                                  },
                                                  labelFontSize: 18,
                                                  labelColor: Colors.black,
                                                  labelLineColor: Colors.black,
                                                ),
                                                
                                          )
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 40),
                                          child: Text(
                                            "최근 일주일간 평균 병상 추이",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 0.4 * vh,
                                          width: 0.9 * vw,
                                          margin: EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              RotatedBox(quarterTurns: 3, child: Text('Quantity')),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              child: Container(
                                                                width: 10,
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.amber,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('1시간'),
                                                          ],
                                                        ),
                                                        SizedBox(width: 5),
                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              child: Container(
                                                                width: 10,
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.blue,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Text('2시간'),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    AspectRatio(
                                                      aspectRatio: 16 / 10,
                                                      child: DChartLine(
                                                        lineColor: (lineData, index, id) {
                                                          return id == 'Line 1'
                                                              ? Colors.blue
                                                              : Colors.amber;
                                                        },
                                                        data: [
                                                          {
                                                            'id': 'Line 1',
                                                            'data': [
                                                              {'domain': 0, 'measure': 14},
                                                              {'domain': 20, 'measure': 11},
                                                              {'domain': 40, 'measure': 8},
                                                              {'domain': 60, 'measure': 5},
                                                              {'domain': 80, 'measure': 18},
                                                            ],
                                                          },
                                                          {
                                                            'id': 'Line 2',
                                                            'data': [
                                                              {'domain': 0, 'measure': 2},
                                                              {'domain': 20, 'measure': 5},
                                                              {'domain': 40, 'measure': 1},
                                                              {'domain': 60, 'measure': 1},
                                                              {'domain': 80, 'measure': 5},
                                                            ],
                                                          },
                                                        ],
                                                        includePoints: true,
                                                      ),
                                                    ),
                                                    Text('Day'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        )
                      );
                    }
                  },
                );
              }
              else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  )
                );
              }
            }, 
          ),
        ),
      ),
    );
  }
}