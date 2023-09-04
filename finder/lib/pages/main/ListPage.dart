import 'dart:async';

import 'package:finder/api/SpringBootApiService.dart';
import 'package:finder/components/FloatingCountDownButton.dart';
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
  var vh = 0.0;
  var vw = 0.0;
  bool isRotating = false;
  bool light = true;
  bool countDownButtonVisible = false;
  
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
        countDownButtonVisible = false;
      });
      Future.delayed(Duration(seconds: 1), () {
        controller.reset();
        setState(() {
          isRotating = false;
          countDownButtonVisible = true;
        });
      });
    }
  }

  void startCountdown() {
    int secondsRemaining = 11;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
      } else {
        timer.cancel(); // 10초가 다 지나면 타이머를 취소합니다.
        setState(() {
          countDownButtonVisible = false;
          isRotating = false;
        });
      }
    });
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
        floatingActionButton: 
        !countDownButtonVisible  ?
          FloatingActionButton(
            onPressed: (){
              rotateIcon();
              startCountdown();
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
          )
        :
          FloatingCountDownButton(),
        body: SafeArea(
          child: FutureBuilder(
            future: getUserLocation(),
            builder: (context, getLocationSnapshot) {
              if(getLocationSnapshot.hasData) {
                print(getLocationSnapshot.data!.latitude);
                print(getLocationSnapshot.data!.longitude);
                return FutureBuilder(
                  future: api.getHospitalsByList(
                    lat: getLocationSnapshot.data!.latitude, 
                    lon: getLocationSnapshot.data!.longitude
                  ),
                  builder: (context, getHospitalSnapshot) {
                    if(getHospitalSnapshot.hasData) {
                      print("데이터 갱신!");
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
                                          hospitalId: 406,
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