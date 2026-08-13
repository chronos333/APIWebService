class UserModel {
  String? id;
  String name;
  String email;

  //constructor
  UserModel({
    this.id,
    required this.name,
    required this.email,
  });

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }

  //FromMap => factory => constructor alternativo ao constructor principal
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}