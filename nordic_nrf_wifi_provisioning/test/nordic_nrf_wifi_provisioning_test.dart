import 'package:flutter_test/flutter_test.dart';
import 'package:nordic_nrf_wifi_provisioning/nordic_nrf_wifi_provisioning.dart';
import 'package:nordic_nrf_wifi_provisioning/nordic_nrf_wifi_provisioning_platform_interface.dart';
import 'package:nordic_nrf_wifi_provisioning/nordic_nrf_wifi_provisioning_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNordicNrfWifiProvisioningPlatform
    with MockPlatformInterfaceMixin
    implements NordicNrfWifiProvisioningPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NordicNrfWifiProvisioningPlatform initialPlatform = NordicNrfWifiProvisioningPlatform.instance;

  test('$MethodChannelNordicNrfWifiProvisioning is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNordicNrfWifiProvisioning>());
  });

  test('getPlatformVersion', () async {
    NordicNrfWifiProvisioning nordicNrfWifiProvisioningPlugin = NordicNrfWifiProvisioning();
    MockNordicNrfWifiProvisioningPlatform fakePlatform = MockNordicNrfWifiProvisioningPlatform();
    NordicNrfWifiProvisioningPlatform.instance = fakePlatform;

    expect(await nordicNrfWifiProvisioningPlugin.getPlatformVersion(), '42');
  });
}
