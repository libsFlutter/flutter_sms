
import 'flutter_smsussd_platform_interface.dart';

class FlutterSmsussd {
  Future<String?> getPlatformVersion() {
    return FlutterSmsussdPlatform.instance.getPlatformVersion();
  }

  /// Send SMS message
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) {
    return FlutterSmsussdPlatform.instance.sendSms(
      phoneNumber: phoneNumber,
      message: message,
    );
  }

  /// Get all SMS messages
  Future<List<SmsMessage>> getSmsMessages() {
    return FlutterSmsussdPlatform.instance.getSmsMessages();
  }

  /// Get SMS messages by phone number
  Future<List<SmsMessage>> getSmsMessagesByPhoneNumber(String phoneNumber) {
    return FlutterSmsussdPlatform.instance.getSmsMessagesByPhoneNumber(phoneNumber);
  }

  /// Request SMS permissions
  Future<bool> requestSmsPermissions() {
    return FlutterSmsussdPlatform.instance.requestSmsPermissions();
  }

  /// Check if SMS permissions are granted
  Future<bool> hasSmsPermissions() {
    return FlutterSmsussdPlatform.instance.hasSmsPermissions();
  }
}
