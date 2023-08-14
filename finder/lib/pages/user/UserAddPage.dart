import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpostal/kpostal.dart';

class UserAddPage extends StatefulWidget {
  UserAddPage({super.key});

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {

  int currentStep = 2;

  var vw = 0.0;
  var vh = 0.0;
  
  @override
  void initState() {
    super.initState();
    nameTextEditController.addListener(checkNameField);
    ageTextEditController.addListener(checkAgeField);
    telTextEditController.addListener(checkTelField);
    addressTextEditController.addListener(checkAddressField);
    detailAddressTextEditController.addListener(checkDetailAddressField);

    allergyTextEditController.addListener(allergyCheck);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vw = MediaQuery.of(context).size.width;
    vh = MediaQuery.of(context).size.height;
  }

  Widget getStepWidget(int currentStep) {
    if (currentStep == 0) 
      return FirstStep(context);
    else if (currentStep == 1) 
      return SecondStep(context);
    return ThirdStep(context);
  }

  Widget getCurrentStep(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        currentStep == 0 ? SvgPicture.asset(
          'assets/icons/counter_1.svg',
          width: 20, height: 20,
          colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
        ) :
        Icon(Icons.check_circle, size: 20, color: Colors.green),
        currentStep > 0 ?
          currentStep == 1 ?
            SvgPicture.asset(
              'assets/icons/counter_2.svg',
              width: 20, height: 20,
              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
            ) :
            Icon(Icons.check_circle, size: 20, color: Colors.green) :
          Icon(Icons.circle, size: 20, color: Colors.grey),
        currentStep > 1 ?
          currentStep == 2 ?
            SvgPicture.asset(
              'assets/icons/counter_3.svg',
              width: 20, height: 20,
              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
            ) :
            Icon(Icons.check_circle, size: 20, color: Colors.green) :
          Icon(Icons.circle, size: 20, color: Colors.grey),
        currentStep > 2 ?
          currentStep == 3 ?
            SvgPicture.asset(
              'assets/icons/counter_4.svg',
              width: 20, height: 20,
              colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
            ) :
            Icon(Icons.check_circle, size: 20, color: Colors.green) :
          Icon(Icons.circle, size: 20, color: Colors.grey),
        currentStep > 3 ?
          SvgPicture.asset(
            'assets/icons/counter_5.svg',
            width: 20, height: 20,
            colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
          ) :
          Icon(Icons.circle, size: 20, color: Colors.grey),
      ]
    );
  }

  /** 건강 상태 입력 첫번째 단계 */

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

  bool nameIsEmpty = true; // 이름 입력 여부
  bool relationChecked = false; // 관계 체크 여부
  bool ageIsEmpty = true;
  bool telIsEmpty = true;
  bool addressIsEmpty = true;
  bool sexChecked = false;
  bool detailAddressIsEmpty = true;

  List<bool> selectedSex = [false, false];
  List<Widget> sexList = [
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

  String relationText = '선택안함';
  String addressText = '';

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
      telIsEmpty = !telTextEditController.text.isEmpty && telTextEditController.text.length == 11 ? false : true;
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

  bool checkFirstStep() {
    return !nameIsEmpty && relationChecked && !ageIsEmpty &&  !telIsEmpty && !addressIsEmpty && !detailAddressIsEmpty && sexChecked;
  }

  Widget FirstStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getCurrentStep(0),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '이름'
              ),
              Icon(
                Icons.check_circle,
                color: !nameIsEmpty ? Colors.green : Colors.grey,
                size: 14
              )
            ]
          )
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
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('관계'),
                        Icon(
                          Icons.check_circle,
                          color: relationChecked ? Colors.green : Colors.grey,
                          size: 14
                        )
                      ]
                    ),
                    Container(
                      width: 150.0,
                      child: DropdownButton(
                        isExpanded: true,
                        value: relationText,
                        underline: Container(
                          height: 1,
                          color: Colors.grey
                        ),
                        items:
                          ['선택안함', '본인', '배우자', '자녀', '부', '모'].map<DropdownMenuItem<String?>>((String? i) {
                            return DropdownMenuItem<String?>(
                              value: i,
                              child: Text({'본인': '본인', '배우자': '배우자', '자녀': '자녀', '부': '부', '모': '모'}[i] ?? '선택안함')
                            );
                          }).toList(),
                        onChanged: (event) {
                          setState(() {
                            relationText = event!;
                            event == '선택안함' ? relationChecked = false : relationChecked = true;
                          });
                        }
                      )
                    )
                  ]
                )
              ),
              Container(
                margin: EdgeInsets.only(left: vw * 0.075),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('나이'),
                        Icon(
                          Icons.check_circle,
                          color: !ageIsEmpty ? Colors.green : Colors.grey,
                          size: 14
                        )
                      ]
                    ),
                    Container(
                      width: 150.0,
                      height: 40.0,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        controller: ageTextEditController,
                        focusNode: ageNode,
                        onTapOutside: (event) {
                          ageNode.unfocus();
                        }
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
          child: Column(
            children: [
              Row(
                children: [
                  Text('전화번호'),
                  Icon(
                    Icons.check_circle,
                    color: !telIsEmpty ? Colors.green : Colors.grey,
                    size: 14
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
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                children: [
                  Text('주소'),
                  Icon(
                    Icons.check_circle,
                    color: !addressIsEmpty ? Colors.green : Colors.grey,
                    size: 14
                  )
                ]
              ),
              Container(
                child: TextField(
                  controller: addressTextEditController,
                  focusNode: addressNode,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('상세주소(없으면 \'없음\')'),
                  Icon(
                    Icons.check_circle,
                    color: !detailAddressIsEmpty ? Colors.green : Colors.grey,
                    size: 14
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
                children: [
                  Text('성별'),
                  Icon(
                    Icons.check_circle,
                    color: sexChecked ? Colors.green : Colors.grey,
                    size: 14
                  )
                ]
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.02),
                child: ToggleButtons(
                  isSelected: selectedSex,
                  borderRadius: BorderRadius.circular(12.0),
                  constraints: BoxConstraints(minHeight: 60.0, minWidth: 150.0),
                  fillColor: selectedSex[0] ? Colors.blue : Color.fromARGB(250, 250, 138, 207),
                  selectedColor: Colors.white, 
                  children: sexList,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: (value) {
                    setState(() {for (int i = 0; i < sexList.length; i++) {
                      selectedSex[i] = i == value;
                     }
                     sexChecked = true;
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

  /** 건강 상태 입력 첫번째 단게 끝 */

  /** 건강 상태 입력 두번째 단계 */

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

  bool rhChecked = false;
  bool bloodTypeChecked = false;
  bool? allergyExists = null;
  bool allergyChecked = false;

  bool bloodCheckedAll() {
    return rhChecked && bloodTypeChecked ? true : false;
  }
  void allergyCheck() {
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
  bool checkSecondStep() {
    return rhChecked && bloodTypeChecked && allergyChecked ? true : false;
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
        onTapOutside: (event) {
          allergyNode.unfocus();
        }
      )
    );
  }

  Widget SecondStep(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getCurrentStep(1),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('혈액형'),
                  Icon(
                    Icons.check_circle,
                    color: bloodCheckedAll() ? Colors.green : Colors.grey,
                    size: 14
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
                                        bloodTypeChecked = true;
                                      });
                                    }
                                  ),
                                  Text(bloodType)
                                ]
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
                children: [
                  Text('알러지 정보 입력'),
                  Icon(
                    Icons.check_circle,
                    color: allergyChecked ? Colors.green : Colors.grey,
                    size: 14
                  )
                ]
              ),
              Container(
                margin: EdgeInsets.only(top: vh * 0.01),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: allergyExists,
                          onChanged: (value) {
                            setState(() {
                              allergyExists = value!;
                              allergyCheck();
                            });
                          }
                        ),
                        Text('해당 없음')
                      ]
                    ),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: allergyExists,
                          onChanged: (value) {
                            setState(() {
                              allergyExists = value!;
                              allergyCheck();
                            });
                          }
                        ),
                        Text('해당 있음')
                      ]
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
  /** 건강 상태 입력 두번째 단계 끝 */

  /** 건강 상태 입력 세번째 단계 */
  TextEditingController drugsTextEditController = TextEditingController();
  List<TextEditingController> surgeryControllerList = [];

  final drugsNode = FocusNode();
  final List<FocusNode>surgeryNodeList = [];

  bool? drugsExists = null;
  bool drugChecked = false;
  bool? surgeryExists = null;
  bool surgeryChecked = false;

  Widget DrugsField() {
    return Container(
      margin: EdgeInsets.only(top: vh * 0.01),
      child: TextField(
        controller: drugsTextEditController,
        focusNode: drugsNode,
        enabled: drugsExists == true ? true : false,
        maxLines: 6,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: drugsExists == true ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0
            )
          ) : InputBorder.none
        ),
        onTapOutside: (event) {
          drugsNode.unfocus();
        }
      )
    );
  }

  List<TextField> surgeryTextFieldList = [];

  Widget SurgeryAllField() {
    return surgeryTextFieldList.length > 0 ?
      Container(
        child: Column(
          children: surgeryTextFieldList.map((item) {
            return Container(
              height: 30.0,
              margin: EdgeInsets.only(top: vh * 0.01),
              child: Row(
                children: [
                  Container(
                    width: vw * 0.5,
                    child: item,
                  )
                ]
              )
            );
          }).toList()
        )
      )
      : Container();
  }

  void addSurgeryTextField() {
    setState(() {
      surgeryControllerList.add(
        TextEditingController()
      );
      surgeryNodeList.add(
        FocusNode()
      );
      surgeryTextFieldList.add(
        TextField(
          controller: surgeryControllerList[surgeryControllerList.length - 1],
          focusNode: surgeryNodeList[surgeryNodeList.length - 1],
          onTapOutside: (event) {
            surgeryNodeList[surgeryNodeList.length - 1].unfocus();
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
    });
  }

  Widget ThirdStep(BuildContext context) {
    return Column(
      children: [
        getCurrentStep(2),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('복용중인 약'),
              Icon(
                Icons.check_circle,
                color: Colors.grey,
                size: 14
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
                              drugChecked = true;
                            });
                          }
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
                            });
                          }
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
            children: [
              Text('수술 이력 (최근 1년 이내)'),
              Icon(
                Icons.check_circle,
                color: Colors.grey,
                size: 14
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Column(
            children: [
              Row(
                children: [
                  Radio<bool> (
                    value: false,
                    groupValue: surgeryExists,
                    onChanged: (value) {
                      setState(() {
                        surgeryExists = value!;
                        surgeryChecked = true;
                      });
                    }
                  ),
                  Text('해당 없음')
                ]
              ),
              Row(
                children: [
                  Radio<bool> (
                    value: true,
                    groupValue: surgeryExists,
                    onChanged: (value) {
                      setState(() {
                        surgeryExists = value!;
                      });
                    }
                  ),
                  Text('해당 있음')
                ]
              ),
              SurgeryAllField(),
              Container(
                width: vw * 0.6,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        weight: 700,
                        size: 35,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(
                          '추가',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        )
                      )
                    ]
                  ),
                  onTap: addSurgeryTextField
                )
              )
            ]
          )
        )
      ]
    );
  }
  /** 건강 상태 입력 세번째 단계 끝 */

  /** 현재 단계에 따라 완성도 체크해서 다음 버튼 활성 or 비활성 함수 */
  bool checkCurrentStep() {
    if (currentStep == 0) {
      return checkFirstStep();
    } else if (currentStep == 1) {
      return checkSecondStep();
    }
    return checkSecondStep();
  }

  /** 앱 UI */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            } : () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('건강 정보 입력 취소'),
                    content: Text('건강 정보 입력을 취소하시겠습니까?'),
                    actions: [
                      TextButton(
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.red
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
                            color: Colors.blueAccent
                          )
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      )
                    ]
                  );
                }
              );
            }
          ),
          title: Text(
            '건강 정보 입력',
            style: TextStyle(
              color: Colors.black
            )
          ),
          actions: [
            TextButton(
              child: Text(
                '다음',
                style: TextStyle(
                  color: checkCurrentStep() ? Colors.blueAccent : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
              onPressed: checkCurrentStep() ? () {
                setState(() {
                  currentStep++;
                });
              } : null
            )
          ],
          bottom: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(width: 0.3, color: Colors.black)
              )
            ),
            preferredSize: Size.fromHeight(0.3),
          )
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
            vertical: 1.0, horizontal: 25.0
          ),
          width: vw,
          height: vh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getStepWidget(currentStep),
            ]
          )
        )
      )
    );
  }
}
