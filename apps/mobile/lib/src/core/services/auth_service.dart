import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

abstract class AuthService {
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> deleteAccount();
}

class MockAuthService implements AuthService {
  const MockAuthService();

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}
}

class SupabaseAuthService implements AuthService {
  SupabaseAuthService(this._client);

  final SupabaseClient _client;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> deleteAccount() async {
    await _client.functions.invoke(
      'delete_user_account',
      body: {'confirmation': 'DELETE'},
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  if (!AppConfig.hasSupabase) {
    return const MockAuthService();
  }
  return SupabaseAuthService(Supabase.instance.client);
});
