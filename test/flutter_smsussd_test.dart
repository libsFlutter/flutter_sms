import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smsussd/flutter_smsussd.dart';
import 'package:flutter_smsussd/flutter_smsussd_platform_interface.dart';
import 'package:flutter_smsussd/flutter_smsussd_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSmsussdPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSmsussdPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterSmsussdPlatform initialPlatform = FlutterSmsussdPlatform.instance;

  test('$MethodChannelFlutterSmsussd is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSmsussd>());
  });

  test('getPlatformVersion', () async {
    FlutterSmsussd flutterSmsussdPlugin = FlutterSmsussd();
    MockFlutterSmsussdPlatform fakePlatform = MockFlutterSmsussdPlatform();
    FlutterSmsussdPlatform.instance = fakePlatform;

    expect(await flutterSmsussdPlugin.getPlatformVersion(), '42');
  });
}
