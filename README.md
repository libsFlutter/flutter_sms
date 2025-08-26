# flutter_sms

A Flutter plugin for SMS functionality on Android platform. This plugin provides comprehensive SMS capabilities including sending messages, receiving delivery status updates, and managing incoming SMS messages.

## Features

### Core Functionality

1. **Send Outgoing SMS** - Send text messages to phone numbers
2. **SMS Delivery Status Events** - Receive real-time status updates for sent messages (delivered, failed, expired, etc.)
3. **Get Incoming SMS List** - Retrieve stored incoming SMS messages (useful when app was inactive)
4. **New Incoming SMS Events** - Listen for new incoming SMS messages in real-time

### Platform Support

- ✅ **Android** - Full implementation
- 🔄 **iOS** - Coming soon
- 🔄 **Web** - Coming soon
- 🔄 **Windows** - Coming soon
- 🔄 **macOS** - Coming soon
- 🔄 **Linux** - Coming soon

## Installation

Add `flutter_sms` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sms: ^0.0.1
```

## Usage

### Import the package

```dart
import 'package:flutter_sms/flutter_sms.dart';
```

### Send SMS

```dart
try {
  await FlutterSms.sendSms(
    phoneNumber: '+1234567890',
    message: 'Hello from Flutter!',
  );
} catch (e) {
  print('Failed to send SMS: $e');
}
```

### Listen to SMS Delivery Status

```dart
FlutterSms.onSmsDeliveryStatus.listen((status) {
  switch (status.status) {
    case SmsDeliveryStatus.delivered:
      print('SMS delivered successfully');
      break;
    case SmsDeliveryStatus.failed:
      print('SMS delivery failed: ${status.error}');
      break;
    case SmsDeliveryStatus.expired:
      print('SMS delivery expired');
      break;
  }
});
```

### Get Incoming SMS List

```dart
try {
  final List<SmsMessage> messages = await FlutterSms.getIncomingSms();
  for (final message in messages) {
    print('From: ${message.sender}');
    print('Message: ${message.body}');
    print('Date: ${message.date}');
  }
} catch (e) {
  print('Failed to get SMS messages: $e');
}
```

### Listen to New Incoming SMS

```dart
FlutterSms.onNewSmsReceived.listen((message) {
  print('New SMS from: ${message.sender}');
  print('Message: ${message.body}');
  print('Date: ${message.date}');
});
```

## Permissions

### Android

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
```

Request runtime permissions in your app:

```dart
// Request SMS permissions
await FlutterSms.requestPermissions();
```

## API Reference

### Classes

#### SmsMessage
```dart
class SmsMessage {
  final String sender;
  final String body;
  final DateTime date;
  final String? id;
}
```

#### SmsDeliveryStatus
```dart
class SmsDeliveryStatus {
  final String messageId;
  final SmsStatus status;
  final String? error;
}
```

#### SmsStatus
```dart
enum SmsStatus {
  sent,
  delivered,
  failed,
  expired,
  pending
}
```

### Methods

#### sendSms
```dart
Future<void> sendSms({
  required String phoneNumber,
  required String message,
}) async
```

#### getIncomingSms
```dart
Future<List<SmsMessage>> getIncomingSms() async
```

#### requestPermissions
```dart
Future<bool> requestPermissions() async
```

### Events

#### onSmsDeliveryStatus
```dart
Stream<SmsDeliveryStatus> get onSmsDeliveryStatus
```

#### onNewSmsReceived
```dart
Stream<SmsMessage> get onNewSmsReceived
```

## Example

See the `example/` directory for a complete working example.

## Getting Started

1. Add the plugin to your `pubspec.yaml`
2. Add required permissions to your Android manifest
3. Request runtime permissions in your app
4. Use the API methods and listen to events

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the NativeMindNONC License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] iOS implementation
- [ ] Web implementation  
- [ ] Windows implementation
- [ ] macOS implementation
- [ ] Linux implementation
- [ ] USSD support (future)
- [ ] MMS support (future)
