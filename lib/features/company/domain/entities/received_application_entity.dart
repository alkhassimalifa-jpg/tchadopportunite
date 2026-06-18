import 'package:equatable/equatable.dart';

class ReceivedApplicationEntity extends Equatable {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String applicantId;
  final String applicantName;
  final String? applicantPhoto;
  final String applicantEmail;
  final String? applicantPhone;
  final String? coverLetter;
  final String status;
  final DateTime createdAt;

  const ReceivedApplicationEntity({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.applicantId,
    required this.applicantName,
    this.applicantPhoto,
    required this.applicantEmail,
    this.applicantPhone,
    this.coverLetter,
    this.status = 'PENDING',
    required this.createdAt,
  });

  factory ReceivedApplicationEntity.fromJson(Map<String, dynamic> json) {
    final job = json['job'] ?? {};
    final applicant = json['applicant'] ?? {};

    return ReceivedApplicationEntity(
      id: json['id'] ?? '',
      jobId: job['id'] ?? '',
      jobTitle: job['title'] ?? '',
      companyName: job['companyName'] ?? '',
      applicantId: applicant['id'] ?? '',
      applicantName: '${applicant['firstName'] ?? ''} ${applicant['lastName'] ?? ''}'.trim(),
      applicantPhoto: applicant['photoUrl'],
      applicantEmail: applicant['email'] ?? '',
      applicantPhone: applicant['phone'],
      coverLetter: json['coverLetter'],
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, jobId, applicantId, status];
}