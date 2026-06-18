import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
 
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/map_provider_entity.dart';
import '../widgets/provider_bottom_sheet.dart';
 
class ProvidersMapScreen extends ConsumerStatefulWidget {
  const ProvidersMapScreen({super.key});
 
  @override
  ConsumerState<ProvidersMapScreen> createState() => _ProvidersMapScreenState();
}
 
class _ProvidersMapScreenState extends ConsumerState<ProvidersMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  double _maxDistance = 10; // km
  String _selectedCategory = 'Tous';
 
  final List<String> _categories = [
    'Tous', 'Plombier', 'Électricienne', 'Menuisier',
    'Coiffeuse à domicile', 'Peintre', 'Couturière',
  ];
 
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }
 
  Future<void> _loadLocation() async {
    final position = await LocationService.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _isLoadingLocation = false;
    });
 
    if (position != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          13,
        ),
      );
    }
  }
 
  List<MapProviderEntity> get _filteredProviders {
    var providers = sampleProviders;
 
    if (_selectedCategory != 'Tous') {
      providers = providers
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
 
    final lat = _currentPosition?.latitude ?? LocationService.defaultLatitude;
    final lng = _currentPosition?.longitude ?? LocationService.defaultLongitude;
 
    return providers.where((p) {
      final distance = LocationService.calculateDistance(
        lat, lng, p.latitude, p.longitude,
      );
      return distance <= _maxDistance;
    }).toList();
  }
 
  Set<Marker> get _markers {
    return _filteredProviders.map((provider) {
      return Marker(
        markerId: MarkerId(provider.id),
        position: LatLng(provider.latitude, provider.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          provider.isAvailable
              ? BitmapDescriptor.hueBlue
              : BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: provider.name,
          snippet: provider.category,
          onTap: () => _showProviderSheet(provider),
        ),
        onTap: () => _showProviderSheet(provider),
      );
    }).toSet();
  }
 
  void _showProviderSheet(MapProviderEntity provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProviderBottomSheet(provider: provider),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final lat = _currentPosition?.latitude ?? LocationService.defaultLatitude;
    final lng = _currentPosition?.longitude ?? LocationService.defaultLongitude;
 
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Prestataires proches'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 13,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
 
          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),
 
          // Top filters
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                // Category filter
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final c = _categories[i];
                      final active = _selectedCategory == c;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = c),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: active
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
 
          // Distance slider
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rayon de recherche',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_maxDistance.toInt()} km · ${_filteredProviders.length} résultats',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _maxDistance = v),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _loadLocation,
        child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
      ),
    );
  }
}