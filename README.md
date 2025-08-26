# flutter_smsussd

A Flutter plugin for sending and reading SMS messages on Android devices.

## Features

- Send SMS messages
- Read SMS messages from device
- Filter SMS messages by phone number
- Request SMS permissions
- Check SMS permission status
- Support for multipart SMS messages

## Getting Started

### Android Setup

Add the following permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.WRITE_SMS" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### Usage

1. **Check and Request Permissions**

```dart
import 'package:flutter_smsussd/flutter_smsussd.dart';

final plugin = FlutterSmsussd();

// Check if SMS permissions are granted
bool hasPermissions = await plugin.hasSmsPermissions();

// Request SMS permissions
bool granted = await plugin.requestSmsPermissions();
```

2. **Send SMS Message**

```dart
// Send a single SMS
// On Android: Sends SMS directly
// On iOS: Opens native SMS composer with pre-filled content
bool success = await plugin.sendSms(
  phoneNumber: '+1234567890',
  message: 'Hello from Flutter!',
);
```

3. **Read SMS Messages**

```dart
// Get all SMS messages
List<SmsMessage> messages = await plugin.getSmsMessages();

// Get SMS messages by phone number
List<SmsMessage> messages = await plugin.getSmsMessagesByPhoneNumber('+1234567890');
```

4. **SMS Message Model**

```dart
class SmsMessage {
  final String id;
  final String address;      // Phone number
  final String body;         // Message content
  final DateTime date;       // Message timestamp
  final SmsType type;        // Message type (inbox, sent, etc.)
}

enum SmsType {
  inbox,    // Received messages
  sent,     // Sent messages
  draft,    // Draft messages
  outbox,   // Outbox messages
  failed,   // Failed messages
  queued,   // Queued messages
}
```

## Platform-Specific Behavior

### Android
- ✅ Direct SMS sending
- ✅ SMS message reading
- ✅ Permission handling
- ✅ Multipart SMS support

### iOS
- ⚠️ Opens native SMS composer (user must manually send)
- ❌ Cannot read SMS messages
- ✅ No special permissions required
- ✅ Pre-fills recipient and message content

## Example

See the `example/` directory for a complete working example that demonstrates:

- Permission handling
- Sending SMS messages
- Reading SMS messages (Android only)
- Modern Material 3 UI
- Error handling
- Platform-specific behavior

## Platform Support

- ✅ Android (full SMS functionality)
- ⚠️ iOS (limited SMS functionality - can only open native SMS composer)
- ❌ Web (not supported)
- ❌ macOS (not supported)
- ❌ Windows (not supported)
- ❌ Linux (not supported)

### iOS Limitations

Due to Apple's strict security policies, iOS has the following limitations:

- ❌ **Cannot read SMS messages** - No API access to SMS database
- ❌ **Cannot send SMS programmatically** - No direct SMS sending API
- ✅ **Can open native SMS composer** - Opens Messages app with pre-filled content
- ✅ **No special permissions required** - Uses standard iOS MessageUI framework

## Permissions

The plugin requires the following Android permissions:

- `SEND_SMS`: To send SMS messages
- `READ_SMS`: To read SMS messages from the device
- `RECEIVE_SMS`: To receive SMS messages
- `WRITE_SMS`: To write SMS messages (for future features)
- `READ_PHONE_STATE`: For Android 6.0+ runtime permissions

## Error Handling

The plugin provides clear error messages for common scenarios:

- `PERMISSION_DENIED`: SMS permissions not granted
- `INVALID_ARGUMENTS`: Missing required parameters
- `SMS_SEND_ERROR`: Failed to send SMS
- `SMS_READ_ERROR`: Failed to read SMS messages
- `NO_ACTIVITY`: No activity available for permission request

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the NativeMindNONC License - see the [LICENSE](LICENSE) file for details.

