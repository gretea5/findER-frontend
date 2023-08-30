class HospitalPreviewModel  {
  final int hospitalId;
  final String name;
  final String address;
  final String representativeContact;
  final String emergencyContact;
  final int? hvec; 
  final double distance;
  final String arrivalTime;

  HospitalPreviewModel.fromJson(Map<String, dynamic> json)
    : hospitalId = json["hospitalId"] as int,
      name = json['name'] as String,
      address = json['address'] as String,
      representativeContact = json['representativeContact'] as String,
      emergencyContact = json['emergencyContact'] as String,
      hvec = json['hvec'] as int?,
      distance = json['distance'] as double,
      arrivalTime = json['arrivalTime'] as String;
}