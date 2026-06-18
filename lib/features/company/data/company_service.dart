import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../jobs/domain/entities/job_entity.dart';
import '../domain/entities/received_application_entity.dart';

class CompanyService {
  final ApiClient _api;

  CompanyService(this._api);

  Future<List<JobEntity>> getMyPostedJobs() async {
    final response = await _api.get('/jobs/me/posted');
    return (response.data['data']['jobs'] as List)
        .map((j) => JobEntity.fromJson(j))
        .toList();
  }

  Future<List<ReceivedApplicationEntity>> getReceivedApplications() async {
    final response = await _api.get('/jobs/me/received-applications');
    return (response.data['data']['applications'] as List)
        .map((a) => ReceivedApplicationEntity.fromJson(a))
        .toList();
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _api.patch('/jobs/applications/$applicationId/status', data: {
      'status': status,
    });
  }
}

final companyServiceProvider = Provider<CompanyService>((ref) {
  return CompanyService(ref.read(apiClientProvider));
});

final myPostedJobsProvider =
    FutureProvider.autoDispose<List<JobEntity>>((ref) async {
  return ref.read(companyServiceProvider).getMyPostedJobs();
});

final receivedApplicationsProvider =
    FutureProvider.autoDispose<List<ReceivedApplicationEntity>>((ref) async {
  return ref.read(companyServiceProvider).getReceivedApplications();
});