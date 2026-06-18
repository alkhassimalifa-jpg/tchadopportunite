import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../jobs/domain/entities/job_entity.dart';

class FavoriteService {
  final ApiClient _api;

  FavoriteService(this._api);

  Future<void> addFavorite(String targetId, String targetType) async {
    await _api.post('/favorites', data: {
      'targetId': targetId,
      'targetType': targetType,
    });
  }

  Future<void> removeFavorite(String targetId, String targetType) async {
    await _api.delete('/favorites/$targetType/$targetId');
  }

  Future<bool> checkFavorite(String targetId, String targetType) async {
    final response = await _api.get('/favorites/check/$targetType/$targetId');
    return response.data['data']['isFavorite'] as bool;
  }

  Future<List<JobEntity>> getFavoriteJobs() async {
    final response = await _api.get('/favorites', params: {'type': 'JOB'});
    final favorites = response.data['data']['favorites'] as List;
    return favorites
        .where((f) => f['job'] != null)
        .map((f) => JobEntity.fromJson(f['job']))
        .toList();
  }
}

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  return FavoriteService(ref.read(apiClientProvider));
});

final favoriteJobsProvider =
    FutureProvider.autoDispose<List<JobEntity>>((ref) async {
  return ref.read(favoriteServiceProvider).getFavoriteJobs();
});

// State to track favorite status per job (avoids repeated API calls)
final favoriteStatusProvider = StateProvider.family<bool, String>((ref, jobId) => false);