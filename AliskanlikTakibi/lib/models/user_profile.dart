class UserProfile {
  final String displayName;
  final String avatarIcon;
  final String themeMode; // 'system', 'light', 'dark'
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;

  const UserProfile({
    this.displayName = 'Alışkanlık Avcısı',
    this.avatarIcon = '🌱',
    this.themeMode = 'system',
    this.notificationsEnabled = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
  });

  UserProfile copyWith({
    String? displayName,
    String? avatarIcon,
    String? themeMode,
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'avatarIcon': avatarIcon,
      'themeMode': themeMode,
      'notificationsEnabled': notificationsEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      displayName: (map['displayName'] as String?) ?? 'Alışkanlık Avcısı',
      avatarIcon: (map['avatarIcon'] as String?) ?? '🌱',
      themeMode: (map['themeMode'] as String?) ?? 'system',
      notificationsEnabled: (map['notificationsEnabled'] as bool?) ?? true,
      reminderHour: (map['reminderHour'] as int?) ?? 20,
      reminderMinute: (map['reminderMinute'] as int?) ?? 0,
    );
  }
}
