class User {
  final String id;
  final String name;
  final String tel;
  final String address;
  final int age;
  final String sex;
  final String bloodType;
  final String relation;
  final bool allergy;
  final bool drugs;
  final bool smoking;
  final bool drinking;
  final bool surgery;

  User({
    required this.id,
    required this.name,
    required this.tel,
    required this.address,
    required this.age,
    required this.sex,
    required this.bloodType,
    required this.relation,
    required this.allergy,
    required this.drugs,
    required this.smoking, 
    required this.drinking,
    required this.surgery
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      tel: json['tel'],
      address: json['address'],
      age: json['age'],
      sex: json['sex'],
      bloodType: json['bloodType'],
      relation: json['relation'],
      allergy: json['allergy'],
      drugs: json['drugs'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      surgery: json['surgery']
    );
  }
}