import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DetailPage extends StatefulWidget {
  String name;
  String distance;
  String address;
  String tel;
  String arriveTime;
  int numberOfBeds;

  DetailPage({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
    required this.tel,
    required this.arriveTime,
    required this.numberOfBeds,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int segmentedControlValue = 0;
  Set<Marker> markers = {}; // 마커 변수
  var vh = 0.0;
  var vw = 0.0;
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
          child: Column(
            children: [
              Container(
                height: vh * 0.4,
                child: KakaoMap(
                  onMapCreated: ((controller) async {
                    KakaoMapController mapController = controller;
                    mapController.setCenter(LatLng(37.3608681, 126.9306506));
                    markers.add(
                      Marker(
                        markerId: UniqueKey().toString(),
                        latLng: LatLng(37.3608681, 126.9306506),                          
                      )
                    );
                    setState(() {});
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
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
                            Text("${widget.address}"),
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
                          onTap: (){},
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
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("신촌역 인근"),
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
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${widget.tel}"),
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
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("잔여 병상 수"),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          "${widget.numberOfBeds}",
                          style: TextStyle(
                            color: Colors.red,
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
                              Text("${widget.distance}",
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
                                "${widget.arriveTime}",
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
                      selectedColor: Color(0xFF3469F0),
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
                    )
                  ],
                ),
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}