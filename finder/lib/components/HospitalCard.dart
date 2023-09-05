import 'package:finder/api/servicesExport.dart';
import 'package:finder/pages/main/mainExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HospitalCard extends StatelessWidget {
  final UrlLauncherService urlLauncherApi = UrlLauncherService();
  final double vh;
  final Color elementColor = Color(0xFF787878);
  final Color bedColor = Color(0xFFFF0000);
  final int hospitalId;
  final String name;
  final String address;
  final String representativeContact;
  final String emergencyContact;
  final int? hvec; 
  final double distance;
  final String arrivalTime;

  HospitalCard({
    super.key,
    required this.hospitalId,
    required this.name,
    required this.address,
    required this.representativeContact,
    required this.emergencyContact,
    required this.hvec,
    required this.distance,
    required this.arrivalTime,
    required this.vh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name.length > 8 ? "${name.substring(0, 8)}.." : "$name", 
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
                  "${distance}km",
                  style: TextStyle(
                    color: elementColor,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () { 
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      //hospitalId: hospitalId
                      hospitalId: 406,
                      name: name,
                    ),
                    fullscreenDialog: true,
                  )
                );
              },
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
                    address.length > 16 ? "${address.substring(0, 16)}.." : "$address",
                    style: TextStyle(
                      color: elementColor,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.call,
                    size: 20,
                    color: elementColor,
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () => urlLauncherApi.launchCaller(urlLauncherApi.convertPhoneNumber(representativeContact)),
                    child: Text(
                      "$representativeContact",
                      style: TextStyle(
                        color: elementColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
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
                    "$arrivalTime",
                    style: TextStyle(
                      color: elementColor,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/emergencyContact.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(elementColor, BlendMode.srcIn),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: () => urlLauncherApi.launchCaller(urlLauncherApi.convertPhoneNumber(emergencyContact)),
                    child: Text(
                      "$emergencyContact",
                      style: TextStyle(
                        color: elementColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/bed.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(elementColor, BlendMode.srcIn),
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
                    width: 5,
                  ),
                  Text(
                    "$hvec",
                    style: TextStyle(
                      color: bedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}