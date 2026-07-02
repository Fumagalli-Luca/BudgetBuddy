import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

enum NotificationPermissionState { granted, denied, provisional, mock }

abstract class NotificationService {
  Future<NotificationPermissionState> requestPermission();

  Future<String?> getDeviceToken();
}

class MockNotificationService implements NotificationService {
  const MockNotificationService();

  @override
  Future<String?> getDeviceToken() async => 'mock-fcm-token';

  @override
  Future<NotificationPermissionState> requestPermission() async =>
      NotificationPermissionState.mock;
}

class FirebaseNotificationService implements NotificationService {
  const FirebaseNotificationService();

  @override
  Future<String?> getDeviceToken() async {
    try {
      return FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<NotificationPermissionState> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      return switch (settings.authorizationStatus) {
        AuthorizationStatus.authorized => NotificationPermissionState.granted,
        AuthorizationStatus.provisional => NotificationPermissionState.provisional,
        AuthorizationStatus.denied => NotificationPermissionState.denied,
        AuthorizationStatus.notDetermined => NotificationPermissionState.denied,
      };
    } catch (_) {
      return NotificationPermissionState.denied;
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  if (AppConfig.enableFirebaseMessaging) {
    return const FirebaseNotificationService();
  }
  return const MockNotificationService();
});
