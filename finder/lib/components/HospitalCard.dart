import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HospitalCard extends StatelessWidget {
  final Color elementColor = Color(0xFF787878);
  final Color bedColor = Color(0xFFFF0000);
  String name;
  String distance;
  String address;
  String tel;
  String arriveTime;
  int numberOfBeds;

  HospitalCard({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
    required this.tel,
    required this.arriveTime,
    required this.numberOfBeds,
    required this.vh,
  });

  String convertPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll('-', '');
  }

  void launchCaller(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final double vh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 0.15 * vh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$name", 
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$distance",
                    style: TextStyle(
                      color: elementColor,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () { print("자세히 보기 클릭");},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "자세히 보기",
                      style: TextStyle(
                        color: elementColor,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: elementColor,
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: elementColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$address",
                      style: TextStyle(
                        color: elementColor,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    print("전화번호 클릭");
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        size: 20,
                        color: elementColor,
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: () => launchCaller(convertPhoneNumber(tel)),
                        child: Text(
                          "$tel",
                          style: TextStyle(
                            color: elementColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 20,
                      color: elementColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "예상 도착 시간",
                      style: TextStyle(
                        color: elementColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$arriveTime",
                      style: TextStyle(
                        color: elementColor,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    print("전화번호 클릭");
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        size: 20,
                        color: elementColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "잔여 병상 수",
                        style: TextStyle(
                          color: elementColor,
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        "$numberOfBeds",
                        style: TextStyle(
                          color: bedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}