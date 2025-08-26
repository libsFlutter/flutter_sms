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
}
