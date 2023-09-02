class User {
  final String email;
  final int id; //문진표 id
  // final int userId; //사용자 id
  final String name;
  final String phoneNum;
  final String address;
  final int age;
  final String gender;
  final String bloodType;
  final String familyRelations;
  final String? allergy;
  final String? medicine;
  final String? smokingCycle;
  final String? drinkingCycle;
  final String? etc;
  // final String surgery;
  final bool isLinked;

  User({
    required this.email,
    required this.id,
    // required this.userId,
    required this.name,
    required this.phoneNum,
    required this.address,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.familyRelations,
    required this.allergy,
    required this.medicine,
    required this.smokingCycle, 
    required this.drinkingCycle,
    required this.etc,
    // required this.surgery,
    required this.isLinked
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      // userId: json['userId'],
      name: json['name'],
      phoneNum: json['phoneNum'],
      address: json['address'],
      age: json['age'],
      gender: json['gender'],
      bloodType: json['bloodType'],
      familyRelations: json['familyRelations'],
      allergy: json['allergy'],
      medicine: json['medicine'],
      smokingCycle: json['smokingCycle'],
      drinkingCycle: json['drinkingCycle'],
      etc: json['etc'],
      // surgery: json['surgery'],
      isLinked: json['isLinked']
    );
  }
}