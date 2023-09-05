import 'package:finder/api/SpringBootApiService.dart';
import 'package:finder/pages/main/mainExport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HospitalPreview extends StatefulWidget {
  final int hospitalId;
  final double latitude;
  final double longitude;
  HospitalPreview({
    super.key,
    required this.hospitalId,
    required this.latitude,
    required this.longitude,
  });
  @override
  State<HospitalPreview> createState() => _HospitalPreviewState();
}

class _HospitalPreviewState extends State<HospitalPreview> {
  final Color elementColor = Color(0xFF787878);
  final Color bedColor = Color(0xFFFF0000);
  late SpringBootApiService api;
  var vh = 0.0;
  var vw = 0.0;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    api = SpringBootApiService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: api.getHospitalById(
        id: widget.hospitalId,
        lat: widget.latitude,
        lon: widget.longitude
      ),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.fromLTRB(0,0,0, vh * 0.095),
            child: Container(
              padding: EdgeInsets.all(8),
              height: 0.175 * vh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
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
                            snapshot.data!.name.length > 8 ? "${snapshot.data!.name.substring(0, 8)}.." : "${snapshot.data!.name}", 
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
                            "${snapshot.data!.distance}km",
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
                                //hospitalId: widget.hospitalId, 
                                hospitalId: 406,
                                name: snapshot.data!.name
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
                              snapshot.data!.address.length > 16 ? "${snapshot.data!.address.substring(0, 16)}.." : "${snapshot.data!.address}",
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
                              onTap: () => launchCaller(convertPhoneNumber(snapshot.data!.representativeContact)),
                              child: Text(
                                "${snapshot.data!.representativeContact}",
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
                              "${snapshot.data!.arrivalTime}",
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
                              onTap: () => launchCaller(convertPhoneNumber(snapshot.data!.emergencyContact)),
                              child: Text(
                                "${snapshot.data!.emergencyContact}",
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
                              "${snapshot.data!.hvec}",
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
              ),
            ),
          );
        }
        else {
          return SizedBox();
        }
      },
    );
  }
}