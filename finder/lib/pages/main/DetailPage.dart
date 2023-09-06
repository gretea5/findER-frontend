import 'package:finder/api/servicesExport.dart';
import 'package:finder/components/componentsExport.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finder/styles/Colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

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
  final UrlLauncherService urlLauncherApi = UrlLauncherService();
  final KakaoApiService kakaoApiService = KakaoApiService();
  Set<Marker> markers = {}; // 마커 변수
  var vh = 0.0;
  var vw = 0.0;
  var fontSize = 0.0;
  var lat = 37.582620285171856;
  var lon = 127.00819672835458;
  late SpringBootApiService api;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    api = SpringBootApiService(context: context);
    fontSize = vw * 0.04;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: themeColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: themeColor,
          centerTitle: true,
          title: Text(
            "${widget.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            color: Colors.white,
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
            future: urlLauncherApi.getUserLocation(),
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
                                          getHospitalDetailSnapshot.data!.address.length > 18 ? 
                                          "${getHospitalDetailSnapshot.data!.address.substring(0, 18)}..."
                                          :"${getHospitalDetailSnapshot.data!.address}",
                                          style: TextStyle(
                                            color: elementColor,
                                            fontSize: fontSize
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
                                                kakaoApiService.openKaKaoMap(
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
                                        fontSize: fontSize
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
                                      onTap: () => urlLauncherApi.launchCaller(urlLauncherApi.convertPhoneNumber(getHospitalDetailSnapshot.data!.representativeContact)),
                                      child: Text(
                                        "${getHospitalDetailSnapshot.data!.representativeContact}",
                                        style: TextStyle(
                                          color: elementColor,
                                          decoration: TextDecoration.underline,
                                          fontSize: fontSize
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
                                      'assets/icons/emergencyContact.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(elementColor, BlendMode.srcIn),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () => urlLauncherApi.launchCaller(urlLauncherApi.convertPhoneNumber(getHospitalDetailSnapshot.data!.emergencyContact)),
                                      child: Text(
                                        "${getHospitalDetailSnapshot.data!.emergencyContact}",
                                        style: TextStyle(
                                          color: elementColor,
                                          decoration: TextDecoration.underline,
                                          fontSize: fontSize
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
                                        fontSize: fontSize,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${getHospitalDetailSnapshot.data!.hvec}",
                                      style: TextStyle(
                                        color: bedColor,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  height: vh * 0.15,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      widget.name.length > 14 ?
                                        Column(
                                          children: [
                                            Text(
                                            "현위치에서",
                                            style: TextStyle(
                                              fontSize: fontSize * 1.3,
                                            ),
                                          ),
                                            Text(
                                              "${widget.name.substring(0, 14)}",
                                              style: TextStyle(
                                                fontSize: fontSize * 1.4,
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "${widget.name.substring(14)}까지는",
                                              style: TextStyle(
                                                fontSize: fontSize * 1.4,
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "현위치에서 ",
                                              style: TextStyle(
                                                fontSize: fontSize * 1.3,
                                              ),
                                            ),
                                            Text(
                                              "${widget.name}",
                                              style: TextStyle(
                                                fontSize: fontSize * 1.4,
                                                fontWeight: FontWeight.bold,
                                                color: themeColor,
                                              ),
                                            ),
                                            Text(
                                              " 까지는",
                                              style: TextStyle(
                                                fontSize: fontSize * 1.3,
                                              ),
                                            ),
                                          ],
                                        ),                      
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("${getHospitalDetailSnapshot.data!.distance}km",
                                            style: TextStyle(
                                              fontSize: fontSize * 1.4,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3469F0),
                                            ),
                                          ),
                                          Text(
                                            " 거리에 있으며, 예상 도착 시간은",
                                            style: TextStyle(
                                              fontSize: fontSize * 1.3,
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
                                              fontSize: fontSize * 1.4,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3469F0),
                                            ),
                                          ),
                                          Text(
                                            " 입니다.",
                                            style: TextStyle(
                                              fontSize: fontSize * 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                SegmentedControlContent(
                                  vw: vw,
                                  vh: vh,
                                  getHospitalDetailSnapshot: getHospitalDetailSnapshot
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
                            SizedBox()
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
                      SizedBox()
                    ],
                  )
                );
              }
            }, 
          ),
        ),
      );
  }
}