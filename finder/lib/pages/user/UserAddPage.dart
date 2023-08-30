import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpostal/kpostal.dart';
import 'package:http/http.dart' as http;
import '../../components/componentsExport.dart';
import '../../models/modelsExport.dart';


class UserAddPage extends StatefulWidget {
  UserAddPage({super.key});

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> with SingleTickerProviderStateMixin{

  final bodyScrollController = ScrollController();

  double offset = 0;

  int currentStep = 0;

  var vw = 0.0;
  var vh = 0.0;
  
  @override
  void initState() {

    rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    )..addListener(() {
      setState(() {});
    });
    rotationController.repeat(reverse: false);

    super.initState();

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

    /** 건강 정보 간접 입력시 이벤트 리스너 */

    otherEmailTextEditController.addListener(checkOtherEmailField);

    /** 건강 정보 간접 입력시 이벤트 리스너 끝 */
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
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
    else if (currentStep == 2)
      return ThirdStep(context);
    else if (currentStep == 3)
      return FourthStep(context);
    return FifthStep(context);
  }

  Widget getCurrentStep(int currentStep) {
    return currentStep > 0
    ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: addDirectly == true
      ? [
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
        currentStep > 3
          ? checkFifthStep()
            ? Icon(Icons.check_circle, size: 20, color: Color.fromARGB(255, 79, 112, 229))
            : SvgPicture.asset(
                'assets/icons/counter_5.svg',
                width: 20, height: 20,
                colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
            )
        : Icon(Icons.circle, size: 20, color: Colors.grey)
      ]
      : [
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
        : Icon(Icons.circle, size: 20, color: Colors.grey)
      ]
    )
    : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        checkFirstStep() 
        ? Icon(
          Icons.check_circle,
          size: 20,
          color: Color.fromARGB(255, 79, 112, 229)
        )
        : SvgPicture.asset(
          'assets/icons/counter_1.svg',
          width: 20, height: 20,
          colorFilter: ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn)
        ) 
      ]
    );
  }

  /** 건강 정보 입력 첫번째 단계 */

  bool? addDirectly = null;

  bool checkFirstStep() {
    return addDirectly != null ? true : false;
  }

  Widget FirstStep(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: vh * 0.5,
            margin: EdgeInsets.only(top: vh * 0.12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (addDirectly == null || addDirectly == false)
                        addDirectly = true;
                      else
                        addDirectly = null;
                    });
                  },
                  child: Container(
                    width: vw >= 400 ? vw * 0.6 : vw * 0.7,
                    height: vh * 0.15,
                    decoration: BoxDecoration(
                      color: addDirectly == true ? Color.fromARGB(255, 79, 112, 229) : Colors.transparent,
                      border: Border.all(
                        color: addDirectly == true 
                          ? Color.fromARGB(255, 79, 112, 229)
                          : Color.fromARGB(255, 139, 139, 139),
                        width: 4.0
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: vw * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addDirectly == true
                          ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 25
                          )
                          : Icon(
                            Icons.circle_outlined,
                            color: Color.fromARGB(255, 139, 139, 139),
                            size: 25
                          ),
                        Text(
                          '직접 추가하기',
                          style: TextStyle(
                            color: addDirectly == true ? Colors.white : Color.fromARGB(255, 139, 139, 139),
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (addDirectly == null || addDirectly == true)
                        addDirectly = false;
                      else
                        addDirectly = null;
                    });
                  },
                  child: Container(
                    width: vw >= 400 ? vw * 0.6 : vw * 0.7,
                    height: vh * 0.15,
                    margin: EdgeInsets.only(top: 75.0),
                    decoration: BoxDecoration(
                      color: addDirectly == false ? Color.fromARGB(255, 79, 112, 229) : Colors.transparent,
                      border: Border.all(
                        color: addDirectly == false 
                          ? Color.fromARGB(255, 79, 112, 229)
                          : Color.fromARGB(255, 139, 139, 139),
                        width: 4.0
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: vw * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addDirectly == false
                          ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 25
                          )
                          : Icon(
                            Icons.circle_outlined,
                            color: Color.fromARGB(255, 139, 139, 139),
                            size: 25
                          ),
                        Text(
                          '검색하여 추가',
                          style: TextStyle(
                            color: addDirectly == false ? Colors.white : Color.fromARGB(255, 139, 139, 139),
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    )
                  ),
                )
              ]
            ),
          ),
        ]
      ),
    );
  }

  /** 건강 상태 입력 첫번째 단계 끝 */

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

  /** 건강 정보 직접 입력시 위젯 끝 */

  /** 검색 후 추가시 위젯 */

  TextEditingController otherEmailTextEditController = TextEditingController();

  final otherEmailNode = FocusNode();

  bool otherEmailIsEmpty = true;

  User? foundUser;
  bool? userFindingSuccess;
  bool resultCorrect = false;

  void checkOtherEmailField() {
    setState(() {
      // otherEmailIsEmpty = !otherEmailTextEditController.text.isEmpty && otherEmailTextEditController.text.length > 5 ? false : true;
      if (otherEmailTextEditController.text.isEmpty && otherEmailTextEditController.text.length < 4)
        otherEmailIsEmpty = true;
      else
        otherEmailIsEmpty = !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
        ).hasMatch(otherEmailTextEditController.text);
    });
  }

  Future<void> findUser() async {
    setState(() {
      foundUser = null;
      userFindingSuccess = null;
    });
    String jsonString = await rootBundle.loadString('assets/datas/users.json');
    List<dynamic> jsonList = jsonDecode(jsonString);

    for (var jsonUser in jsonList) {
      if (jsonUser['email'] == otherEmailTextEditController.text) {
        setState(() {
          foundUser = User.fromJson(jsonUser);
          userFindingSuccess = true;
        });
        break;
      }
    }
    if (foundUser == null) {
      setState(() {
        userFindingSuccess = false;
      });
    }
    print(foundUser?.name);
  }

  /** 검색 후 추가시 위젯 끝 */

  bool checkSecondStep() {
    if (addDirectly == true)
      return !nameIsEmpty && relationChecked && !ageIsEmpty &&  !telIsEmpty && !addressIsEmpty && !detailAddressIsEmpty && sexChecked;
    else
      return !otherEmailIsEmpty && foundUser != null && resultCorrect;
  }

  Widget SecondStep(BuildContext context) {
    return addDirectly == true
    ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    )
    : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('상대방의 이메일 입력'),
              Icon(
                Icons.check_circle,
                color: checkSecondStep() ? Colors.green : Colors.grey,
                size: 14
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.01),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Color.fromARGB(255, 79, 112, 229)
                )
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: otherEmailNode.hasFocus ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 20, maxWidth: 40),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              hintText: '상대방의 이메일을 입력하십시오',
              hintStyle: TextStyle(
                color: Colors.grey
              )
            ),
            focusNode: otherEmailNode,
            controller: otherEmailTextEditController,
            onTapOutside: (event) {
              otherEmailNode.unfocus();
            }
          )
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: vh * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: TextButton(
                  child: Text('검색'),
                  
                  onPressed: otherEmailIsEmpty
                  ? null
                  : findUser,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(otherEmailIsEmpty ? Colors.grey : Color.fromARGB(255, 79, 112, 229)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                    )
                  ),
                )
              )
            ]
          )
        ),
        foundUser != null
        ? Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey
            ),
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: InformationCard(user: foundUser!, inList: false)
        )
        : userFindingSuccess == false
          ? Container(
            margin: EdgeInsets.only(top: vh * 0.1),
            child: Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 30
              )
            )
          )
          : Container(),
        userFindingSuccess == true
        ? Container(
          margin: EdgeInsets.only(top: vh * 0.05),
          child: GestureDetector(
            onTap: () {
              setState(() {
                resultCorrect = !resultCorrect;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  resultCorrect ? Icons.check_box_rounded : Icons.check_box_outline_blank_outlined,
                  size: 25,
                  color: resultCorrect ? Color.fromARGB(255, 79, 112, 229) : Colors.grey
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    '해당 사용자의 정보를 추가합니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black
                    )
                  )
                )
              ]
            ),
          )
        )
        : Container()
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

  bool rhChecked = false;
  bool bloodTypeChecked = false;
  bool? allergyExists = null;
  bool allergyChecked = false;

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

  /** 검색 후 추가시 위젯 */

  bool otherRelationChecked = false;
  List<String> otherRelationList = ['선택안함', '배우자', '자녀', '부', '모'];
  String myPosition = '';
  String otherPosition = '';

  void checkOtherRelation() {
    setState(() {
      if (myPosition != '' && myPosition != '선택안함' && otherPosition != '' && otherPosition != '선택안함')
        otherRelationChecked = true;
      else
        otherRelationChecked = false;
    });
  }

  String getFoundUserName() {
    return foundUser!.name.replaceRange(1, 2, '*');
  }

  /** 검색 후 추가시 위젯 끝 */

  bool checkThirdStep() {
    if (addDirectly == true)
      return rhChecked && bloodTypeChecked && allergyChecked ? true : false;
    else
      return otherRelationChecked;
  }

  Widget ThirdStep(BuildContext context) {
    return addDirectly == true
      ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedBloodType = bloodType;
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
    )
    : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('${getFoundUserName()} 님과의 관계를 입력하십시오'),
              Icon(
                Icons.check_circle,
                color: otherRelationChecked ? Colors.green : Colors.grey,
                size: 14,
              )
            ]
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Text(
                  '(본인)',
                  style: TextStyle(
                    fontSize: 16
                  )
                ),
              ),
              DropdownButton(
                alignment: Alignment.center,
                value: myPosition == '' ? otherRelationList[0] : myPosition,
                items: otherRelationList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value)
                  );
                }).toList(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
                icon: Icon(
                  null,
                  size: 0
                ),
                onChanged: (value) {
                  setState(() {
                    myPosition = value!;
                    checkOtherRelation();
                  });
                },
                selectedItemBuilder: (context) {
                  return otherRelationList.map((String value) {
                    return Center(
                      child: Text(
                        value,
                        textAlign: TextAlign.center
                      )
                    );
                  }).toList();
                }
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.horizontal_rule,
                  size: 15,
                  color: Colors.black
                )
              ),
              DropdownButton(
                alignment: Alignment.center,
                value: otherPosition == '' ? otherRelationList[0] : otherPosition,
                items: otherRelationList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value)
                  );
                }).toList(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
                icon: Icon(
                  null,
                  size: 0
                ),
                onChanged: (value) {
                  setState(() {
                    otherPosition = value!;
                    checkOtherRelation();
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(
                  '(${getFoundUserName()})',
                  style: TextStyle(
                    fontSize: 16
                  )
                )
              )
            ]
          )
        )
      ]
    );
  }
  /** 건강 상태 입력 세번째 단계 끝 */

  /** 건강 상태 입력 네번째 단계 */

  /** 건강 상태 직접 입력시 위젯 */
  TextEditingController drugsTextEditController = TextEditingController();
  List<TextEditingController> surgeryControllerList = [];
  final drugsNode = FocusNode();
  final List<FocusNode>surgeryNodeList = [];
  List<TextField> surgeryTextFieldList = [];
  List<DateTime> surgeryDateList = [];
  List<String> surgeryDateStringList = [];

  bool? drugsExists = null;
  bool drugsChecked = false;
  bool? surgeryExists = null;
  bool surgeryChecked = false;

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
    if (addDirectly == true)
      return drugsChecked && surgeryChecked ? true : false;
    else
      return responseSuccessed != null ? true : false;
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

  /** 건강 상태 직접 입력시 위젯 끝 */

  /** 검색 후 추가시 위젯 */

  bool requestSent = false; //요청하기 버튼을 누르면 true로 바뀜
  bool? responseSuccessed; //백에 요청 성공하면 true, 아니면 false
  bool requestWaiting = false; //백에서 응답이 오면 true, 아니면 false
  bool requestCanceled = false;

  late AnimationController rotationController;

  late Timer countTimer;

  int remainMinutes = 0;
  int remainSeconds = 5;

  void resetCount() {
    setState(() {
      remainMinutes = 0;
      remainSeconds = 5;
    });
  }

  void countResponse() {
    setState(() {
      if (remainSeconds > 0)
        remainSeconds--;
      else if (remainMinutes > 0) {
        remainMinutes--;
        remainSeconds = 59;
      }
    });
  }

  Widget getRequestStateIcon() {
    if (requestWaiting)
      return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.only(top: vh * 0.07),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: rotationController.value,
                  color: Color.fromARGB(255, 79, 112, 229),
                  semanticsLabel: 'A',
                  strokeWidth: 10.0
                ),
              ),
            ),
            Center(
              child: Text(
                '${remainMinutes}:${remainSeconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              )
            )
          ]
        ),
      );
    if (requestSent == false) {
      return Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 79, 112, 229)
          ),
          color: Color.fromARGB(255, 79, 112, 229)
        ),
        margin: EdgeInsets.only(top: vh * 0.07),
        child: Icon(
          Icons.group_add_outlined,
          size: 100,
          color: Colors.white
        )
      );
    }
    else {
      if (responseSuccessed == true)
        return Container(
          width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: Colors.green
            ),
            color: Colors.green
          ),
          margin: EdgeInsets.only(top: vh * 0.07),
          child: Icon(
            Icons.done_all_outlined,
            size: 100,
            color: Colors.white
          )
        );
      else
      return Container(
        width: 150,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: Colors.red
            ),
            color: Colors.red
          ),
          margin: EdgeInsets.only(top: vh * 0.07),
          child: Icon(
            Icons.priority_high_outlined,
            size: 100,
            color: Colors.white
          )
      );
    }
  }

  String getRequestStateText() {
    if (requestWaiting)
      return '요청을 전송중입니다\n';
    else {
      if (!requestSent)
        return '아래 버튼을 눌러 요청을 전송하십시오\n상대방도 요청하면 문진표가 연동됩니다';
      if (requestCanceled)
        return '요청을 취소하였습니다\n';
      if (remainMinutes == 0 && remainSeconds == 0)
        return '상대방의 요청이 없습니다\n확인 후 다시 시도하십시오';
      if (responseSuccessed == true)
        return '요청을 전송하였습니다\n';
      else
        return '요청을 실패하였습니다\n잠시 후 다시 시도하십시오';
    }
  }

  /** 검색 후 추가시 위젯 끝 */

  Widget FourthStep(BuildContext context) {
    return addDirectly == true
    ? Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('복용중인 약'),
              Icon(
                Icons.check_circle,
                color: drugsChecked ? Colors.green : Colors.grey,
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
            children: [
              Text('수술 이력 (최근 1년 이내)'),
              Icon(
                Icons.check_circle,
                color: surgeryChecked == true ? Colors.green : Colors.grey,
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
                    groupValue: surgeryExists,
                    onChanged: (value) {
                      setState(() {
                        surgeryExists = value!;
                        checkSurgery();
                      });
                    },
                    activeColor: Color.fromARGB(255, 79, 112, 229)
                  ),
                  Text('해당 있음')
                ]
              ),
            ]
          )
        ),
        surgeryExists == true ?
          Container(
            child: SurgeryAllField()
          ) :
          Container(),
        surgeryExists == true ?
          Container(
            margin: EdgeInsets.only(top: 15.0),
            height: 35.0,
            width: vw * 0.812,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.elliptical(7.5,7.5)),
              border: Border.all(
                color: Color.fromARGB(255, 79, 112, 229),
                width: 2.0,
              )
            ),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    weight: 1000,
                    size: 25,
                    color: Color.fromARGB(255, 79, 112, 229)
                  )
                ]
              ),
              onTap: addSurgeryTextField
            )
          ) :
          Container()
      ]
    )
    : Column(
      children: [
        getRequestStateIcon(),
        Container(
          margin: EdgeInsets.only(top: vh * 0.05),
          child: Text(
            getRequestStateText(),
            style: TextStyle(
              fontSize: vw >= 300 ? 20 : 17,
              fontWeight: FontWeight.bold
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(top: vh * 0.05),
          child: InkWell(
            child: Container(
              width: 100,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                color: !requestWaiting ? Color.fromARGB(255, 79, 112, 229) : Colors.red
              ),
              child: Text(
                !requestWaiting ? '요청하기' : '취소하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                )
              )
            ),
            onTap: !requestWaiting
            ? () {
              setState(() {
                countTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                  if (remainMinutes == 0 && remainSeconds == 0) {
                    requestWaiting = false;
                    responseSuccessed = false;
                    countTimer.cancel();
                    resetCount();
                  } else {
                    countResponse();
                  }
                });
                requestWaiting = true;
                requestCanceled = false;
                requestSent = true;
              });
            }
            : () {
              setState(() {
                countTimer.cancel();
                resetCount();
                requestWaiting = false;
                requestCanceled = true;
                responseSuccessed = false;
              });
            }
          )
        )
      ]
    );
  }
  /** 건강 상태 입력 네번째 단계 끝 */

  /** 건강 상태 입력 다섯번째 단계 */
  
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
  bool smokingChecked = false;

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
  bool drinkingChecked = false;

  TextEditingController etcTextEditController = TextEditingController();
  final etcNode = FocusNode();

  bool? etcExists = null;
  bool etcChecked = false;
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

  bool checkFifthStep() {
    if (addDirectly == true)
      return smokingChecked && drinkingChecked && etcChecked ? true : false;
    else
      return true;
  }

  Widget FifthStep(BuildContext context) {
    return addDirectly == true
    ? Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('흡연 여부'),
              Icon(
                Icons.check_circle,
                color: smokingChecked ? Colors.green : Colors.grey,
                size: 14
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
                      }
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
                      }
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
            children: [
              Text('음주 여부'),
              Icon(
                Icons.check_circle,
                color: drinkingChecked ? Colors.green : Colors.grey,
                size: 14
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
                      }
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
                      }
                    ),
                    Text('해당 있음')
                  ]
                ),
              )
            ]
          )
        ),
        isDrinker == true ? DrinkingField() : Container(),
        Container(
          margin: EdgeInsets.only(top: vh * 0.02),
          child: Row(
            children: [
              Text('기타 특이사항'),
              Icon(
                Icons.check_circle,
                color: etcChecked ? Colors.green : Colors.grey,
                size: 14
              )
            ]
          )
        ),
        Container(
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
                      }
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
                      }
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
    )
    : Column(

    );
  }

  /** 건강 상태 입력 다섯번째 단계 끝 */

  /** 현재 단계에 따라 완성도 체크해서 다음 버튼 활성 or 비활성 함수 */
  bool checkCurrentStep() {
    if (currentStep == 0)
      return checkFirstStep();
    else if (currentStep == 1)
      return checkSecondStep();
    else if (currentStep == 2)
      return checkThirdStep();
    else if (currentStep == 3)
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
              borderRadius: BorderRadius.zero
            ),
            actionsPadding: EdgeInsets.only(bottom: 5.0),
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
              borderRadius: BorderRadius.zero
            ),
            actionsPadding: EdgeInsets.only(bottom: 5.0),
            title: Text('건강 정보 제출'),
            content: Text('건강 정보를 제출하시겠습니까?'),
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
          )
        );
      }
    );
  }

  String getNextButtonText() {
    if (currentStep == 4)
      return '제출';
    if (currentStep == 3 && addDirectly == false)
      return '완료';
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
            } : cancleAddAlert
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
                getNextButtonText(),
                style: TextStyle(
                  color: checkCurrentStep() ? Colors.blueAccent : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
              onPressed: checkCurrentStep() ? 
                () {
                  if (addDirectly == true && currentStep == 4)
                    completeAddAlert();
                  else if (addDirectly == false && currentStep == 3) {
                    Navigator.pop(context);
                  }
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
      )
    );
  }
}