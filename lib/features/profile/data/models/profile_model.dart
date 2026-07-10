class ProfileModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String currency;
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final int budgetAlertThreshold;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.currency,
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.budgetAlertThreshold,
  });

  /// Convert JSON (Map) → Model
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"] as String,
      email: json["email"] as String,
      name: json["name"] as String,
      avatarUrl: json["avatarUrl"] as String?,
      currency: json["currency"] as String? ?? "USD",
      language: json["language"] as String? ?? "en",
      theme: json["theme"] as String? ?? "light",
      notificationsEnabled: json["notificationsEnabled"] as bool? ?? true,
      budgetAlertThreshold: json["budgetAlertThreshold"] as int? ?? 80,
    );
  }

  /// Convert Model → JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "avatarUrl": avatarUrl,
      "currency": currency,
      "language": language,
      "theme": theme,
      "notificationsEnabled": notificationsEnabled,
      "budgetAlertThreshold": budgetAlertThreshold,
    };
  }
}
