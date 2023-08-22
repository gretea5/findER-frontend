import 'package:flutter/material.dart';
import '../models/User.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationCard extends StatelessWidget {

  final User user;
  final bool showArrow;

  InformationCard({super.key, required this.user, required this.showArrow});

  @override
  Widget build(BuildContext context) {
    final vw = MediaQuery.of(context).size.width;
    final vh = MediaQuery.of(context).size.height;

    return Container(
      width: vw * 0.9,
      height: 90,
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
      child: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            )
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(left: vw * 0.02),
                          child: Text(
                            '${user.age}세・(${user.sex})',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            )
                          )
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 45,
                      height: 20,
                      margin: EdgeInsets.only(left: vw * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0)),
                        border: Border.all(
                          width: 1.5,
                          color: Color.fromARGB(255, 79, 112, 229)
                        ),
                        color: Colors.white,
                      ),
                      child: Text(
                        user.relation,
                        style: TextStyle(
                          color: Color.fromARGB(255, 79, 112, 229),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      )
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.liquor_outlined,
                        size: 27,
                        color: user.drinking ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.smoking_rooms,
                        size: 27,
                        color: user.smoking ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: SvgPicture.asset(
                        'assets/icons/pill.svg',
                        width: 27,
                        height: 27,
                        colorFilter: ColorFilter.mode(user.drugs ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: SvgPicture.asset(
                        'assets/icons/allergy.svg',
                        width: 27,
                        height: 27,
                        colorFilter: ColorFilter.mode(user.allergy ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: SvgPicture.asset(
                        'assets/icons/surgical.svg',
                        width: 27,
                        height: 27,
                        colorFilter: ColorFilter.mode(user.surgery ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                      ),
                    )
                  ]
                )
              ]
            ),
            flex: 90
          ),
          Flexible(
            child: showArrow 
            ? Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
                size: 40,
                weight: 700
              )
            )
            : Container(),
            flex: 10
          )
        ]
      )
    );
  }
}