import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('BB_SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('BB_SUPABASE_ANON_KEY');
  static const enableFirebaseMessaging =
      bool.fromEnvironment('BB_ENABLE_FIREBASE_MESSAGING');
  static const aiProvider = String.fromEnvironment(
    'BB_AI_PROVIDER',
    defaultValue: 'mock',
  );

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static Future<void> initializeSupabaseIfConfigured() async {
    if (enableFirebaseMessaging) {
      try {
        await Firebase.initializeApp();
      } catch (_) {
        // Firebase remains optional in the MVP; the notification service
        // falls back safely when native configuration is absent.
      }
    }

    if (!hasSupabase) {
      return;
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
