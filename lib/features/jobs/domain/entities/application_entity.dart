import 'package:equatable/equatable.dart';
import 'job_entity.dart';

class ApplicationEntity extends Equatable {
  final String id;
  final String jobId;
  final String applicantId;
  final String? coverLetter;
  final String status; // PENDING, REVIEWED, ACCEPTED, REJECTED
  final DateTime createdAt;
  final JobEntity? job;

  const ApplicationEntity({
    required this.id,
    required this.jobId,
    required this.applicantId,
    this.coverLetter,
    this.status = 'PENDING',
    required this.createdAt,
    this.job,
  });

  factory ApplicationEntity.fromJson(Map<String, dynamic> json) {
    return ApplicationEntity(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      applicantId: json['applicantId'] ?? '',
      coverLetter: json['coverLetter'],
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      job: json['job'] != null ? JobEntity.fromJson(json['job']) : null,
    );
  }

  @override
  List<Object?> get props => [id, jobId, status];
}
