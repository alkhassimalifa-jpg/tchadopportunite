import 'package:equatable/equatable.dart';
 
class MapProviderEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? photoUrl;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final bool isAvailable;
  final String? hourlyRate;
 
  const MapProviderEntity({
    required this.id,
    required this.name,
    required this.category,
    this.photoUrl,
    required this.latitude,
    required this.longitude,
    this.rating = 0,
    this.reviewsCount = 0,
    this.isVerified = false,
    this.isAvailable = true,
    this.hourlyRate,
  });
 
  @override
  List<Object?> get props => [id, name, latitude, longitude];
}
 
// ─── Sample providers near N'Djamena ──────────────────────────
 
final sampleProviders = [
  const MapProviderEntity(
    id: '1',
    name: 'Ahmat Soulaymane',
    category: 'Plombier',
    latitude: 12.1348,
    longitude: 15.0557,
    rating: 4.8,
    reviewsCount: 34,
    isVerified: true,
    hourlyRate: '5 000 FCFA/h',
  ),
  const MapProviderEntity(
    id: '2',
    name: 'Fatime Abakar',
    category: 'Électricienne',
    latitude: 12.1420,
    longitude: 15.0490,
    rating: 4.6,
    reviewsCount: 21,
    isVerified: true,
    hourlyRate: '6 000 FCFA/h',
  ),
  const MapProviderEntity(
    id: '3',
    name: 'Idriss Mahamat',
    category: 'Menuisier',
    latitude: 12.1280,
    longitude: 15.0610,
    rating: 4.3,
    reviewsCount: 12,
    isVerified: false,
    hourlyRate: '4 500 FCFA/h',
  ),
  const MapProviderEntity(
    id: '4',
    name: 'Khadidja Oumar',
    category: 'Coiffeuse à domicile',
    latitude: 12.1390,
    longitude: 15.0650,
    rating: 4.9,
    reviewsCount: 56,
    isVerified: true,
    hourlyRate: '3 000 FCFA/h',
  ),
  const MapProviderEntity(
    id: '5',
    name: 'Brahim Adoum',
    category: 'Peintre',
    latitude: 12.1250,
    longitude: 15.0480,
    rating: 4.1,
    reviewsCount: 8,
    isVerified: false,
    isAvailable: false,
    hourlyRate: '4 000 FCFA/h',
  ),
  const MapProviderEntity(
    id: '6',
    name: 'Mariam Hassan',
    category: 'Couturière',
    latitude: 12.1450,
    longitude: 15.0530,
    rating: 4.7,
    reviewsCount: 29,
    isVerified: true,
    hourlyRate: '3 500 FCFA/h',
  ),
];