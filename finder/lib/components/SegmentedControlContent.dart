import 'package:finder/components/HospitalDetailInfo.dart';
import 'package:finder/components/HospitalDetailTrendInfo.dart';
import 'package:finder/models/hospitalDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedControlContent extends StatefulWidget {
  final double vh;
  final double vw;
  final Color themeColor;
  final Color bedColor;
  final AsyncSnapshot<HospitalDetailModel> getHospitalDetailSnapshot;
  const SegmentedControlContent({
    required this.vw,
    required this.vh,
    required this.themeColor,
    required this.bedColor,
    required this.getHospitalDetailSnapshot
  });
  @override
  State<SegmentedControlContent> createState() => _SegmentedControlContentState();
}

class _SegmentedControlContentState extends State<SegmentedControlContent> {
  int segmentedControlValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.vw * 0.6,
          child: CupertinoSegmentedControl<int>(
          selectedColor: widget.themeColor,
          borderColor: Colors.white,
          children: {
            0: Text('병원 정보'),
            1: Text('병상 추이'),
          },
          onValueChanged: (int val) {
            // 선택한 값 변경 시에만 상태 업데이트
            if (segmentedControlValue != val) {
              setState(() {
                segmentedControlValue = val;
              });
            }
          },
          groupValue: segmentedControlValue,
          ),
        ),
        segmentedControlValue == 0
        ?
          HospitalDetailInfo(
            getHospitalDetailSnapshot: widget.getHospitalDetailSnapshot,
            themeColor: widget.themeColor,
            bedColor: widget.bedColor
          )
        :
          HospitalDetailTrendInfo(
            getHospitalDetailSnapshot: widget.getHospitalDetailSnapshot,
            vh: widget.vh,
            vw: widget.vw
          )
      ],
    );
  }
}