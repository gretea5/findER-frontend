import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finder/api/SpringBootApiService.dart';
import './UserDetailPage.dart';
import '../../components/componentsExport.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import '../../models/modelsExport.dart';

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];
  late SpringBootApiService api;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    api = SpringBootApiService(context: context);
    getUsers();
  }

  Future<void> getUsers() async {
    await api.getQuestionnaireList()
    .then((value) {
      setState(() {
        users = value;
      });
    });
  }

  void showDetail(User user) {
    setState(() {
      users = [];
    });
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
        body: FocusDetector(
          onFocusGained: () {
            getUsers();
          },
          child: Container(
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
        ),
        drawer: CustomDrawer(currentPage: 'user').build(context),
      ),
    );
  }
}