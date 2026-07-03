class UserModel {
  final String id;
  final String name;
  final String email;
  final String planId;
  final String avatarUrl;
  final String? sessionToken;
  final DateTime? sessionCreatedAt;
  final DateTime? planCreatedAt;
  final String? passwordHash;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.planId,
    required this.avatarUrl,
    this.sessionToken,
    this.sessionCreatedAt,
    this.planCreatedAt,
    this.passwordHash,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? planId,
    String? avatarUrl,
    String? sessionToken,
    DateTime? sessionCreatedAt,
    DateTime? planCreatedAt,
    String? passwordHash,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      planId: planId ?? this.planId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      sessionToken: sessionToken ?? this.sessionToken,
      sessionCreatedAt: sessionCreatedAt ?? this.sessionCreatedAt,
      planCreatedAt: planCreatedAt ?? this.planCreatedAt,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'planId': planId,
      'avatarUrl': avatarUrl,
      'sessionToken': sessionToken,
      'sessionCreatedAt': sessionCreatedAt?.toIso8601String(),
      'planCreatedAt': planCreatedAt?.toIso8601String(),
      'passwordHash': passwordHash,
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      planId: json['planId'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      sessionToken: json['sessionToken'],
      sessionCreatedAt: json['sessionCreatedAt'] != null
          ? DateTime.tryParse(json['sessionCreatedAt'])
          : null,
      planCreatedAt: json['planCreatedAt'] != null
          ? DateTime.tryParse(json['planCreatedAt'])
          : null,
      passwordHash: json['passwordHash'],
    );
  }
}
