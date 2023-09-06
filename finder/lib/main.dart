import 'dart:async';
import 'package:gif_view/gif_view.dart';
import 'package:flutter/material.dart';
import 'package:finder/pages/auth/authExport.dart';
import 'package:finder/pages/main/mainExport.dart';
import 'package:finder/pages/user/userExport.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() {
  AuthRepository.initialize(appKey: '1cacbfac891fab7876d54b6d718d06de');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 79, 112, 229),
    
  ));
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        const Locale('en', 'US')
      ],
      initialRoute: '/auth/login',
      routes: {
        '/splash': (context) => SplashScreen(),
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vw = MediaQuery.of(context).size.width;
    final vh = MediaQuery.of(context).size.height;

    final GifController gifController = GifController(
      autoPlay: true,
      loop: false,
      onFinish: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) {
              return LoginPage();
            },
            transitionsBuilder: (context, animation1, animation2, child) {
              return child;
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero
          )
        );
      }
    );

    return Scaffold(
      body: Container(
        width: vw,
        height: vh,
        color: Color.fromARGB(255, 74, 115, 230),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GifView.asset(
              'assets/images/intro.gif',
              width: vw * 0.55,
              height: vw * 0.775,
              controller: gifController,
              frameRate: 30,
            )
          ]
        )
      ),
    );
  }
}