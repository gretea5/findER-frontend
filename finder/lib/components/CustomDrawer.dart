import 'package:finder/api/SpringBootApiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;
  CustomDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.7,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text("findER")
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
              ]
            ),
          ),
          Container(
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