class Profile {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final String phone;
  final String unit;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phone,
    required this.gender,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phone': phone,
      'unit': unit,
      'gender': gender
    };
  }
}