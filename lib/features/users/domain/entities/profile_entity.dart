import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String? bio;
  final List<String> skills;
  final String? city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool availability;
  final double? hourlyRate;
  final String? category;
  final int? experience;
  final String? website;

  const ProfileEntity({
    required this.id,
    required this.userId,
    this.bio,
    this.skills = const [],
    this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.availability = true,
    this.hourlyRate,
    this.category,
    this.experience,
    this.website,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      bio: json['bio'],
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : [],
      city: json['city'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      availability: json['availability'] ?? true,
      hourlyRate: json['hourlyRate']?.toDouble(),
      category: json['category'],
      experience: json['experience'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'skills': skills,
        'city': city,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'availability': availability,
        'hourlyRate': hourlyRate,
        'category': category,
        'experience': experience,
        'website': website,
      };

  ProfileEntity copyWith({
    String? bio,
    List<String>? skills,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    bool? availability,
    double? hourlyRate,
    String? category,
    int? experience,
    String? website,
  }) {
    return ProfileEntity(
      id: id,
      userId: userId,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availability: availability ?? this.availability,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      category: category ?? this.category,
      experience: experience ?? this.experience,
      website: website ?? this.website,
    );
  }

  @override
  List<Object?> get props => [id, userId, bio, skills, city];
}
