import 'package:finder/api/SpringBootApiService.dart';
import 'package:finder/components/HospitalCard.dart';
import 'package:finder/pages/main/mainExport.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../components/componentsExport.dart' as components;

class EmergencyInfo {
  String name;
  String distance;
  String address;
  String tel;
  String arriveTime;
  int numberOfBeds;
  
  EmergencyInfo({
    required this.name,
    required this.distance,
    required this.address,
    required this.tel,
    required this.arriveTime,
    required this.numberOfBeds,
  });
}

class ListPage extends StatefulWidget {

  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late SpringBootApiService api;
  bool light = true;
  var vh = 0.0;
  var vw = 0.0;
  bool isRotating = false;
  final List<EmergencyInfo> datas = [
    EmergencyInfo(name: "세브란스병원0" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원1" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원2" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원3" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원4" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원5" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원6" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원7" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
    EmergencyInfo(name: "세브란스병원" ,distance:"1.4km",address: "서울시 서대문구 연세로 50-1",tel: "02-0000-0000" ,arriveTime: "오후 01시 30분",numberOfBeds : 8),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    api = SpringBootApiService(context: context);
  }

  void rotateIcon() {
    if (!isRotating) {
      controller.forward(from: 0.0);
      setState(() {
        isRotating = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        controller.reset();
        setState(() {
          isRotating = false;
        });
      });
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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            Switch(
              value: light,
              onChanged: (bool value) {
                if(value == false) {
                  Navigator.pushNamed(context, '/map');
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            rotateIcon();
          },
          tooltip: 'Reset Counter',
          backgroundColor: Color.fromARGB(255, 79, 112, 229),
          child: RotationTransition(
            turns: controller,
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: getUserLocation(),
            builder: (context, getLocationSnapshot) {
              if(getLocationSnapshot.hasData) {
                print(getLocationSnapshot.data!.latitude);
                print(getLocationSnapshot.data!.longitude);
                return FutureBuilder(
                  future: api.getHospitalsByList(
                    // lat: getLocationSnapshot.data!.latitude, 
                    // lon: getLocationSnapshot.data!.longitude
                    lat: 37.566352778, 
                    lon: 126.977952778
                  ),
                  builder: (context, getHospitalSnapshot) {
                    if(getHospitalSnapshot.hasData) {
                      print(getHospitalSnapshot.data!.length);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: 
                            ListView.separated(
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          hospitalId: 407,
                                          name: getHospitalSnapshot.data![index].name,
                                        ),
                                        fullscreenDialog: true,
                                      )
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    height: 0.2 * vh,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: HospitalCard(
                                      hospitalId: getHospitalSnapshot.data![index].hospitalId,
                                      name: getHospitalSnapshot.data![index].name,
                                      address: getHospitalSnapshot.data![index].address,
                                      representativeContact: getHospitalSnapshot.data![index].representativeContact,
                                      emergencyContact: getHospitalSnapshot.data![index].emergencyContact,
                                      hvec: getHospitalSnapshot.data![index].hvec,
                                      distance: getHospitalSnapshot.data![index].distance,
                                      arrivalTime: getHospitalSnapshot.data![index].arrivalTime,
                                      vh: vh,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) 
                                => const Divider(color: Colors.grey, height: 0.0, thickness: 0.2),
                              itemCount: getHospitalSnapshot.data!.length
                            ),
                      );
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                );
              }
              else {
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
        ),
        drawer: components.CustomDrawer(currentPage: 'map').build(context)
      ),
    );
  }
}