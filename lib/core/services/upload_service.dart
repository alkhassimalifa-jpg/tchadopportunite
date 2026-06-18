import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

class UploadService {
  final ApiClient _api;

  UploadService(this._api);

  // ─── Upload profile photo ────────────────────────────────────

  Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      final response = await _api.uploadFile(
        '/upload/photo',
        file: imageFile,
        fieldName: 'photo',
      );

      if (response.data['success'] == true) {
        return response.data['data']['photoUrl'] as String;
      }
      throw Exception(response.data['message'] ?? 'Erreur upload');
    } on Exception catch (e) {
      throw Exception('Erreur upload photo: $e');
    }
  }

  // ─── Upload CV PDF ────────────────────────────────────────────

  Future<String> uploadCV(File pdfFile) async {
    try {
      final response = await _api.uploadFile(
        '/upload/cv',
        file: pdfFile,
        fieldName: 'cv',
      );

      if (response.data['success'] == true) {
        return response.data['data']['cvUrl'] as String;
      }
      throw Exception(response.data['message'] ?? 'Erreur upload');
    } on Exception catch (e) {
      throw Exception('Erreur upload CV: $e');
    }
  }
}

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.read(apiClientProvider));
});