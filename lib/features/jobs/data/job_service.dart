import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../domain/entities/job_entity.dart';

// ─── Job Service ──────────────────────────────────────────────

class JobService {
  final ApiClient _api;

  JobService(this._api);

  Future<List<JobEntity>> getJobs({
    String? search,
    String? type,
    String? category,
    String? location,
    int page = 1,
  }) async {
    final response = await _api.get('/jobs', params: {
      'page': page,
      'limit': 20,
      if (search != null && search.isNotEmpty) 'search': search,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (location != null) 'location': location,
    });

    final jobs = (response.data['data']['jobs'] as List)
        .map((j) => JobEntity.fromJson(j))
        .toList();

    return jobs;
  }

  Future<JobEntity> getJobById(String id) async {
    final response = await _api.get('/jobs/$id');
    return JobEntity.fromJson(response.data['data']['job']);
  }

  Future<JobEntity> createJob({
    required String title,
    required String description,
    required String companyName,
    required String location,
    String? salary,
    required String type,
    required String category,
    bool isSponsored = false,
  }) async {
    final response = await _api.post('/jobs', data: {
      'title': title,
      'description': description,
      'companyName': companyName,
      'location': location,
      'salary': salary,
      'type': type.toUpperCase(),
      'category': category,
      'isSponsored': isSponsored,
    });

    return JobEntity.fromJson(response.data['data']['job']);
  }

  Future<List<JobEntity>> getMyJobs() async {
    final response = await _api.get('/jobs/me/posted');
    return (response.data['data']['jobs'] as List)
        .map((j) => JobEntity.fromJson(j))
        .toList();
  }

  Future<void> applyToJob(String jobId, {String? coverLetter}) async {
    await _api.post('/jobs/$jobId/apply', data: {
      if (coverLetter != null) 'coverLetter': coverLetter,
    });
  }
}

// ─── Provider ─────────────────────────────────────────────────

final jobServiceProvider = Provider<JobService>((ref) {
  return JobService(ref.read(apiClientProvider));
});

// ─── Jobs List Provider (async, from API) ─────────────────────

final apiJobsProvider = FutureProvider.autoDispose<List<JobEntity>>((ref) async {
  final search = ref.watch(jobsSearchQueryProvider);
  final type = ref.watch(jobsTypeFilterProvider);

  final service = ref.read(jobServiceProvider);
  return service.getJobs(
    search: search.isEmpty ? null : search,
    type: type == 'Tous' ? null : type.toUpperCase(),
  );
});

final jobsSearchQueryProvider = StateProvider<String>((ref) => '');
final jobsTypeFilterProvider = StateProvider<String>((ref) => 'Tous');
