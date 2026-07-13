class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isDefault,
  });

  /// Convert JSON (Map) → Model
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] as String,
      name: json["name"] as String,
      icon: json["icon"] as String,
      color: json["color"] as String,
      isDefault: json["isDefault"] as bool? ?? true,
    );
  }

  /// Convert Model → JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {"name": name, "icon": icon, "color": color, "isDefault": isDefault};
  }
}
