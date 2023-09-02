import 'package:finder/models/hospitalDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HospitalDetailInfo extends StatelessWidget {
  const HospitalDetailInfo({
    super.key,
    required this.themeColor,
    required this.bedColor,
    required this.getHospitalDetailSnapshot
  });

  final Color themeColor;
  final Color bedColor;
  final AsyncSnapshot<HospitalDetailModel> getHospitalDetailSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [               
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "구급차 가용 여부",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 7, top: 10),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ambulance.svg',
                  width: 20,
                  height: 20,
                  colorFilter: 
                  getHospitalDetailSnapshot.data!.ambulance ?
                    ColorFilter.mode(themeColor, BlendMode.srcIn)
                  :
                    ColorFilter.mode(bedColor, BlendMode.srcIn),
                ),
                SizedBox(width: 5),
                getHospitalDetailSnapshot.data!.ambulance ?
                Text(
                  "구급차 가용 가능",
                  style: TextStyle(
                    color: themeColor,
                  ),
                )
                :
                Text(
                  "구급차 가용 불가",
                  style: TextStyle(
                    color: bedColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "CT, MRI 가용 여부",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CT",
                      style: TextStyle(
                        color: getHospitalDetailSnapshot.data!.ct ? Color(0xFF3469F0) : Color(0xFFFF0000),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "MRI",
                      style: TextStyle(
                        color: getHospitalDetailSnapshot.data!.mri ? Color(0xFF3469F0) : Color(0xFFFF0000),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  children: [
                    Text(
                      getHospitalDetailSnapshot.data!.ct ? "O" : "X",
                      style: TextStyle(
                        color: getHospitalDetailSnapshot.data!.ct ? Color(0xFF3469F0) : Color(0xFFFF0000),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      getHospitalDetailSnapshot.data!.mri ? "O" : "X",
                      style: TextStyle(
                        color: getHospitalDetailSnapshot.data!.mri ? Color(0xFF3469F0) : Color(0xFFFF0000),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}