
import 'flutter_smsussd_platform_interface.dart';

class FlutterSmsussd {
  Future<String?> getPlatformVersion() {
    return FlutterSmsussdPlatform.instance.getPlatformVersion();
  }
}
