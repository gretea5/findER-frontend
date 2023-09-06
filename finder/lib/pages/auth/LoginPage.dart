import 'dart:io';
import 'dart:convert';
import 'package:finder/api/SpringBootApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late SpringBootApiService api;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    api = SpringBootApiService(context: context);
  }  

  TextEditingController emailTextEditController = TextEditingController();
  TextEditingController pwTextEditController = TextEditingController();

  final emailNode = FocusNode();
  final pwNode = FocusNode();

  bool? isEmailFormatCorrect;
  bool isLoginFormatCorrect = false;

  void checkLoginFormat() {
    setState(() {
      if (emailTextEditController.text.isEmpty || emailTextEditController.text.length < 4)
        isEmailFormatCorrect = false;
      else
        isEmailFormatCorrect = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
        ).hasMatch(emailTextEditController.text);
    });
    setState(() {
      if (pwTextEditController.text.isEmpty || pwTextEditController.text.length < 8 || isEmailFormatCorrect != true)
        isLoginFormatCorrect = false;
      else
        isLoginFormatCorrect = true;
    });
  }

  String getLoginFailedReason() {
    if (isEmailFormatCorrect == false)
      return '잘못된 이메일입니다';
    else {
      return '비밀번호가 올바르지 않습니다';
    }
  }

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.white,
                margin: EdgeInsets.only(top: vh * 0.15, bottom: vh * 0.02),
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: vw * 0.4,
                  height: vw * 0.5,
                  fit: BoxFit.fitWidth
                )
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(22.5, 3.0, 0.0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: vw * 0.15,
                      child: Icon(
                        OctIcons.person_16,
                        size: 25,
                        color: Color.fromARGB(255, 17, 96, 224)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      width: vw * 0.625,
                      height: 40,
                      child: TextField(
                        controller: emailTextEditController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 8.0
                          ),
                          hintText: '이메일을 입력하십시오',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 182, 182, 182)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 61, 128, 235),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 61, 128, 235),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          )
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        onTapOutside:(event) {
                          emailNode.unfocus();
                        },
                        focusNode: emailNode
                      )
                    ),
                  ]
                )
              ),
              Container(
                child: Container(
                  height: 20,
                  child: Text(
                    isEmailFormatCorrect == false ? '※ 이메일 형식이 올바르지 않습니다.' : ' ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13
                    )
                  )
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(22.5, 0.0, 0.0, vh * 0.045),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: vw * 0.15,
                      child: Icon(
                        OctIcons.key_16,
                        size: 20.5,
                        color: Color.fromARGB(255, 17, 96, 224)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      width: vw * 0.625,
                      height: 40,
                      child: TextField(
                        obscureText: true,
                        controller: pwTextEditController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 8.0
                          ),
                          hintText: '비밀번호를 입력하십시오',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 182, 182, 182)
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 61, 128, 235),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 61, 128, 235),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 61, 128, 235),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          )
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        onTapOutside: (event) {
                          pwNode.unfocus();
                        },
                        focusNode: pwNode
                      )
                    ),
                  ]
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(vw * 0.075, 0.0, vw * 0.075, vh * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: vw * 0.05),
                      child: TextButton(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          )
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 79, 112, 229)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(Size(115, 45)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0))
                            )
                          ),
                        ),
                        onPressed: () {
                          checkLoginFormat();
                          if (isLoginFormatCorrect) {
                            api.login(
                              email: emailTextEditController.text,
                              password: pwTextEditController.text
                            );
                          }    
                          else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle
                                  ),
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.elliptical(12, 9)),
                                    ),
                                    actionsPadding: EdgeInsets.only(bottom: 5.0),
                                    title: Text('로그인 실패'),
                                    content: Text(getLoginFailedReason()),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          '확인',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }
                                      )
                                    ]
                                  )
                                );
                              }
                            );
                          }
                        },
                      )
                    ),
                    TextButton(
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        )
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 150, 150, 150)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(Size(115, 45)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0))
                          )
                        )
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth/signup');
                      }
                    )
                  ]
                )
              ),
              // Container(
              //   margin: EdgeInsets.only(bottom: vh * 0.03),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //         width: vw * 0.1,
              //         decoration: BoxDecoration(border: Border.all(width: 0.1, color: Colors.grey))
              //       ),
              //       Container(
              //         margin: EdgeInsets.symmetric(horizontal: 15.0),
              //         child: Text('또는', style: TextStyle(color: Colors.grey))
              //       ),
              //       Container(
              //         width: vw * 0.1,
              //         decoration: BoxDecoration(
              //           border: Border.all(width: 0.1, color: Colors.grey)
              //         )
              //       )
              //     ]
              //   )
              // ),
              // Container(
              //   width: 300,
              //   height: 50,
              //   child: InkWell(
              //     child: Image.asset(
              //       'assets/images/kakao_login_large_wide.png', 
              //       width: 300, 
              //       height: 50,
              //       fit: BoxFit.contain
              //     ),
              //     onTap: () {
                    
              //     },
              //     highlightColor: Colors.transparent,
              //     splashColor: Colors.transparent,
              //   )
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: vh * 0.04),
              //   child: InkWell(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Text(
              //           '회원가입 없이 시작',
              //           style: TextStyle(
              //             color: Colors.grey,
              //             )
              //           ),
              //         Icon(
              //           Icons.arrow_forward_ios,
              //           color: Colors.grey, size: 12
              //         )
              //       ]
              //     ),
              //     onTap: () {
              //       Navigator.pushReplacementNamed(context, '/map');
              //     },
              //     highlightColor: Colors.transparent,
              //     splashColor: Colors.transparent
              //   )
              // )
            ],
          )
        )
      )
    );
  }
}