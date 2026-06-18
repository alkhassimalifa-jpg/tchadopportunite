import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? photoUrl;
  final bool isVerified;
  final bool isPremium;
  final String preferredLanguage;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phone,
    this.photoUrl,
    this.isVerified = false,
    this.isPremium = false,
    this.preferredLanguage = 'fr',
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? 'CLIENT',
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      isVerified: json['isVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      preferredLanguage: json['preferredLanguage'] ?? 'fr',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'phone': phone,
        'photoUrl': photoUrl,
        'isVerified': isVerified,
        'isPremium': isPremium,
        'preferredLanguage': preferredLanguage,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        phone,
        photoUrl,
        isVerified,
        isPremium,
        preferredLanguage,
        createdAt,
      ];
}
