import 'package:cloud_firestore/cloud_firestore.dart';

enum PrivacySetting { public, friendsOnly, private }

class UserProfile {
  final String uid;
  final String username;
  final String email;
  final String avatarUrl;
  final String colorHex;
  final double totalAreaM2;
  final int totalRuns;
  final double totalDistanceM;
  final PrivacySetting privacySetting;
  final bool isActive;
  final bool isEmailVerified; // Added to handle verification lock in state
  final DateTime lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.colorHex,
    required this.totalAreaM2,
    required this.totalRuns,
    required this.totalDistanceM,
    required this.privacySetting,
    required this.isActive,
    required this.isEmailVerified,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? uid,
    String? username,
    String? email,
    String? avatarUrl,
    String? colorHex,
    double? totalAreaM2,
    int? totalRuns,
    double? totalDistanceM,
    PrivacySetting? privacySetting,
    bool? isActive,
    bool? isEmailVerified,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      colorHex: colorHex ?? this.colorHex,
      totalAreaM2: totalAreaM2 ?? this.totalAreaM2,
      totalRuns: totalRuns ?? this.totalRuns,
      totalDistanceM: totalDistanceM ?? this.totalDistanceM,
      privacySetting: privacySetting ?? this.privacySetting,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId, {bool isEmailVerified = false}) {
    PrivacySetting parsePrivacy(String? val) {
      switch (val) {
        case 'friends_only':
          return PrivacySetting.friendsOnly;
        case 'private':
          return PrivacySetting.private;
        case 'public':
        default:
          return PrivacySetting.public;
      }
    }

    DateTime parseDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      return DateTime.now();
    }

    return UserProfile(
      uid: documentId,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      colorHex: map['colorHex'] ?? 'FF5733',
      totalAreaM2: (map['totalAreaM2'] ?? 0).toDouble(),
      totalRuns: map['totalRuns'] ?? 0,
      totalDistanceM: (map['totalDistanceM'] ?? 0).toDouble(),
      privacySetting: parsePrivacy(map['privacySetting']),
      isActive: map['isActive'] ?? true,
      isEmailVerified: isEmailVerified,
      lastLoginAt: parseDateTime(map['lastLoginAt']),
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    String privacyToString(PrivacySetting setting) {
      switch (setting) {
        case PrivacySetting.friendsOnly:
          return 'friends_only';
        case PrivacySetting.private:
          return 'private';
        case PrivacySetting.public:
          return 'public';
      }
    }

    return {
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'colorHex': colorHex,
      'totalAreaM2': totalAreaM2,
      'totalRuns': totalRuns,
      'totalDistanceM': totalDistanceM,
      'privacySetting': privacyToString(privacySetting),
      'isActive': isActive,
      'lastLoginAt': FieldValue.serverTimestamp(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
