# iOS Implementation for flutter_smsussd

## Overview

This document describes the iOS implementation of the `flutter_smsussd` plugin and its limitations.

## iOS Limitations

Due to Apple's strict security policies and privacy restrictions, iOS has significant limitations compared to Android:

### ❌ What's NOT Possible on iOS

1. **Reading SMS Messages**
   - No API access to SMS database
   - Cannot retrieve existing SMS messages
   - Cannot access SMS history

2. **Direct SMS Sending**
   - Cannot send SMS programmatically
   - No background SMS sending
   - Cannot send SMS without user interaction

3. **SMS Permissions**
   - No special SMS permissions required
   - Cannot request SMS-specific permissions

### ✅ What's Possible on iOS

1. **Opening SMS Composer**
   - Can open native Messages app
   - Pre-fills recipient and message content
   - User must manually send the message

2. **SMS Availability Check**
   - Can check if device supports SMS
   - Can verify SMS functionality

## Implementation Details

### Framework Used
- **MessageUI Framework**: Used for SMS composer functionality
- **MFMessageComposeViewController**: Native iOS SMS composer
- **MFMessageComposeViewControllerDelegate**: Handles composer callbacks

### Code Structure

```swift
import MessageUI

class FlutterSmsussdPlugin: NSObject, FlutterPlugin, MFMessageComposeViewControllerDelegate {
    // Plugin registration and method handling
    // SMS composer implementation
    // Delegate methods for composer callbacks
}
```

### Method Implementations

#### sendSms
- Checks if SMS is available using `MFMessageComposeViewController.canSendText()`
- Creates and presents `MFMessageComposeViewController`
- Pre-fills recipient and message content
- Returns success/failure based on user action

#### getSmsMessages / getSmsMessagesByPhoneNumber
- Returns `NOT_SUPPORTED` error
- Throws clear error message explaining iOS limitations

#### requestSmsPermissions / hasSmsPermissions
- Always returns `true` (no special permissions required)
- iOS handles SMS permissions automatically

## Usage Example

```dart
final plugin = FlutterSmsussd();

// This will open the native SMS composer on iOS
bool success = await plugin.sendSms(
  phoneNumber: '+1234567890',
  message: 'Hello from Flutter!',
);

// This will throw UnsupportedError on iOS
try {
  List<SmsMessage> messages = await plugin.getSmsMessages();
} catch (e) {
  print('SMS reading not supported on iOS: $e');
}
```

## Error Handling

The iOS implementation provides clear error messages:

- `NOT_SUPPORTED`: For SMS reading operations
- `SMS_NOT_AVAILABLE`: When device doesn't support SMS
- `NO_VIEW_CONTROLLER`: When no view controller is available
- `SMS_SEND_ERROR`: When SMS composer fails

## Testing

To test the iOS implementation:

1. Run on a physical iOS device (SMS doesn't work in simulator)
2. Ensure device has cellular capability
3. Test SMS composer opening and closing
4. Verify error handling for unsupported operations

## Future Considerations

Apple's policies are unlikely to change regarding SMS access. The current implementation provides the maximum possible functionality within iOS constraints.

For applications requiring full SMS functionality, consider:
- Android-only deployment
- Web-based SMS services
- Alternative communication methods (push notifications, email, etc.)
