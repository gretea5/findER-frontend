import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  emailNode.unfocus();
                  pwNode.unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: vh / 3.75,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'findER',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
              ),
              Container(
                child: null,
                width: double.infinity,
                height: vh * 0.1,
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
                        child: Text('로그인'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(Size(115, 45)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                            )
                          ),
                        ),
                        onPressed: () {
                          checkLoginFormat();
                          if (isLoginFormatCorrect) {
                            
                          }    
                          else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration()
                                );
                              }
                            );
                          }
                        },
                        
                      )
                    ),
                    TextButton(
                      child: Text('회원가입'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 169, 169, 169)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(Size(115, 45)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.5)
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
              Container(
                margin: EdgeInsets.only(bottom: vh * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: vw * 0.1,
                      decoration: BoxDecoration(border: Border.all(width: 0.1, color: Colors.grey))
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('또는', style: TextStyle(color: Colors.grey))
                    ),
                    Container(
                      width: vw * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1, color: Colors.grey)
                      )
                    )
                  ]
                )
              ),
              Container(
                width: 300,
                height: 50,
                child: InkWell(
                  child: Image.asset(
                    'assets/images/kakao_login_large_wide.png', 
                    width: 300, 
                    height: 50,
                    fit: BoxFit.contain
                  ),
                  onTap: () {
                    
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                )
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.04),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '회원가입 없이 시작',
                        style: TextStyle(
                          color: Colors.grey,
                          )
                        ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey, size: 12
                      )
                    ]
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/map');
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent
                )
              )
            ],
          )
        )
      )
    );
  }
}