import 'package:d_chart/d_chart.dart';
import 'package:finder/models/hospitalDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HospitalDetailTrendInfo extends StatelessWidget {
  const HospitalDetailTrendInfo({
    super.key,
    required this.vh,
    required this.vw,
    required this.getHospitalDetailSnapshot
  });
  final AsyncSnapshot<HospitalDetailModel> getHospitalDetailSnapshot;
  final double vh;
  final double vw;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "최근",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "4",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3469F0),
                      ),
                    ),
                    Text(
                      "시간 중 병상을 이용 가능했던 시간은",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${getHospitalDetailSnapshot.data!.bedData.successTime}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3469F0),
                      ),
                    ),
                    Text(
                      " 입니다.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 0.4 * vh,
            width: 0.9 * vw,
            margin: EdgeInsets.only(top: 20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartPie(
                    data: [
                      {'domain': 'OnTime', 'measure': getHospitalDetailSnapshot.data!.bedData.percent},
                      {'domain': 'OffTime', 'measure': getHospitalDetailSnapshot.data!.bedData.otherPercent},
                    ],
                    fillColor: (pieData, index) {
                      switch(pieData['domain']) {
                        case 'OnTime':
                          return Color(0xFF5CDC2F);
                        default:
                          return Colors.white;
                      }
                    },
                    pieLabel: (pieData, index) {
                      return "${pieData['measure']}%";
                    },
                    labelFontSize: 18,
                    labelColor: Colors.black,
                    labelLineColor: Colors.black,
                  ),
                  
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Text(
              "최근 2시간 내 병상 추이",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 0.4 * vh,
            width: 0.9 * vw,
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                RotatedBox(quarterTurns: 3, child: Text('병상 수')),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: DChartLine(
                          lineColor: (lineData, index, id) {
                            return Color.fromARGB(255, 79, 112, 229);
                          },
                          data: [
                            {
                              'id': 'Line 1',
                              'data': [
                                {'domain': -120, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[0]},
                                {'domain': -105, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[1]},
                                {'domain': -90, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[2]},
                                {'domain': -75, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[3]},
                                {'domain': -60, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[4]},
                                {'domain': -45, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[5]},
                                {'domain': -30, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[6]},
                                {'domain': -15, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[7]},
                                {'domain': 0, 'measure': getHospitalDetailSnapshot.data!.bedData.twoAgoList[8]},
                              ],
                            },
                          ],
                          includePoints: true,
                        ),
                      ),
                      Text('분 전'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}