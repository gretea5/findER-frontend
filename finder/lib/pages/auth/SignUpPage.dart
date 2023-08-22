import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController emailTextEditController = TextEditingController();
  TextEditingController pwTextEditController = TextEditingController();

  final nameNode = FocusNode();
  final emailNode = FocusNode();
  final pwNode = FocusNode();

  bool nameIsEmpty = true;
  bool emailIsEmpty = true;
  bool pwIsEmpty = true;

  @override
  void initState() {
    super.initState();
    nameTextEditController.addListener(checkName);
    emailTextEditController.addListener(checkEmail);
    pwTextEditController.addListener(checkPw);
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

  bool checkAll() {
    return !nameIsEmpty && !emailIsEmpty && !pwIsEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height - kToolbarHeight;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
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
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 277,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        margin: EdgeInsets.only(top: 20),
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
                    ]
                  )
                ),
                Container(
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
                      Navigator.pop(context);
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