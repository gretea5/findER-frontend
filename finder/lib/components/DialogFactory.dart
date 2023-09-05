import 'package:flutter/material.dart';
import 'package:finder/styles/Colors.dart';
class DialogFactory {
  
  void showSearchErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('검색 오류'),
          content: Text('입력하신 검색어를 찾을 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: themeColor
              ),
            ),
          ],
        );
      },
    );
  }
}