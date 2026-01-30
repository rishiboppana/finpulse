/// Authentication token model for session management.
/// Designed for migration to Firebase Auth / GCP Identity Platform.

class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const AuthToken({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is valid (exists and not expired)
  bool get isValid => accessToken.isNotEmpty && !isExpired;

  /// Create from JSON (API response)
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  /// Convert to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'AuthToken(expires: $expiresAt, valid: $isValid)';
}
