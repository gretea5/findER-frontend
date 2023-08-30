import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import './UserDetailPage.dart';
import '../../components/componentsExport.dart';
import '../../models/modelsExport.dart';

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];

  Future<void> getUsers() async {
    setState(() {
      users = [];
    });

    // String jsonString = await rootBundle.loadString('assets/datas/users.json');

    // List<dynamic> jsonList = jsonDecode(jsonString);


    // setState(() {
    //   for (dynamic json in jsonList) {
    //     print(json);
    //     users.add(User.fromJson(json));
    //   }
    // });
  }

  void showDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: user)
      )
    );
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      print('Android: ${MediaQuery.of(context).size.width.toString()}');
    } else {
      print('iOS: ${MediaQuery.of(context).size.width.toString()}');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 79, 112, 229),
          elevation: 0,
          leading: DrawerButton(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                weight: 700,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/user/add');
              },
            )
          ],
          title: Text(
            "문진표",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Sans KR',
            )
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print(users[index].name);
                  showDetail(users[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.6
                      )
                    )
                  ),
                  child: InformationCard(
                    inList: true,
                    user: users[index]
                  ),
                ),
              );
            },
          )
        ),
        drawer: CustomDrawer(currentPage: 'user').build(context),
      ),
    );
  }
}