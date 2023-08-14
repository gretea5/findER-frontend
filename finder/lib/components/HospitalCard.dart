import 'package:flutter/material.dart';

class HospitalCard extends StatelessWidget {
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
                      color: Color(0xFF787878),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () { print("자세히 보기 클릭");},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("자세히 보기"),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
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
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("$address")
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
                      ),
                      SizedBox(width: 5,),
                      Text("$tel"),
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
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("예상 도착 시간"),
                    SizedBox(
                      width: 5,
                    ),
                    Text("$arriveTime")
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
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("잔여 병상 수"),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        "$numberOfBeds",
                        style: TextStyle(
                          color: Colors.red,
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