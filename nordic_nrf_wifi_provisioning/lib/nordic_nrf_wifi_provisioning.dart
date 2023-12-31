
import 'nordic_nrf_wifi_provisioning_platform_interface.dart';

class NordicNrfWifiProvisioning {
  Future<String?> getPlatformVersion() {
    return NordicNrfWifiProvisioningPlatform.instance.getPlatformVersion();
  }
}
