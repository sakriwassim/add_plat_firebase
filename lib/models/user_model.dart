class UserModel {
  late String name;
  late bool isAdmin;
  late List<dynamic>? favorites;
  UserModel({required this.name, required this.isAdmin, this.favorites});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isAdmin = json['isAdmin'];
    favorites = json['favorites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['isAdmin'] = isAdmin;
    data['favorites'] = favorites;
    return data;
  }
}
