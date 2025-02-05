class FindUserState {
  int? id;
  String? uid;
  String? name;
  String? email;
  String? newPass;

  FindUserState(
      {this.id = 0,
      this.uid = "",
      this.name = "",
      required this.email,
      this.newPass = ""});

  FindUserState copyWith(
      {int? id, String? uid, String? name, String? email, String? newPass}) {
    return FindUserState(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        newPass: newPass ?? this.newPass);
  }
}
