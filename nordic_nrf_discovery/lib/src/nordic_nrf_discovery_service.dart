import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:nordic_nrf_discovery/src/discovery_exceptions.dart';
import 'package:permission_handler/permission_handler.dart';

const defaultNordicWifiProvisioningService = "14387800-130c-49e7-b877-2881c89cb258";

class NordicNrfDiscoveryService {
  late final Uuid wifiProvisioningService;

  NordicNrfDiscoveryService({Uuid? wifiProvisioningServiceUuid}) {
    wifiProvisioningService = wifiProvisioningServiceUuid ?? Uuid.parse(defaultNordicWifiProvisioningService);
  }

  /// Will scan for devices that advertise the default nordic wifi provisioning service UUID
  /// (14387800-130c-49e7-b877-2881c89cb258).
  /// It will also request required permissions if they are not granted.
  /// This method may throw a [NordicNrfDiscoveryMissingPermissionException] if the required permissions are not granted.
  Future<Stream<DiscoveredDevice>> scanForDevices() async {
    /// Request location permission if not granted.
    if (!await Permission.location.request().isGranted) {
      throw NordicNrfDiscoveryMissingPermissionException(Permission.location,
          "Location permission was not granted. Please make sure that the user has granted the location permission and that the required permissions are set in your AndroidManifest.xml file or Info.plist file.");
    }

    /// Request Bluetooth scanning permission if not granted.
    if (!await Permission.bluetoothScan.request().isGranted) {
      throw NordicNrfDiscoveryMissingPermissionException(Permission.bluetoothScan,
          "Bluetooth scanning permission was not granted. Please make sure that the user has granted the bluetooth scanning permission and that the required permissions are set in your AndroidManifest.xml file or Info.plist file.");
    }

    /// Request Bluetooth connection permission if not granted.
    if (!await Permission.bluetoothConnect.request().isGranted) {
      throw NordicNrfDiscoveryMissingPermissionException(Permission.bluetoothConnect,
          "Bluetooth connection permission was not granted. Please make sure that the user has granted the bluetooth connection permission and that the required permissions are set in your AndroidManifest.xml file or Info.plist file.");
    }

    return scanForDevicesWithoutPermissionRequests();
  }

  /// Same as [scanForDevices] but does not request permissions. With this method you are responsible for requesting the required permissions.

  Stream<DiscoveredDevice> scanForDevicesWithoutPermissionRequests() {
    final flutterReactiveBle = FlutterReactiveBle();
    return flutterReactiveBle.scanForDevices(
      withServices: [wifiProvisioningService],
    );
  }
}
