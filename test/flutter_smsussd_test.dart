import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smsussd/flutter_smsussd.dart';
import 'package:flutter_smsussd/flutter_smsussd_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterSmsussd', () {
    test('SmsMessage.fromMap creates correct object', () {
      final map = {
        'id': '123',
        'address': '+1234567890',
        'body': 'Test message',
        'date': 1640995200000, // 2022-01-01 00:00:00 UTC
        'type': 1, // sent
      };

      final message = SmsMessage.fromMap(map);

      expect(message.id, '123');
      expect(message.address, '+1234567890');
      expect(message.body, 'Test message');
      expect(message.date.millisecondsSinceEpoch, 1640995200000);
      expect(message.type, SmsType.sent);
    });

    test('SmsMessage.toMap creates correct map', () {
      final message = SmsMessage(
        id: '123',
        address: '+1234567890',
        body: 'Test message',
        date: DateTime.fromMillisecondsSinceEpoch(1640995200000),
        type: SmsType.inbox,
      );

      final map = message.toMap();

      expect(map['id'], '123');
      expect(map['address'], '+1234567890');
      expect(map['body'], 'Test message');
      expect(map['date'], 1640995200000);
      expect(map['type'], 0); // inbox
    });

    test('SmsType enum values are correct', () {
      expect(SmsType.inbox.index, 0);
      expect(SmsType.sent.index, 1);
      expect(SmsType.draft.index, 2);
      expect(SmsType.outbox.index, 3);
      expect(SmsType.failed.index, 4);
      expect(SmsType.queued.index, 5);
    });
  });
}
