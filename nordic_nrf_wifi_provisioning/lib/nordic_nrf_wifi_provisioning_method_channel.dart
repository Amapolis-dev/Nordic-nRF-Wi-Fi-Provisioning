import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nordic_nrf_wifi_provisioning_platform_interface.dart';

/// An implementation of [NordicNrfWifiProvisioningPlatform] that uses method channels.
class MethodChannelNordicNrfWifiProvisioning extends NordicNrfWifiProvisioningPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nordic_nrf_wifi_provisioning');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
