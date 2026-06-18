import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/constants/storage_keys.dart';
import '../../../users/domain/entities/user_entity.dart';

class AuthState {
  final UserEntity? user;
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<AuthState> build() async {
    return _checkExistingSession();
  }

  Future<AuthState> _checkExistingSession() async {
    try {
      final token = await StorageService.getAccessToken();
      if (token == null) return const AuthState(isLoggedIn: false);
      final api = ref.read(apiClientProvider);
      final response = await api.get('/auth/me');
      final user = UserEntity.fromJson(response.data['data']['user']);
      return AuthState(user: user, isLoggedIn: true);
    } catch (_) {
      await StorageService.clearAll();
      return const AuthState(isLoggedIn: false);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );
      final token = await credential.user!.getIdToken();
      await _processFirebaseToken(token!);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(_mapFirebaseError(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = const AsyncData(AuthState(isLoggedIn: false));
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final token = await userCredential.user!.getIdToken();
      await _processFirebaseToken(token!);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(_mapFirebaseError(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
    String preferredLanguage = 'fr',
  }) async {
    state = const AsyncLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      await credential.user!.updateDisplayName('$firstName $lastName');
      final token = await credential.user!.getIdToken();
      final api = ref.read(apiClientProvider);
      final response = await api.post('/auth/register', data: {
        'firebaseToken': token,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role.toUpperCase(),
        'phone': phone,
        'preferredLanguage': preferredLanguage.toUpperCase(),
      });
      await StorageService.saveTokens(
        accessToken: response.data['data']['accessToken'],
        refreshToken: response.data['data']['refreshToken'],
      );
      final user = UserEntity.fromJson(response.data['data']['user']);
      state = AsyncData(AuthState(user: user, isLoggedIn: true));
    } on FirebaseAuthException catch (e) {
      state = AsyncError(_mapFirebaseError(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      final api = ref.read(apiClientProvider);
      await api.post('/auth/logout', data: {'refreshToken': refreshToken});
    } catch (_) {}
    await _googleSignIn.signOut();
    await _auth.signOut();
    await StorageService.clearAll();
    final box = Hive.box(StorageKeys.authBox);
    await box.clear();
    state = const AsyncData(AuthState(isLoggedIn: false));
  }

  Future<void> refreshUser() async {
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get('/auth/me');
      final user = UserEntity.fromJson(response.data['data']['user']);
      state = AsyncData(state.value!.copyWith(user: user));
    } catch (_) {}
  }

  Future<void> _processFirebaseToken(String token) async {
    final api = ref.read(apiClientProvider);
    final response = await api.post('/auth/login', data: {'firebaseToken': token});
    await StorageService.saveTokens(
      accessToken: response.data['data']['accessToken'],
      refreshToken: response.data['data']['refreshToken'],
    );
    final user = UserEntity.fromJson(response.data['data']['user']);
    state = AsyncData(AuthState(user: user, isLoggedIn: true));
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Compte introuvable.';
      case 'wrong-password': return 'Mot de passe incorrect.';
      case 'email-already-in-use': return 'Email déjà utilisé.';
      case 'weak-password': return 'Mot de passe trop faible.';
      case 'invalid-email': return 'Email invalide.';
      case 'user-disabled': return 'Compte désactivé.';
      case 'too-many-requests': return 'Trop de tentatives.';
      default: return e.message ?? "Erreur d'authentification.";
    }
  }
}

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.isLoggedIn ?? false;
});
