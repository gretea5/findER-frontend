import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final nameTextEditController = TextEditingController();
  final idTextEditController = TextEditingController();
  final pwTextEditController = TextEditingController();

  bool nameIsEmpty = true;
  bool idIsEmpty = true;
  bool pwIsEmpty = true;

  @override
  void initState() {
    super.initState();
    nameTextEditController.addListener(checkName);
    idTextEditController.addListener(checkId);
    pwTextEditController.addListener(checkPw);
  }

  void checkName() {
    setState(() {
      nameIsEmpty = !nameTextEditController.text.isEmpty && nameTextEditController.text.length > 1 ? false : true;
    });
  }

  void checkId() {
    setState(() {
      idIsEmpty = !idTextEditController.text.isEmpty && idTextEditController.text.length > 5 ? false : true;
    });
  }

  void checkPw() {
    setState(() {
      pwIsEmpty = !pwTextEditController.text.isEmpty && pwTextEditController.text.length > 7 ? false : true;
    });
  }

  bool checkAll() {
    return !nameIsEmpty && !idIsEmpty && !pwIsEmpty;
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
            child: Divider(color: Colors.black)
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
                        height: 30,
                        margin: EdgeInsets.only(top: 5.0),
                        child: TextField(
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
                          )
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "아이디",
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
                              color: idIsEmpty ? Colors.grey : Colors.green
                            )
                          ]
                        )
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(top: 5.0),
                        child: TextField(
                          controller: idTextEditController,
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
                          )
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
                        height: 30,
                        margin: EdgeInsets.only(top: 5.0),
                        child: TextField(
                          controller: pwTextEditController,
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
                          )
                        )
                      ),
                    ]
                  )
                ),
                Container(
                  width: 277,
                  height: 50,
                  margin: EdgeInsets.only(top: 50),
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