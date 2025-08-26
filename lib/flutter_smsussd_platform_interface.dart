import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_smsussd_method_channel.dart';

abstract class FlutterSmsussdPlatform extends PlatformInterface {
  /// Constructs a FlutterSmsussdPlatform.
  FlutterSmsussdPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSmsussdPlatform _instance = MethodChannelFlutterSmsussd();

  /// The default instance of [FlutterSmsussdPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSmsussd].
  static FlutterSmsussdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSmsussdPlatform] when
  /// they register themselves.
  static set instance(FlutterSmsussdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Send SMS message
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) {
    throw UnimplementedError('sendSms() has not been implemented.');
  }

  /// Get all SMS messages
  Future<List<SmsMessage>> getSmsMessages() {
    throw UnimplementedError('getSmsMessages() has not been implemented.');
  }

  /// Get SMS messages by phone number
  Future<List<SmsMessage>> getSmsMessagesByPhoneNumber(String phoneNumber) {
    throw UnimplementedError('getSmsMessagesByPhoneNumber() has not been implemented.');
  }

  /// Request SMS permissions
  Future<bool> requestSmsPermissions() {
    throw UnimplementedError('requestSmsPermissions() has not been implemented.');
  }

  /// Check if SMS permissions are granted
  Future<bool> hasSmsPermissions() {
    throw UnimplementedError('hasSmsPermissions() has not been implemented.');
  }
}

/// SMS Message model
class SmsMessage {
  final String id;
  final String address;
  final String body;
  final DateTime date;
  final SmsType type;

  SmsMessage({
    required this.id,
    required this.address,
    required this.body,
    required this.date,
    required this.type,
  });

  factory SmsMessage.fromMap(Map<String, dynamic> map) {
    return SmsMessage(
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      body: map['body'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      type: SmsType.values.firstWhere(
        (e) => e.index == map['type'],
        orElse: () => SmsType.inbox,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'body': body,
      'date': date.millisecondsSinceEpoch,
      'type': type.index,
    };
  }
}

/// SMS Message types
enum SmsType {
  inbox,
  sent,
  draft,
  outbox,
  failed,
  queued,
}
