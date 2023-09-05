import 'dart:async';
import 'package:flutter/material.dart';

class FloatingCountDownButton extends StatefulWidget {
  const FloatingCountDownButton({super.key});

  @override
  State<FloatingCountDownButton> createState() => _FloatingCountDownButtonState();
}

class _FloatingCountDownButtonState extends State<FloatingCountDownButton> {
  final Color elementColor = Color(0xFF787878);
  int secondsRemaining = 10;
  bool isCounting = true;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    timer.cancel(); // 위젯이 dispose될 때 타이머를 해제합니다.
    super.dispose();
  }

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0 && isCounting) {
          secondsRemaining--;
        } else if (secondsRemaining == 0) {
          isCounting = false; // 카운트 멈춤
          secondsRemaining = 10; // 다시 10으로 설정
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (!isCounting) {
          setState(() {
            isCounting = true; // 버튼을 누르면 카운트를 다시 시작합니다.
            secondsRemaining = 10; // 카운트를 10으로 초기화합니다.
          });
        }
      },
      tooltip: 'Reset Countdown',
      backgroundColor: elementColor,
      child: Text(
        '$secondsRemaining',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}