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
    final result = await methodChannel.invokeMethod<bool>('sendSms', {
      'phoneNumber': phoneNumber,
      'message': message,
    });
    return result ?? false;
  }

  @override
  Future<List<SmsMessage>> getSmsMessages() async {
    final List<dynamic> result = await methodChannel.invokeMethod<List<dynamic>>('getSmsMessages') ?? [];
    return result.map((item) => SmsMessage.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  @override
  Future<List<SmsMessage>> getSmsMessagesByPhoneNumber(String phoneNumber) async {
    final List<dynamic> result = await methodChannel.invokeMethod<List<dynamic>>('getSmsMessagesByPhoneNumber', {
      'phoneNumber': phoneNumber,
    }) ?? [];
    return result.map((item) => SmsMessage.fromMap(Map<String, dynamic>.from(item))).toList();
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
