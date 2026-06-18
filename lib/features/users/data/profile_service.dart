import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../domain/entities/profile_entity.dart';

class ProfileService {
  final ApiClient _api;

  ProfileService(this._api);

  Future<ProfileEntity?> getMyProfile() async {
    final response = await _api.get('/profiles/me');
    final data = response.data['data']['profile'];
    if (data == null) return null;
    return ProfileEntity.fromJson(data);
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    List<String>? skills,
    String? city,
    bool? availability,
    double? hourlyRate,
    String? category,
  }) async {
    await _api.put('/profiles/me', data: {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (skills != null) 'skills': skills,
      if (city != null) 'city': city,
      if (availability != null) 'availability': availability,
      if (hourlyRate != null) 'hourlyRate': hourlyRate,
      if (category != null) 'category': category,
    });
  }

  Future<Map<String, dynamic>> getMyStats() async {
    final response = await _api.get('/profiles/me/stats');
    return response.data['data']['stats'];
  }
}

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(ref.read(apiClientProvider));
});

final myProfileProvider =
    FutureProvider.autoDispose<ProfileEntity?>((ref) async {
  return ref.read(profileServiceProvider).getMyProfile();
});

final myStatsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  return ref.read(profileServiceProvider).getMyStats();
});