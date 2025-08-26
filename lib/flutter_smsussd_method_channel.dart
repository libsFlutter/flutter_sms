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
}
