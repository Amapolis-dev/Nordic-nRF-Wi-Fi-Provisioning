import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nordic_nrf_wifi_provisioning_method_channel.dart';

abstract class NordicNrfWifiProvisioningPlatform extends PlatformInterface {
  /// Constructs a NordicNrfWifiProvisioningPlatform.
  NordicNrfWifiProvisioningPlatform() : super(token: _token);

  static final Object _token = Object();

  static NordicNrfWifiProvisioningPlatform _instance = MethodChannelNordicNrfWifiProvisioning();

  /// The default instance of [NordicNrfWifiProvisioningPlatform] to use.
  ///
  /// Defaults to [MethodChannelNordicNrfWifiProvisioning].
  static NordicNrfWifiProvisioningPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NordicNrfWifiProvisioningPlatform] when
  /// they register themselves.
  static set instance(NordicNrfWifiProvisioningPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
