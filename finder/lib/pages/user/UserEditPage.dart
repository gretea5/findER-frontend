import 'dart:async';
import 'dart:convert';
import 'package:finder/api/SpringBootApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpostal/kpostal.dart';
import 'package:http/http.dart' as http;
import '../../components/componentsExport.dart';
import '../../models/modelsExport.dart';


class UserEditPage extends StatefulWidget {
  final User user;

  UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState(user: user);
}

class _UserEditPageState extends State<UserEditPage> with SingleTickerProviderStateMixin{

  final User user;

  _UserEditPageState({required this.user});

  late SpringBootApiService api;

  final bodyScrollController = ScrollController();

  double offset = 0;

  int currentStep = 0;

  var vw = 0.0;
  var vh = 0.0;
  
  @override
  void initState() {
    super.initState();

    setState(() {
      nameTextEditController.text = user.name;
      ageTextEditController.text = user.birthday;
      telTextEditController.text = user.phoneNum;
      relationText = user.familyRelations;

      if (user.gender == '남자') {
        selectedGender[0] = true;
      } else {
        selectedGender[1] = true;
      }

      if (user.bloodType.split(' ')[0] == 'rh+') {
        rhSelected[0] = true;
      } else {
        rhSelected[1] = true;
      }

      selectedBloodType = user.bloodType.split(' ')[1];

      bloodTypeString = user.bloodType;

      addressTextEditController.text = user.address.split(')')[0]+')';
      detailAddressTextEditController.text = user.address.split(')')[1].substring(1);
      
      if (user.allergy == null) {
        allergyExists = false;
      } else {
        allergyExists = true;
        allergyTextEditController.text = user.allergy!;
      }

      if (user.medicine == null) {
        drugsExists = false;
      } else {
        drugsExists = true;
        drugsTextEditController.text = user.medicine!;
      }

      if (user.smokingCycle == null) {
        isSmoker = false;
      } else {
        isSmoker = true;
        smokingAmount = user.smokingCycle!.split('안 ')[1];
        smokingDuration = user.smokingCycle!.split('동')[0];
      }

      if (user.drinkingCycle == null) {
        isDrinker = false;
      } else {
        isDrinker = true;
        drinkingAmount = user.drinkingCycle!.split('안 ')[1];
        drinkingDuration = user.drinkingCycle!.split('동')[0];
      }

      if (user.etc == null) {
        etcExists = false;
      } else {
        etcExists = true;
        etcTextEditController.text = user.etc!;
      }
    });

    bodyScrollController.addListener(() {
      setState(() {
        offset = bodyScrollController.offset;
      });
    });
    
    /** 건강 정보 직접 입력시 이벤트 리스너 */

    nameTextEditController.addListener(checkNameField);
    ageTextEditController.addListener(checkAgeField);
    telTextEditController.addListener(checkTelField);
    addressTextEditController.addListener(checkAddressField);
    detailAddressTextEditController.addListener(checkDetailAddressField);

    allergyTextEditController.addListener(checkAllergy);

    drugsTextEditController.addListener(checkDrugs);
    
    etcTextEditController.addListener(checkEtc);

    /** 건강 정보 직접 입력시 이벤트 리스너 끝 */
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vw = MediaQuery.of(context).size.width;
    vh = MediaQuery.of(context).size.height;
    api = SpringBootApiService(context: context);
  }

  Widget getStepWidget(int currentStep) {
    if (currentStep == 0) 
      return SecondStep(context);
    else if (currentStep == 1) 
      return ThirdStep(context);
    else if (currentStep == 2)
      return FourthStep(context);
    return FifthStep(context);
  }

  Widget getCurrentStep(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 20, color: Colors.green),
        currentStep > 0 
        ? currentStep == 1
          ? checkSecondStep()
            ? Icon(Icons.check_circle, size: 20, color: Color.fromARGB(255, 79, 112, 229))
            : SvgPicture.asset(
                'assets/icons/counter_2.svg',
                width: 20, height: 20,
                colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
              )
          : Icon(Icons.check_circle, size: 20, color: Colors.green)
        : Icon(Icons.circle, size: 20, color: Colors.grey),
        currentStep > 1 
        ? currentStep == 2
          ? checkThirdStep()
            ? Icon(Icons.check_circle, size: 20, color: Color.fromARGB(255, 79, 112, 229))
            : SvgPicture.asset(
                'assets/icons/counter_3.svg',
                width: 20, height: 20,
                colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
              )
          : Icon(Icons.check_circle, size: 20, color: Colors.green)
        : Icon(Icons.circle, size: 20, color: Colors.grey),
        currentStep > 2 
        ? currentStep == 3 
          ? checkFourthStep() 
            ? Icon(Icons.check_circle, size: 20, color: Color.fromARGB(255, 79, 112, 229))
            : SvgPicture.asset(
              'assets/icons/counter_4.svg',
              width: 20, height: 20,
              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
            )
          : Icon(Icons.check_circle, size: 20, color: Colors.green)
        : Icon(Icons.circle, size: 20, color: Colors.grey),
      ]
    );
  }
  /** 건강 상태 입력 두번째 단계 */

  /** 건강 정보 직접 입력시 위젯 */
  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController ageTextEditController = TextEditingController();
  TextEditingController telTextEditController = TextEditingController();
  TextEditingController addressTextEditController = TextEditingController();
  TextEditingController detailAddressTextEditController = TextEditingController();

  final nameNode = FocusNode();
  final ageNode = FocusNode();
  final telNode = FocusNode();
  final addressNode = FocusNode();
  final detailAddressNode = FocusNode();

  bool nameIsEmpty = false; // 이름 입력 여부
  bool relationChecked = true; // 관계 체크 여부
  bool ageIsEmpty = false;
  bool telIsEmpty = false;
  bool addressIsEmpty = false;
  bool genderChecked = true;
  bool detailAddressIsEmpty = false;

  List<bool> selectedGender = [false, false];
  List<Widget> genderList = [
    Container(
      width: 85.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.male,
            size: 30
          ),
          Text('남성', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ]
      )
    ),
    Container(
      width: 85.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('여성', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(
            Icons.female,
            size: 30
          )
        ]
      )
    )
  ];

  List<String> relationList = ['선택안함', '본인', '배우자', '부', '모', '자녀', '기타'];
  String relationText = '선택안함';

  void checkNameField() {
    setState(() {
      nameIsEmpty = !nameTextEditController.text.isEmpty && nameTextEditController.text.length > 1 ? false : true;
    });
  }

  void checkAgeField() {
    setState(() {
      ageIsEmpty = !ageTextEditController.text.isEmpty ? false : true;
    });
  }

  void checkTelField() {
    setState(() {
      telIsEmpty = 
      !telTextEditController.text.isEmpty 
      && telTextEditController.text.length == 11
      && RegExp(r'^010\d{8}$').hasMatch(telTextEditController.text)
      ? false 
      : true;
    });
  }
  
  void checkAddressField() {
    setState(() {
      addressIsEmpty = !addressTextEditController.text.isEmpty ? false : true;
    });
  }

  void checkDetailAddressField() {
    setState(() {
      detailAddressIsEmpty = !detailAddressTextEditController.text.isEmpty ? false : true;
    });
  }

  /** 건강 정보 직접 입력시 위젯 끝 */

  bool checkSecondStep() {
    return !nameIsEmpty && relationChecked && !ageIsEmpty &&  !telIsEmpty && !addressIsEmpty && !detailAddressIsEmpty && genderChecked;
  }

  Widget SecondStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: vw * 0.25,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('관계'),
                        Icon(
                          relationChecked ? Icons.check_circle : Icons.check_circle_outlined,
                          color: relationChecked ? Colors.green : Colors.grey,
                          size: 18
                        ),
                      ]
                    ),
                    Container(
                      child: DropdownButton(
                        isExpanded: true,
                        value: relationText,
                        underline: Container(
                          height: 1,
                          color: Colors.grey
                        ),
                        style: TextStyle(
                          color: Colors.grey
                        ),
                        
                        onTap: () {
                        },
                        items: relationList.map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item)
                          );
                        }).toList(),
                        onChanged: null
                      )
                    )
                  ]
                ),
              ),
              Container(
                width: vw * 0.60,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('이름'),
                        Icon(
                          !nameIsEmpty ? Icons.check_circle : Icons.check_circle_outlined,
                          color: !nameIsEmpty ? Colors.green : Colors.grey,
                          size: 18
                        )
                      ]
                    ),
                    Container(
                      height: 40.0,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0
                          )
                        ),
                        controller: nameTextEditController,
                        style: TextStyle(color: Colors.black),
                        focusNode: nameNode,
                        onTapOutside: (event) {
                          nameNode.unfocus();
                        },
                      )
                    )
                  ]
                )
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: vw * 0.25,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('생년월일'),
                        Icon(
                          !ageIsEmpty ? Icons.check_circle : Icons.check_circle_outlined,
                          color: !ageIsEmpty ? Colors.green : Colors.grey,
                          size: 18
                        )
                      ],
                    ),
                    Container(
                      height: 40.0,
                      child: TextField(
                        controller: ageTextEditController,
                        focusNode: ageNode,
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 120),
                            lastDate: DateTime.now(),
                            locale: const Locale('ko')
                          );
                          if (selectedDate != null) {
                            setState(() {
                              ageTextEditController.text = '${selectedDate.year.toString().substring(2)}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        }
                      )
                    )
                  ]
                )
              ),
              Container(
                width: vw * 0.60,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('전화번호'),
                        Icon(
                          !telIsEmpty ? Icons.check_circle : Icons.check_circle_outlined,
                          color: !telIsEmpty ? Colors.green : Colors.grey,
                          size: 18
                        )
                      ]
                    ),
                    Container(
                      height: 40.0,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0
                          ),
                          hintText: '(-)를 제외하고 입력하십시오',
                          counterText: '',
                        ),
                        controller: telTextEditController,
                        focusNode: telNode,
                        onTapOutside: (event) {
                          telNode.unfocus();
                        },
                        maxLength: 11,
                        keyboardType: TextInputType.number
                      )
                    )
                  ]
                )
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('주소'),
                  Icon(
                    !addressIsEmpty ? Icons.check_circle : Icons.check_circle_outlined,
                    color: !addressIsEmpty ? Colors.green : Colors.grey,
                    size: 18
                  )
                ]
              ),
              Container(
                height: 40,
                child: TextField(
                  controller: addressTextEditController,
                  focusNode: addressNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0.0
                    )
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => KpostalView(
                        callback: (Kpostal result) {
                          setState(() {
                            addressTextEditController.text = result.address+' (${result.postCode})';
                          });
                        }
                      )
                    ));
                    addressNode.unfocus();
                  },
                  onTapOutside: (event) {
                    addressNode.unfocus();
                  }
                )
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('상세주소(없으면 \'없음\')'),
                  Icon(
                    !detailAddressIsEmpty ? Icons.check_circle : Icons.check_circle_outlined,
                    color: !detailAddressIsEmpty ? Colors.green : Colors.grey,
                    size: 18
                  )
                ]
              ),
              Container(
                height: 40.0,
                child: TextField(
                  controller: detailAddressTextEditController,
                  focusNode: detailAddressNode,
                  onTapOutside: (event) {
                    detailAddressNode.unfocus();
                  }
                )
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('성별'),
                  Icon(
                    genderChecked ? Icons.check_circle : Icons.check_circle_outlined,
                    color: genderChecked ? Colors.green : Colors.grey,
                    size: 18
                  )
                ]
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.02),
                child: ToggleButtons(
                  isSelected: selectedGender,
                  borderRadius: BorderRadius.circular(12.0),
                  constraints: BoxConstraints(minHeight: 60.0, minWidth: 150.0),
                  fillColor: selectedGender[0] ? Colors.blue : Color.fromARGB(250, 250, 138, 207),
                  selectedColor: Colors.white, 
                  children: genderList,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (value) {
                    setState(() {for (int i = 0; i < genderList.length; i++) {
                      selectedGender[i] = i == value;
                     }
                     genderChecked = true;
                    });
                  }
                )
              )
            ]
          )
        )
      ]
    );
  }

  /** 건강 상태 입력 두번째 단게 끝 */

  /** 건강 상태 입력 세번째 단계 */

  /** 건강 상태 직접 입력시 위젯 */

  TextEditingController allergyTextEditController = TextEditingController();

  final allergyNode = FocusNode();

  List<bool> rhSelected = [false, false];
  List<Widget> rhList = [
    Container(
      width: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'RH',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
          Icon(
            Icons.add,
            weight: 700,
          )
        ]
      )
    ),
    Container(
      width: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'RH',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          Icon(
            Icons.remove,
            weight: 700,
          )
        ]
      )
    )
  ];
  List<String> bloodTypeList = ['A', 'B', 'O', 'AB'];
  String selectedBloodType = '';

  String bloodTypeString = '';

  bool rhChecked = true;
  bool bloodTypeChecked = true;
  bool? allergyExists = null;
  bool allergyChecked = true;

  bool bloodCheckedAll() {
    return rhChecked && bloodTypeChecked ? true : false;
  }
  void checkAllergy() {
    setState(() {
      if (allergyExists == false)
        allergyChecked = true;
      else if (allergyExists == true) {
        if (allergyTextEditController.text.isEmpty)
          allergyChecked = false;
        else allergyChecked = true;
      }
    });
  }

  Widget allergyField() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0
            ),
          ),
          contentPadding: EdgeInsets.all(10)
        ),
        maxLines: 10,
        controller: allergyTextEditController,
        focusNode: allergyNode,
        onTap: () {
          offset = 1;
        },
        onTapOutside: (event) {
          allergyNode.unfocus();
          bodyScrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut
          );
          setState(() {
            offset = 0;
          });
        }
      )
    );
  }

  /** 건강 상태 직접 입력시 위젯 끝 */

  bool checkThirdStep() {
      return rhChecked && bloodTypeChecked && allergyChecked ? true : false;
  }

  Widget ThirdStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('혈액형'),
                  Icon(
                    bloodCheckedAll() ? Icons.check_circle : Icons.check_circle_outlined,
                    color: bloodCheckedAll() ? Colors.green : Colors.grey,
                    size: 18
                  )
                ]
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.015),
                height: 40.0,
                child: ToggleButtons(
                  children: rhList,
                  isSelected: rhSelected,
                  borderRadius: BorderRadius.circular(12.0),
                  constraints: BoxConstraints(minHeight: 60.0, minWidth: 120.0),
                  fillColor: Colors.black,
                  selectedColor: Colors.white,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (value) {
                    setState(() {
                      for (int i = 0; i < rhList.length; i++) {
                        rhSelected[i] = i == value;
                      }
                      rhChecked = true;
                      bloodTypeString = rhSelected[0] ? 'rh+ '+selectedBloodType : 'rh- '+selectedBloodType;
                    });
                  }
                )
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (String bloodType in bloodTypeList) 
                            Container(
                              margin: EdgeInsets.only(right: vw * 0.05),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedBloodType = bloodType;
                                    bloodTypeString = rhSelected[0] ? 'rh+ '+selectedBloodType : 'rh- '+selectedBloodType;
                                    bloodTypeChecked = true;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Radio<String> (
                                      value: bloodType,
                                      groupValue: selectedBloodType,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBloodType = value!;
                                          bloodTypeString = rhSelected[0] ? 'rh+ '+selectedBloodType : 'rh- '+selectedBloodType;
                                          bloodTypeChecked = true;
                                        });
                                      },
                                      activeColor: Color.fromARGB(255, 79, 112, 229)
                                    ),
                                    Text(bloodType)
                                ]
                              ),
                            )
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('알러지 정보 입력'),
                  Icon(
                    allergyChecked ? Icons.check_circle : Icons.check_circle_outlined,
                    color: allergyChecked ? Colors.green : Colors.grey,
                    size: 18
                  )
                ]
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.01),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          allergyExists = false;
                          checkAllergy();  
                        });
                      },
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: allergyExists,
                            onChanged: (value) {
                              setState(() {
                                allergyExists = value!;
                                checkAllergy();
                              });
                            },
                            activeColor: Color.fromARGB(255, 79, 112, 229)
                          ),
                          Text('해당 없음')
                        ]
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          allergyExists = true;
                          checkAllergy();
                        });
                      },
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: allergyExists,
                            onChanged: (value) {
                              setState(() {
                                allergyExists = value!;
                                checkAllergy();
                              });
                            },
                            activeColor: Color.fromARGB(255, 79, 112, 229)
                          ),
                          Text('해당 있음')
                        ]
                      ),
                    )
                  ]
                )
              )
            ]
          ),
        ),
        allergyExists == true ? allergyField() : Container()
      ]
    );
  }
  /** 건강 상태 입력 세번째 단계 끝 */

  /** 건강 상태 입력 네번째 단계 */

  /** 건강 상태 직접 입력시 위젯 */

List<String> smokingDurationList = ['선택안함', '하루', '일주일', '한 달'];
  List<String> smokingAmountList = [
    '선택안함',
    '0.5 갑 이상 1 갑 미만',
    '1 갑 이상 1.5 갑 미만',
    '1.5 갑 이상 2 갑 미만',
    '2 갑 이상 2.5 갑 미만',
    '2.5 갑 이상 3 갑 미만',
    '3 갑 이상'
  ];

  String smokingDuration = '';
  String smokingAmount = '';
  
  bool? isSmoker = null;
  bool smokingChecked = true;

  List<String> drinkingDurationList = ['선택안함', '하루', '일주일', '한 달'];
  List<String> drinkingAmountList = [
    '선택안함',
    '0.5 병 이상 1 병 미만',
    '1 병 이상 1.5 병 미만',
    '1.5 병 이상 2 병 미만',
    '2 병 이상 2.5 병 미만',
    '2.5 병 이상 3 병 미만',
    '3 병 이상'
  ];

  String drinkingDuration = '';
  String drinkingAmount = '';

  bool? isDrinker = null;
  bool drinkingChecked = true;

  TextEditingController etcTextEditController = TextEditingController();
  final etcNode = FocusNode();

  bool? etcExists = null;
  bool etcChecked = true;
  int restSpace = 2;

  GlobalKey smokingFieldKey = GlobalKey();
  GlobalKey drinkingFieldKey = GlobalKey();

  Widget SmokingField() {
    return Container(
      key: smokingFieldKey,
      margin: EdgeInsets.symmetric(horizontal: vw * 0.02),
      child: Row(
        children: [
          DropdownButton<String> (
            padding: EdgeInsets.zero,
            value: smokingDuration == '' ? smokingDurationList[0] : smokingDuration,
            icon: Icon(
              null
            ),
            onChanged: (value) {
              setState(() {
                smokingDuration = value!;
                checkSmoker();
              });
            },
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            items: smokingDurationList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value)
              );
            }).toList()
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 25.0),
            child: Text(
              '동안 ',
              style: TextStyle(
                fontSize: 16
              )
            )
          ),
          DropdownButton<String> (
            padding: EdgeInsets.zero,
            value: smokingAmount == '' ? smokingAmountList[0] : smokingAmount,
            icon: Icon(
              null
            ),
            onChanged: (value) {
              setState(() {
                smokingAmount = value!;
                checkSmoker();
              });
            },
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            items: smokingAmountList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value)
              );
            }).toList()
          )
        ]
      )
    );
  }

  Widget DrinkingField() {
    return Container(
      key: drinkingFieldKey,
      margin: EdgeInsets.symmetric(horizontal: vw * 0.02),
      child: Row(
        children: [
          DropdownButton<String> (
            padding: EdgeInsets.zero,
            value: drinkingDuration == '' ? drinkingDurationList[0] : drinkingDuration,
            icon: Icon(
              null
            ),
            onChanged: (value) {
              setState(() {
                drinkingDuration = value!;
                checkDrinker();
              });
            },
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            items: smokingDurationList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value)
              );
            }).toList()
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 25.0),
            child: Text(
              '동안 ',
              style: TextStyle(
                fontSize: 16
              )
            )
          ),
          DropdownButton<String> (
            padding: EdgeInsets.zero,
            value: drinkingAmount == '' ? drinkingAmountList[0] : drinkingAmount,
            icon: Icon(
              null
            ),
            onChanged: (value) {
              setState(() {
                drinkingAmount = value!;
                checkDrinker();
              });
            },
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
            items: drinkingAmountList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value)
              );
            }).toList()
          )
        ]
      )
    );
  }

  double getRestSpace() {
    // setState(() {
    //   if (isSmoker == true)
    //     restSpace--;
    //   if (isDrinker == true)
    //     restSpace--;
    // });
    // return restSpace;
    double restSpace = vh * 0.25;
    setState(() {
      if (smokingFieldKey.currentContext != null) {
        RenderBox smokingRenderBox = smokingFieldKey.currentContext!.findRenderObject() as RenderBox;
        restSpace = restSpace - smokingRenderBox.size.height;
      }
      if (drinkingFieldKey.currentContext != null) {
        RenderBox drinkingRenderBox = drinkingFieldKey.currentContext!.findRenderObject() as RenderBox;
        restSpace = restSpace - drinkingRenderBox.size.height;
      }
    });
    return restSpace;
  }

  Widget EtcField() {
    return Container(
      height: getRestSpace(),
      child: TextField(
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Colors.blue
            ),
            borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0))
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.0,
              color: Colors.grey
            ),
            borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0))
          ),
          contentPadding: EdgeInsets.all(7.5)
        ),
        minLines: null,
        maxLines: null,
        controller: etcTextEditController,
        focusNode: etcNode,
        onTap: () {
          setState(() {
            offset = 1;
          });
        },
        onTapOutside: (event) {
          etcNode.unfocus();
          bodyScrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut
          );
          setState(() {
            offset = 0;
          });
        },
        expands: true
      )
    );
  }

  void checkSmoker() {
    setState(() {
      if (isSmoker == false)
        smokingChecked = true;
      else if (isSmoker == true) {
        if (smokingDuration == '' || smokingDuration == '선택안함' || smokingAmount == '' || smokingAmount == '선택안함')
          smokingChecked = false;
        else
          smokingChecked = true;
      }
    });
  }

  void checkDrinker() {
    setState(() {
      if (isDrinker == false)
        drinkingChecked = true;
      else if (isDrinker == true) {
        if (drinkingDuration == '' || drinkingDuration == '선택안함' || drinkingAmount == '' || drinkingAmount == '선택안함')
          drinkingChecked = false;
        else
          drinkingChecked = true;
      }
    });
  }

  void checkEtc() {
    setState(() {
      if (etcExists == false) 
        etcChecked = true;
      else if (etcExists == true) {
        if (etcTextEditController.text.isEmpty)
          etcChecked = false;
        else
          etcChecked = true;
      }
    });
  } 

  /** 건강 상태 직접 입력시 위젯 끝 */

  Widget FourthStep(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('흡연 여부'),
              Icon(
                smokingChecked ? Icons.check_circle : Icons.check_circle_outlined,
                color: smokingChecked ? Colors.green : Colors.grey,
                size: 18
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSmoker = false;
                    checkSmoker();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: false,
                      groupValue: isSmoker,
                      onChanged: (value) {
                        setState(() {
                          isSmoker = value!;
                          checkSmoker();
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('비흡연')
                  ]
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSmoker = true;
                    checkSmoker();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: true,
                      groupValue: isSmoker,
                      onChanged: (value) {
                        setState(() {
                          isSmoker = value!;
                          checkSmoker();
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('흡연중')
                  ]
                ),
              )
            ]
          )
        ),
        isSmoker == true ? SmokingField() : Container(),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('음주 여부'),
              Icon(
                drinkingChecked ? Icons.check_circle : Icons.check_circle_outlined,
                color: drinkingChecked ? Colors.green : Colors.grey,
                size: 18
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDrinker = false;
                    checkDrinker();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: false,
                      groupValue: isDrinker,
                      onChanged: (value) {
                        setState(() {
                          isDrinker = value!;
                          checkDrinker();
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('해당 없음')
                  ]
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDrinker = true;
                    checkDrinker();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: true,
                      groupValue: isDrinker,
                      onChanged: (value) {
                        setState(() {
                          isDrinker = value!;
                          checkDrinker();
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('해당 있음')
                  ]
                ),
              )
            ]
          )
        ),
        isDrinker == true ? DrinkingField() : Container(),
      ]
    );
  }
  /** 건강 상태 입력 네번째 단계 끝 */

  /** 건강 상태 입력 다섯번째 단계 */
  
  TextEditingController drugsTextEditController = TextEditingController();
  List<TextEditingController> surgeryControllerList = [];
  final drugsNode = FocusNode();
  final List<FocusNode>surgeryNodeList = [];
  List<TextField> surgeryTextFieldList = [];
  List<DateTime> surgeryDateList = [];
  List<String> surgeryDateStringList = [];

  bool? drugsExists = null;
  bool drugsChecked = true;
  bool? surgeryExists = null;
  bool surgeryChecked = true;

  void checkDrugs() {
    setState(() {
      if (drugsExists == false)
        drugsChecked = true;
      else if (drugsExists == true) {
        if (drugsTextEditController.text.isEmpty) 
          drugsChecked = false;
        else
          drugsChecked = true;
      }
    });
  }

  void checkSurgery() {
    setState(() {
      if (surgeryExists == false)
        surgeryChecked = true;
      else if (surgeryExists == true) {
        surgeryChecked = true;
        if (surgeryControllerList.length == 0) {
          surgeryChecked = false;
        }
        for (TextEditingController controller in surgeryControllerList) {
          if (controller.text.isEmpty) {
            surgeryChecked = false;
          }
        }
      }
    });
  }

  bool checkFourthStep() {
      return smokingChecked && drinkingChecked ? true : false;
  }

  Widget DrugsField() {
    return drugsExists == true ? Container(
      margin: EdgeInsets.only(top: vh * 0.01),
      child: TextField(
        controller: drugsTextEditController,
        focusNode: drugsNode,
        maxLines: 6,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0
            )
          )
        ),
        onTapOutside: (event) {
          drugsNode.unfocus();
        },
      )
    ) : Container();
  }

  double getSurgeryFieldHeight() {
    if (drugsExists == true) {
      if (surgeryTextFieldList.length > 3)
        return vh * 0.18;
      else 
        return 40.0 * surgeryTextFieldList.length;
    } else {
      if (surgeryTextFieldList.length > 8)
        return vh * 0.39;
      else
        return 40.0 * surgeryTextFieldList.length;
    }
  }

  Widget SurgeryAllField() {
    return surgeryTextFieldList.length > 0 ?
      Container(
        height: getSurgeryFieldHeight(),
        width: vw * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < surgeryTextFieldList.length; i++) 
                Container(
                  height: 30.0,
                  margin: EdgeInsets.only(top: vh * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: vw * 0.4,
                        child: surgeryTextFieldList[i]
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0
                          ),
                          borderRadius: BorderRadius.circular(6.0)
                        ),
                        margin: EdgeInsets.only(left: vw * 0.05),
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0)
                            ),
                          ),
                          child: Text(surgeryDateStringList[i]),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: surgeryDateList[i],
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime.now()
                            );
                            if (selectedDate != null) {
                              setState(() {
                                surgeryDateList[i] = selectedDate;
                                surgeryDateStringList[i] = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                              });
                            }
                          }
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: vw * 0.05),
                        child: InkWell(
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.redAccent,
                            size: 20
                          ),
                          onTap: () {
                            setState(() {
                              TextEditingController removeController = surgeryControllerList.removeAt(i);
                              FocusNode removeNode = surgeryNodeList.removeAt(i);
                              surgeryDateList.removeAt(i);
                              surgeryDateStringList.removeAt(i);
                              surgeryTextFieldList.removeAt(i);
                              removeController.dispose();
                              removeNode.dispose();
                            });
                          }
                        )
                      )
                    ]
                  )
                )
            ]
          )
        )
      )
      : Container();
  }

  void addSurgeryTextField() {
    setState(() {
      surgeryControllerList.add(
        new TextEditingController()
      );
      checkSurgery();
      surgeryControllerList[surgeryControllerList.length - 1].addListener(checkSurgery);
      surgeryNodeList.add(
        new FocusNode()
      );
      surgeryTextFieldList.add(
        new TextField(
          controller: surgeryControllerList[surgeryControllerList.length - 1],
          focusNode: surgeryNodeList[surgeryNodeList.length - 1],
          onTap: () {
            setState(() {
              offset = 1;
            });
          },
          onTapOutside: (event) {
            for (int i = 0; i < surgeryNodeList.length; i++) {
              surgeryNodeList[i].unfocus();
              bodyScrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut
              );
              setState(() {
                offset = 0;
              });
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.grey
              ),
            ),
            hintText: '수술명',
            contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0)
          )
        )
      );
      surgeryDateList.add(
        new DateTime.now()
      );
      DateTime lastSurgery = surgeryDateList[surgeryDateList.length - 1];
      surgeryDateStringList.add(
        '${lastSurgery.year}-${lastSurgery.month.toString().padLeft(2, '0')}-${lastSurgery.day.toString().padLeft(2, '0')}'
      );
    });
  }

  bool checkFifthStep() {
    return drugsChecked && etcChecked ? true : false;
  }

  Widget FifthStep(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('복용중인 약'),
              Icon(
                drugsChecked ? Icons.check_circle : Icons.check_circle_outlined,
                color: drugsChecked ? Colors.green : Colors.grey,
                size: 18
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<bool> (
                          value: false,
                          groupValue: drugsExists,
                          onChanged: (value) {
                            setState(() {
                              drugsExists = value!;
                              checkDrugs();
                            });
                          },
                          activeColor: Color.fromARGB(255, 79, 112, 229)
                        ),
                        Text('해당 없음')
                      ]
                    ),
                    Row(
                      children: [
                        Radio<bool> (
                          value: true,
                          groupValue: drugsExists,
                          onChanged: (value) {
                            setState(() {
                              drugsExists = value!;
                              checkDrugs();
                            });
                          },
                          activeColor: Color.fromARGB(255, 79, 112, 229)
                        ),
                        Text('해당 있음')
                      ],
                    ),
                    DrugsField()
                  ]
                )
              ),
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('기타 특이사항'),
              Icon(
                etcChecked ? Icons.check_circle : Icons.check_circle_outlined,
                color: etcChecked ? Colors.green : Colors.grey,
                size: 18
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    etcExists = false;
                    checkEtc();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: false,
                      groupValue: etcExists,
                      onChanged: (value) {
                        setState(() {
                          etcExists = value!;
                          checkEtc();
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('특이사항 없음')
                  ]
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    etcExists = true;
                    checkEtc();
                  });
                },
                child: Row(
                  children: [
                    Radio<bool> (
                      value: true,
                      groupValue: etcExists,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            etcExists = value!;
                            checkEtc();
                          });
                        });
                      },
                      activeColor: Color.fromARGB(255, 79, 112, 229)
                    ),
                    Text('특이사항 있음')
                  ]
                ),
              )
            ]
          )
        ),
        etcExists == true ? EtcField() : Container()
      ]
    );
  }

  /** 건강 상태 입력 다섯번째 단계 끝 */

  /** 현재 단계에 따라 완성도 체크해서 다음 버튼 활성 or 비활성 함수 */
  bool checkCurrentStep() {
    if (currentStep == 0)
      return checkSecondStep();
    else if (currentStep == 1)
      return checkThirdStep();
    else if (currentStep == 2)
      return checkFourthStep();
    else
      return checkFifthStep();
  }

  /** 이전 버튼 or 취소 버튼 구분 함수 */
  void cancleAddAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
            ),
            actionsPadding: EdgeInsets.only(bottom: 5.0),
            title: Text('문진표 수정'),
            content: Text('문진표 수정을 취소하시겠습니까?'),
            actions: [
              TextButton(
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  )
                ),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
              TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold
                  )
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              )
            ]
          )
        );
      }
    );
  }

  /** 다음 버튼 or 제출 버튼 구분 함수 */
  void completeAddAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
            ),
            actionsPadding: EdgeInsets.only(bottom: 5.0),
            title: Text('문진표 수정'),
            content: Text('문진표를 제출하시겠습니까?'),
            actions: [
              TextButton(
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  )
                ),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
              TextButton(
                child: Text(
                  '제출',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold
                  )
                ),
                onPressed: () {
                  Map<String, dynamic> questionnaire = {
                    'name': nameTextEditController.text,
                    'birthday': ageTextEditController.text,
                    'familyRelations': relationText,
                    'phoneNum': telTextEditController.text,
                    'address': addressTextEditController.text+' '+detailAddressTextEditController.text,
                    'gender': selectedGender[0] ? '남자' : '여자',
                    'bloodType': bloodTypeString,
                    'allergy': allergyExists == true ? allergyTextEditController.text : null,
                    'medicine': drugsExists == true ? drugsTextEditController.text : null,
                    'smokingCycle': isSmoker == true ? smokingDuration+'동안 '+smokingAmount : null,
                    'drinkingCycle': isDrinker == true ? drinkingDuration+'동안 '+drinkingAmount : null,
                    'etc': etcExists == true ? etcTextEditController.text : null
                  };
                  api.editQuestionnaire(questionnaire: questionnaire, id: user.id)
                  .then((value) {
                    if (value == '문진표 수정 완료') {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle
                            ),
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                              ),
                              actionsPadding: EdgeInsets.only(bottom: 5.0),
                              title: Text('문진표 수정'),
                              content: Text('문진표를 수정하였습니다'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                )
                              ]
                            )
                          );
                        }
                      );
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle
                            ),
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.elliptical(12, 9))
                              ),
                              actionsPadding: EdgeInsets.only(bottom: 5.0),
                              title: Text('문진표 수정'),
                              content: Text('문진표 수정을 실패하였습니다'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    '확인',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }
                                )
                              ]
                            )
                          );
                        }
                      );
                    }
                  });
                }
              )
            ]
          )
        );
      }
    );
  }

  String getNextButtonText() {
    if (currentStep == 3)
      return '제출';
    else
      return '다음';
  }

  /** 건강 정보 직접 추가시 위젯 */
  Widget BodyWidget() {
    return GestureDetector(
      onTap: () {
        bodyScrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut
        );
      },
      child: SingleChildScrollView(
        physics: offset != 0
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
        controller: bodyScrollController,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 5.0, horizontal: vw * 0.05
          ),
          width: vw,
          height: vh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getCurrentStep(currentStep),
              getStepWidget(currentStep),
            ]
          )
        ),
      ),
    );
  }

  Widget AddSearchWidget() {
    return GestureDetector();
  }

  /** 앱 UI */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: TextButton(
          child: Text(
            currentStep > 0 ? '이전' : '취소',
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.bold
            )
          ),
          onPressed: currentStep > 0 ? () {
            setState(() {
              currentStep--;
            });
          } : cancleAddAlert
        ),
        title: Text(
          '문진표 수정',
          style: TextStyle(
            color: Colors.black
          )
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              getNextButtonText(),
              style: TextStyle(
                color: checkCurrentStep() ? Colors.blueAccent : Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold
              )
            ),
            onPressed: checkCurrentStep() ? 
              () {
                if (currentStep == 3)
                  completeAddAlert();
                else {
                  setState(() {
                    currentStep++;
                  });
                }
              }
              : null
          )
        ],
        bottom: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 0.3, color: Colors.grey)
            )
          ),
          preferredSize: Size.fromHeight(0.3),
        )
      ),
      body: BodyWidget()
    );
  }
}