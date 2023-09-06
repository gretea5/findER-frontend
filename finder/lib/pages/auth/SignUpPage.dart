import 'package:finder/api/SpringBootApiService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  late SpringBootApiService api;

  int currentStep = 0;

  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController emailTextEditController = TextEditingController();
  TextEditingController pwTextEditController = TextEditingController();
  TextEditingController pwAgainTextEditController = TextEditingController();

  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final pwNode = FocusNode();
  final pwAgainNode = FocusNode();

  bool nameIsEmpty = true;
  bool emailIsEmpty = true;
  bool emailEnable = false;
  bool pwIsEmpty = true;
  bool pwAgainIsEmpty = true;

  @override
  void initState() {
    super.initState();
    nameTextEditController.addListener(checkName);
    emailTextEditController.addListener(checkEmail);
    pwTextEditController.addListener(checkPw);
    pwAgainTextEditController.addListener(checkPwAgain);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    api = SpringBootApiService(context: context);
  }

  void checkName() {
    setState(() {
      nameIsEmpty = !nameTextEditController.text.isEmpty && nameTextEditController.text.length > 1 ? false : true;
    });
  }

  void checkEmail() {
    setState(() {
      // emailIsEmpty = !emailTextEditController.text.isEmpty && emailTextEditController.text.length > 5 ? false : true;
      if (emailTextEditController.text.isEmpty && emailTextEditController.text.length < 4)
        emailIsEmpty = true;
      else
        emailIsEmpty = !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
        ).hasMatch(emailTextEditController.text);
    });
  }

  void checkPw() {
    setState(() {
      pwIsEmpty = !pwTextEditController.text.isEmpty && pwTextEditController.text.length > 7 ? false : true;
    });
  }

  void checkPwAgain() {
    setState(() {
      pwAgainIsEmpty = !(pwAgainTextEditController.text == pwTextEditController.text);
    });
  }

  bool checkFirstStep() {
    return !nameIsEmpty && !emailIsEmpty;
  }

  bool checkSecondStep() {
    return !pwIsEmpty;
  }

  bool checkAll() {
    return !nameIsEmpty && !emailIsEmpty && !pwIsEmpty && !pwAgainIsEmpty;
    //return !nameIsEmpty && !emailIsEmpty && emailEnable && !pwIsEmpty && !pwAgainIsEmpty;
  }

  Widget SignUpFirstStep() {
    return Container(
      alignment: Alignment.center,
      width: 277,
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "이름", 
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 24, 249),
                    fontWeight: FontWeight.bold
                    )
                  ),
                Icon(
                  Icons.check_circle,
                  fill: 1,
                  weight: 400,
                  grade: 0,
                  opticalSize: 14,
                  color: nameIsEmpty ? Colors.grey : Colors.green
                )
              ]
            )
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5.0),
            child: TextField(
              focusNode: nameNode,
              controller: nameTextEditController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              ),
              onTapOutside: (event) {
                nameNode.unfocus();
              }
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "이메일",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 24, 249),
                    fontWeight: FontWeight.bold
                  )
                ),
                Icon(
                  Icons.check_circle,
                  fill: 1,
                  weight: 400,
                  grade: 0,
                  opticalSize: 14,
                  color: emailIsEmpty ? Colors.grey : Colors.green
                )
              ]
            )
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5.0),
            child: TextField(
              controller: emailTextEditController,
              focusNode: emailNode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 4.0
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              ),
              onTapOutside: (event) {
                emailNode.unfocus();
              }
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0)),
                      color: Color.fromARGB(255, 79, 112, 229)
                    ),
                    child: Text(
                      '중복확인',
                      style: TextStyle(
                        color: Colors.white
                      )
                    )
                  ),
                  onTap: () {
                    api.emailValidate(
                      email: emailTextEditController.text
                    ).then((value) {
                      if (value) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle
                              ),
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                                ),
                                actionsPadding: EdgeInsets.only(bottom: 5.0),
                                title: Text('이메일 중복 확인'),
                                content: Text('사용 가능한 이메일입니다'),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        emailEnable = true;
                                      });
                                      Navigator.pop(context);
                                    }
                                  )
                                ]
                              )
                            );
                          }
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle
                              ),
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                                ),
                                actionsPadding: EdgeInsets.only(bottom: 5.0),
                                title: Text('이메일 중복 확인'),
                                content: Text('이미 존재하는 이메일입니다'),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      )
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        emailEnable = false;
                                      });
                                      Navigator.pop(context);
                                    }
                                  )
                                ]
                              )
                            );
                          }
                        );
                      }
                    });
                  }
                )
              ]
            )
          ),
        ]
      )
    );
  }

  Widget SignUpSecondStep() {
    return Container(
      alignment: Alignment.center,
      width: 277,
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "비밀번호",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 24, 249),
                    fontWeight: FontWeight.bold
                  )
                ),
                Icon(
                  Icons.check_circle,
                  fill: 1,
                  weight: 400,
                  grade: 0,
                  opticalSize: 14,
                  color: pwIsEmpty ? Colors.grey : Colors.green
                )
              ]
            )
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5.0),
            child: TextField(
              obscureText: true,
              controller: pwTextEditController,
              focusNode: pwNode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 4.0
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              ),
              onTapOutside: (event) {
                pwNode.unfocus();
              }
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "비밀번호 확인",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 24, 249),
                    fontWeight: FontWeight.bold
                  )
                ),
                Icon(
                  Icons.check_circle,
                  fill: 1,
                  weight: 400,
                  grade: 0,
                  opticalSize: 14,
                  color: pwAgainIsEmpty ? Colors.grey : Colors.green
                )
              ]
            )
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5.0),
            child: TextField(
              obscureText: true,
              controller: pwAgainTextEditController,
              focusNode: pwAgainNode,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 4.0
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 61, 128, 235),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(5),
                )
              ),
              onTapOutside: (event) {
                pwAgainNode.unfocus();
              }
            )
          ),
        ]
      )
    );
  }

  Widget CurrentStep() {
    if (currentStep == 0) {
      return SignUpFirstStep();
    } else {
      return SignUpSecondStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height - kToolbarHeight;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('회원가입'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: currentStep == 0
          ? BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }
          )
          : TextButton(
            child: Text(
              '이전',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold
              )
            ),
            onPressed: () {
              setState(() {
                currentStep--;
              });
            }
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 0.3, color: Colors.grey)
              )
            )
          )
        ),
        body: SafeArea(
          child: Container(
            width: vw,
            height: vh,
            margin: EdgeInsets.only(top: vh * 0.15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CurrentStep(),
                currentStep == 0
                ? Container(
                  width: 277,
                  height: 50,
                  margin: EdgeInsets.only(top: 70),
                  child: TextButton(
                    child: Text(
                      "다음",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      )
                    ),
                    style: ButtonStyle(
                      backgroundColor: checkFirstStep() ? 
                        MaterialStatePropertyAll<Color>(Colors.blue)
                        : MaterialStatePropertyAll<Color>(Colors.grey),
                      foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      )
                    ),
                    onPressed: checkFirstStep() ? () {
                      setState(() {
                        currentStep++;
                      });
                    } : null,
                  )
                )
                : Container(
                  width: 277,
                  height: 50,
                  margin: EdgeInsets.only(top: 70),
                  child: TextButton(
                    child: Text(
                      "회원가입",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      )
                    ),
                    style: ButtonStyle(
                      backgroundColor: checkAll() ? 
                        MaterialStatePropertyAll<Color>(Colors.blue)
                        : MaterialStatePropertyAll<Color>(Colors.grey),
                      foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      )
                    ),
                    onPressed: checkAll() ? () {
                      api.signUp(
                        email: emailTextEditController.text,
                        name: nameTextEditController.text,
                        password: pwTextEditController.text
                      ).then((value) {
                        if (value == '사용자 생성 완료') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle
                                ),
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                                  ),
                                  actionsPadding: EdgeInsets.only(bottom: 5.0),
                                  title: Text('회원가입'),
                                  content: Text('회원가입이 성공했습니다'),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        )
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    )
                                  ]
                                )
                              );
                            }
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle
                                ),
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                                  ),
                                  actionsPadding: EdgeInsets.only(bottom: 5.0),
                                  title: Text('회원가입'),
                                  content: Text('회원가입이 실패했습니다'),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                      });
                    } : null,
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}