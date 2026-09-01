class Profile {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String currency;
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final int budgetAlertThreshold;

  const Profile({
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
}
