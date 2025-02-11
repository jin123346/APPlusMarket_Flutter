/*
 2025.1.27 하진희 회원가입시 유저 객체
 */
class User {
  final int? id;
  final String? uid;
  final String? password;
  final String? hp;
  final String? name;
  final String? nickName;
  final String? email;
  final DateTime? birthday;
  final String? profileImg;

  User({
    this.id,
    this.uid,
    this.password,
    this.hp,
    this.name,
    this.nickName,
    this.email,
    this.birthday,
    this.profileImg,
  });

  User copyWith(
      {int? id,
      String? uid,
      String? password,
      String? hp,
      String? name,
      String? nickName,
      String? email,
      String? profileImg,
      DateTime? birthday}) {
    return User(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        password: password ?? this.password,
        birthday: birthday ?? this.birthday,
        hp: hp ?? this.hp,
        name: name ?? this.name,
        email: email ?? this.email,
        profileImg: profileImg ?? this.profileImg,
        nickName: nickName ?? this.nickName);
  }

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "password": password,
      "email": email,
      "hp": hp,
      "name": name,
      "nickName": nickName,
      "profileImg": profileImg,
      "birthday": birthday?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        uid: map['uid'],
        email: map['email'],
        password: map['password'] ?? null,
        hp: map['hp'],
        name: map['name'],
        nickName: map['nickName'],
        profileImg: map['profileImg'],
        birthday: map['birthday']);
  }

  @override
  String toString() {
    return 'User{id: $id, uid: $uid, password: $password, hp: $hp, name: $name, nickName: $nickName, email: $email, birthday: $birthday}';
  }
}
