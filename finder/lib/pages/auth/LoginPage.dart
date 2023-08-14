import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vh = MediaQuery.of(context).size.height;
    var vw = MediaQuery.of(context).size.width;

    final _idNode = FocusNode();
    final _pwNode = FocusNode();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
              Container(
                child: null,
                width: double.infinity,
                height: vh * 0.1,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(22.5, 3.0, 0.0, 30.0),
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
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 8.0
                          ),
                          hintText: '아이디를 입력하십시오',
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
                          _idNode.unfocus();
                        },
                        onTap: () {
                          _pwNode.unfocus();
                        },
                        focusNode: _idNode
                      )
                    ),
                  ]
                )
              ),Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(22.5, 3.0, 0.0, vh * 0.045),
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
                      height: 30,
                      child: TextField(
                        obscureText: true,
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
                          _pwNode.unfocus();
                        },
                        onTap: () {
                          _idNode.unfocus();
                        },
                        focusNode: _pwNode
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
                height: 100,
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '회원가입 없이 시작',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline
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