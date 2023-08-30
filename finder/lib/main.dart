import 'package:flutter/material.dart';
import 'package:finder/pages/auth/authExport.dart';
import 'package:finder/pages/main/mainExport.dart';
import 'package:finder/pages/user/userExport.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() {
  AuthRepository.initialize(appKey: '1cacbfac891fab7876d54b6d718d06de');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //화면 회전 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,),
      key: GlobalKey(),
      initialRoute: '/auth/login',
      routes: {
        '/': (context) => LoginPage(),
        '/map': (context) => MapPage(),
        '/list': (context) => ListPage(),
        '/auth/login': (context) => LoginPage(),
        '/auth/signup': (context) => SignUpPage(),
        '/user/list': (context) => UserListPage(),
        '/user/add': (context) => UserAddPage(),
      },
    );
  }
}