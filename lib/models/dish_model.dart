class DishModel {
  DishModel({
    this.id,
    required this.name,
    this.isFavorite,
  });
  late final String name;
  late final String? id;
  late final bool? isFavorite;

  DishModel.fromJson(Map<String, dynamic> json, {required String docId}) {
    name = json['name'];
    id = docId;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }
}
