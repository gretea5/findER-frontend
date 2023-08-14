import 'package:flutter/material.dart';
import 'package:finder/pages/auth/authExport.dart' as authExport;
import 'package:finder/pages/main/mainExport.dart' as mainExport;
import 'package:finder/pages/user/userExport.dart' as userExport;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,),
      key: GlobalKey(),
      initialRoute: '/user/list',
      routes: {
        '/': (context) => userExport.UserListPage(),
        '/map': (context) => mainExport.MapPage(),
        '/list': (context) => mainExport.ListPage(),
        '/auth/login': (context) => authExport.LoginPage(),
        '/auth/signup': (context) => authExport.SignUpPage(),
        '/user/list': (context) => userExport.UserListPage(),
        '/user/detail': (context) => userExport.UserDetailPage(),
        '/user/add': (context) => userExport.UserAddPage(),
      },
    );
  }
}

