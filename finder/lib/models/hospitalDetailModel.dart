class HospitalDetailModel  {
  final String name;
  final String address;
  final String simpleAddress;
  final String representativeContact;
  final String emergencyContact;
  final bool ambulance;
  final bool ct;
  final bool mri;
  final int hvec;
  final double distance;
  final String arrivalTime;
  final double lat;
  final double lon;
  final BedDataDTO bedData;

  HospitalDetailModel.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
      address = json['address'] as String,
      simpleAddress = json['simpleAddress'] as String,
      representativeContact = json['representativeContact'] as String,
      emergencyContact = json['emergencyContact'] as String,
      ambulance =  json['ambulance'] as bool,
      ct = json['ct'] as bool,
      mri =  json['mri'] as bool,
      hvec = json['hvec'] as int,
      distance = json['distance'] as double,
      arrivalTime = json['arrivalTime'] as String,
      lat = json['lat'] as double,
      lon = json['lon'] as double,
      bedData = BedDataDTO.fromJson(json['bedDataDto']);
}

class BedDataDTO {
  final String successTime;
  final double percent;
  final double otherPercent;
  final List<int> twoAgoList;
  final List<int> oneAgoList;

  BedDataDTO({
    required this.successTime,
    required this.percent,
    required this.otherPercent,
    required this.twoAgoList,
    required this.oneAgoList,
  });

  BedDataDTO.fromJson(Map<String, dynamic> json) 
    : successTime = json['successTime'] as String,
      percent = json['percent'] as double,
      otherPercent = json['otherPercent'] as double,
      twoAgoList = List<int>.from(json['twoAgoList']),
      oneAgoList = List<int>.from(json['oneAgoList']);
}