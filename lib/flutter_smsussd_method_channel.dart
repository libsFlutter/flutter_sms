import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_smsussd_platform_interface.dart';

/// An implementation of [FlutterSmsussdPlatform] that uses method channels.
class MethodChannelFlutterSmsussd extends FlutterSmsussdPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_smsussd');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('sendSms', {
        'phoneNumber': phoneNumber,
        'message': message,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'SMS_NOT_AVAILABLE') {
        throw UnsupportedError('SMS is not available on this device');
      } else if (e.code == 'NO_VIEW_CONTROLLER') {
        throw StateError('No view controller available to present SMS composer');
      } else if (e.code == 'SMS_SEND_ERROR') {
        throw StateError('Failed to send SMS: ${e.message}');
      }
      rethrow;
    }
  }

  @override
  Future<List<SmsMessage>> getSmsMessages() async {
    try {
      final List<dynamic> result = await methodChannel.invokeMethod<List<dynamic>>('getSmsMessages') ?? [];
      return result.map((item) => SmsMessage.fromMap(Map<String, dynamic>.from(item))).toList();
    } on PlatformException catch (e) {
      if (e.code == 'NOT_SUPPORTED') {
        throw UnsupportedError('Reading SMS messages is not supported on this platform');
      }
      rethrow;
    }
  }

  @override
  Future<List<SmsMessage>> getSmsMessagesByPhoneNumber(String phoneNumber) async {
    try {
      final List<dynamic> result = await methodChannel.invokeMethod<List<dynamic>>('getSmsMessagesByPhoneNumber', {
        'phoneNumber': phoneNumber,
      }) ?? [];
      return result.map((item) => SmsMessage.fromMap(Map<String, dynamic>.from(item))).toList();
    } on PlatformException catch (e) {
      if (e.code == 'NOT_SUPPORTED') {
        throw UnsupportedError('Reading SMS messages is not supported on this platform');
      }
      rethrow;
    }
  }

  @override
  Future<bool> requestSmsPermissions() async {
    final result = await methodChannel.invokeMethod<bool>('requestSmsPermissions');
    return result ?? false;
  }

  @override
  Future<bool> hasSmsPermissions() async {
    final result = await methodChannel.invokeMethod<bool>('hasSmsPermissions');
    return result ?? false;
  }
}
