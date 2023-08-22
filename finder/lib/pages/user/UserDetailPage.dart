import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/User.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    final vw = MediaQuery.of(context).size.width;
    final vh = MediaQuery.of(context).size.height;

    void launchCaller(String telNumber) async {
      String url = 'tel:$telNumber';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.chevron_left,
              size: 35,
              color: Colors.black,
              weight: 700
            ),
            onTap: () {
              Navigator.pop(context);
            }
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black
            )
          ),
          actions: [
            TextButton(
              child: Text(
                '편집',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 112, 229),
                  fontSize: 16,
                )
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        ),
                        actionsPadding: EdgeInsets.only(bottom: 5.0),
                        title: Text('문진표 편집'),
                        content: Text('문진표를 편집하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: Text(
                              '수정',
                              style: TextStyle(
                                color: Color.fromARGB(255, 79, 112, 229)
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero
                                    ),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ),
                                      actionsPadding: EdgeInsets.only(bottom: 5.0),
                                      title: Text('문진표 수정'),
                                      content: Text('문진표를 수정하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            '수정',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 79, 112, 229)
                                            )
                                          ),
                                          onPressed: () {

                                          }
                                        ),
                                        TextButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                              color: Colors.black
                                            )
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }
                                        )
                                      ],
                                    )
                                  );
                                }
                              );
                            }
                          ),
                          TextButton(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.red
                              )
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero
                                    ),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ),
                                      actionsPadding: EdgeInsets.only(bottom: 5.0),
                                      title: Text('문진표 삭제'),
                                      content: Text('문진표를 삭제하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            '삭제',
                                            style: TextStyle(
                                              color: Colors.red
                                            )
                                          ),
                                          onPressed: () {

                                          }
                                        ),
                                        TextButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
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
                          ),
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Colors.black
                              )
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }
                          )
                        ],
                      )
                    );
                  }
                );
              }
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.3),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.3,
                  color: Colors.grey
                )
              )
            )
          )
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: vh * 0.01, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: vw * 0.02),
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )
                        ),
                      ),
                      Text(
                        '${user.age}세 · (${user.sex})',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18
                        )
                      )
                    ]
                  ),
                  Container(
                    width: 75,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color:Color.fromARGB(255, 213, 33, 20)
                      ),
                      borderRadius: BorderRadius.all(Radius.elliptical(6.0, 6.0)),
                      color: Colors.transparent,
                    ),
                    child: Text(
                      user.bloodType,
                      style: TextStyle(
                        color: Color.fromARGB(255, 213, 33, 20),
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ]
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: Color.fromARGB(255, 79, 112, 229),
                        size: 25,
                        weight: 700
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 7.5),
                        child: Text(
                          '전화번호',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )
                        )
                      )
                    ]
                  ),
                  InkWell(
                    onTap: () => launchCaller(user.tel),
                    child: Text(
                      user.tel,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.grey,
                        fontSize: 14
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}