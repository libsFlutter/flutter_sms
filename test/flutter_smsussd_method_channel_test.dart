import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smsussd/flutter_smsussd_method_channel.dart';
import 'package:flutter_smsussd/flutter_smsussd_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MethodChannelFlutterSmsussd', () {
    late MethodChannelFlutterSmsussd plugin;
    late MethodChannel channel;

    setUp(() {
      plugin = MethodChannelFlutterSmsussd();
      channel = plugin.methodChannel;
    });

    test('getPlatformVersion returns a string', () async {
      const expected = '42';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => expected,
      );

      final result = await plugin.getPlatformVersion();
      expect(result, expected);
    });

    test('sendSms returns true on success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => true,
      );

      final result = await plugin.sendSms(
        phoneNumber: '+1234567890',
        message: 'Test message',
      );
      expect(result, true);
    });

    test('sendSms returns false on failure', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => false,
      );

      final result = await plugin.sendSms(
        phoneNumber: '+1234567890',
        message: 'Test message',
      );
      expect(result, false);
    });

    test('getSmsMessages returns list of messages', () async {
      final mockMessages = [
        {
          'id': '1',
          'address': '+1234567890',
          'body': 'Test message 1',
          'date': 1640995200000,
          'type': 0,
        },
        {
          'id': '2',
          'address': '+0987654321',
          'body': 'Test message 2',
          'date': 1640995260000,
          'type': 1,
        },
      ];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => mockMessages,
      );

      final result = await plugin.getSmsMessages();
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].address, '+1234567890');
      expect(result[0].body, 'Test message 1');
      expect(result[0].type, SmsType.inbox);
      expect(result[1].id, '2');
      expect(result[1].address, '+0987654321');
      expect(result[1].body, 'Test message 2');
      expect(result[1].type, SmsType.sent);
    });

    test('getSmsMessagesByPhoneNumber returns filtered messages', () async {
      final mockMessages = [
        {
          'id': '1',
          'address': '+1234567890',
          'body': 'Test message 1',
          'date': 1640995200000,
          'type': 0,
        },
      ];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => mockMessages,
      );

      final result = await plugin.getSmsMessagesByPhoneNumber('+1234567890');
      expect(result.length, 1);
      expect(result[0].address, '+1234567890');
    });

    test('requestSmsPermissions returns true on success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => true,
      );

      final result = await plugin.requestSmsPermissions();
      expect(result, true);
    });

    test('hasSmsPermissions returns true when granted', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => true,
      );

      final result = await plugin.hasSmsPermissions();
      expect(result, true);
    });

    test('hasSmsPermissions returns false when not granted', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async => false,
      );

      final result = await plugin.hasSmsPermissions();
      expect(result, false);
    });
  });
}
