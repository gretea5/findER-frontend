class HospitalMarkerModel  {
  final int hospitalId;
  final double lat;
  final double lon;

  HospitalMarkerModel.fromJson(Map<String, dynamic> json)
    : hospitalId = json["hospitalId"] as int,
      lat = json['lat'] as double,
      lon = json['lon'] as double;
}