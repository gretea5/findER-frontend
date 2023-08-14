import 'package:finder/pages/main/mainExport.dart';
import 'package:flutter/material.dart';
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

class _ListPageState extends State<ListPage> {
  bool light = false;
  var vh = 0.0;
  var vw = 0.0;
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
            Switch(
              value: light,
              onChanged: (bool value) {
                if(value == true) {
                  Navigator.pushNamed(context, '/map');
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Reset Counter',
          backgroundColor: Color.fromARGB(255, 79, 112, 229),
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          )
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
              child: 
                ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              name: datas[index].name,
                              distance: datas[index].distance,
                              address: datas[index].address,
                              tel: datas[index].tel,
                              arriveTime: datas[index].arriveTime,
                              numberOfBeds: datas[index].numberOfBeds,
                            ),
                            fullscreenDialog: true,
                          )
                        );
                      },
                      child: InfoCard(
                        name: datas[index].name,
                        distance: datas[index].distance,
                        address: datas[index].address,
                        tel: datas[index].tel,
                        arriveTime: datas[index].arriveTime,
                        numberOfBeds: datas[index].numberOfBeds,
                        vh: vh,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) 
                    => const Divider(color: Colors.grey, height: 0.0, thickness: 0.2),
                  itemCount: datas.length
                ),
          ),
        ),
        drawer: components.CustomDrawer(currentPage: 'map').build(context)
      ),
    );
  }
}