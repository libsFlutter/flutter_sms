
import 'flutter_sms_platform_interface.dart';

class FlutterSms {
  Future<String?> getPlatformVersion() {
    return FlutterSmsPlatform.instance.getPlatformVersion();
  }
}
