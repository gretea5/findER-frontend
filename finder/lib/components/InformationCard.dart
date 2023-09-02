import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/modelsExport.dart';

class InformationCard extends StatelessWidget {

  final User user;
  final bool inList;

  InformationCard({super.key, required this.user, required this.inList});

  String showUserName() {
    if (inList)
      return user.name;
    else
      return user.name.replaceRange(1, 2, '*');
  }

  @override
  Widget build(BuildContext context) {
    final vw = MediaQuery.of(context).size.width;
    
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
                            showUserName(),
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
                            inList
                            ? '${user.age}세・(${user.gender})'
                            : '${user.age}세',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            )
                          )
                        ),
                      ],
                    ),
                    inList
                    ? Container(
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
                        user.familyRelations,
                        style: TextStyle(
                          color: Color.fromARGB(255, 79, 112, 229),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      )
                    )
                    : Container()
                  ]
                ),
                inList
                ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          'assets/icons/allergy.svg',
                          width: 27,
                          height: 27,
                          colorFilter: ColorFilter.mode(user.allergy != null ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: SvgPicture.asset(
                          'assets/icons/pill.svg',
                          width: 27,
                          height: 27,
                          colorFilter: ColorFilter.mode(user.medicine != null ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                        )
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 5.0),
                      //   child: SvgPicture.asset(
                      //     'assets/icons/surgical.svg',
                      //     width: 27,
                      //     height: 27,
                      //     colorFilter: ColorFilter.mode(user.surgery != null ? Color.fromARGB(255, 79, 112, 229) : Colors.grey, BlendMode.srcIn)
                      //   )
                      // ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.liquor_outlined,
                          size: 27,
                          color: user.drinkingCycle != null ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.smoking_rooms,
                          size: 27,
                          color: user.smokingCycle != null ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
                        )
                      )
                    ]
                  ),
                )
                : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          'assets/icons/allergy.svg',
                          width: 27,
                          height: 27,
                          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: SvgPicture.asset(
                          'assets/icons/pill.svg',
                          width: 27,
                          height: 27,
                          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: SvgPicture.asset(
                          'assets/icons/surgical.svg',
                          width: 27,
                          height: 27,
                          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.liquor_outlined,
                          size: 27,
                          color: Colors.grey
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.smoking_rooms,
                          size: 27,
                          color: Colors.grey
                        )
                      )
                    ]
                  ),
                ),
              ]
            ),
            flex: 90
          ),
          Flexible(
            child: inList 
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