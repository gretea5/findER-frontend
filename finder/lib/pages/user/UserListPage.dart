import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/componentsExport.dart' as components;

class UserListPage extends StatefulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
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
          child: Container(
          
          )
        ),
        drawer: components.CustomDrawer(currentPage: 'user').build(context),
      ),
    );
  }
}