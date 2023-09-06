import 'package:finder/api/servicesExport.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;
  CustomDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {

    final vw = MediaQuery.of(context).size.width;
    final vh = MediaQuery.of(context).size.height;

    return Drawer(
      width: vw * 0.66,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 83, 113, 255)
                  ),
                  child: Center(
                    widthFactor: vw * 0.5,
                    heightFactor: vw * 0.75,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: vw * 0.5,
                      height: vw * 0.75,
                    )
                  )
                ),
                ListTile(
                  title: InkWell(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Icon(
                            Icons.turn_right,
                            color: currentPage == "map" ?
                            Colors.blueAccent :
                            Colors.black,
                            size: 35,
                          )
                        ),
                        Text(
                          "주변 응급실 찾기",
                          style: TextStyle(
                            color: currentPage == "map" ?
                            Colors.blueAccent :
                            Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Sans KR'
                          )
                        )
                      ]
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/map');
                    }
                  )
                ),
                ListTile(
                  title: InkWell(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Icon(
                              Icons.medical_information_outlined,
                              color: currentPage == "user" ?
                              Colors.blueAccent :
                              Colors.black,
                              size: 35,
                            )
                          ),
                          Text(
                            "문진표",
                            style: TextStyle(
                            color: currentPage == "user" ?
                              Colors.blueAccent :
                              Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Sans KR'
                            )
                          )
                        ]
                      )
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/user/list');
                    }
                  )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: ListTile(
                  title: InkWell(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 35,
                            )
                          ),
                          Text(
                            "로그아웃",
                            style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Noto Sans KR'
                            )
                          )
                        ]
                      )
                    ),
                    onTap: () async {
                      SpringBootApiService api = SpringBootApiService(context: context);
                      await api.logout();
                      Navigator.pushReplacementNamed(context, '/auth/login');
                    }
                  )
                ),
              ),
            ),
          )        
        ],
      ),
    );
  }
}