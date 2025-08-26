import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms/flutter_sms_platform_interface.dart';
import 'package:flutter_sms/flutter_sms_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSmsPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSmsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterSmsPlatform initialPlatform = FlutterSmsPlatform.instance;

  test('$MethodChannelFlutterSms is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSms>());
  });

  test('getPlatformVersion', () async {
    FlutterSms flutterSmsPlugin = FlutterSms();
    MockFlutterSmsPlatform fakePlatform = MockFlutterSmsPlatform();
    FlutterSmsPlatform.instance = fakePlatform;

    expect(await flutterSmsPlugin.getPlatformVersion(), '42');
  });
}
