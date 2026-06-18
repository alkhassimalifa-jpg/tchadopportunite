import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String giverId;
  final String giverName;
  final String? giverPhoto;
  final String receiverId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.giverId,
    required this.giverName,
    this.giverPhoto,
    required this.receiverId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewEntity.fromJson(Map<String, dynamic> json) {
    final giver = json['giver'] ?? {};
    return ReviewEntity(
      id: json['id'] ?? '',
      giverId: json['giverId'] ?? giver['id'] ?? '',
      giverName: '${giver['firstName'] ?? ''} ${giver['lastName'] ?? ''}'.trim(),
      giverPhoto: giver['photoUrl'],
      receiverId: json['receiverId'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, giverId, receiverId, rating];
}