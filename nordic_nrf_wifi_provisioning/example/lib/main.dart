import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nordic_nrf_wifi_provisioning/nordic_nrf_wifi_provisioning.dart';
import 'package:nordic_nrf_discovery/nordic_nrf_discovery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _nordicNrfWifiProvisioningPlugin = NordicNrfWifiProvisioning();

  String errorMessage = '';

  /// #############################
  /// # Nordic nRF Discovery Part #
  /// #############################
  final nordicNrfDiscoveryService = NordicNrfDiscoveryService();
  StreamSubscription<DiscoveredDevice>? _discoveredDevicesSubscription;
  final Map<String, DiscoveredDevice> discoveredDevices = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _nordicNrfWifiProvisioningPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nordic nRF Wifi Provisioning'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                /// Start scan button
                ElevatedButton(
                  onPressed: startScan,
                  child: const Text('Scan for devices'),
                ),
                const SizedBox(width: 20),

                /// Stop scan button
                ElevatedButton(
                  onPressed: stopScan,
                  child: const Text('Stop scanning'),
                ),
                const SizedBox(width: 20),

                /// Clear discovered devices button
                ElevatedButton(
                  onPressed: clear,
                  child: const Text('Clear/Reset'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Error message
            Text(errorMessage, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 10),

            /// Discovered devices list
            const Text('Discovered devices:', style: TextStyle(fontSize: 20)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                final discoveredDevice = discoveredDevices.values.elementAt(index);
                return ListTile(
                  title: Text(discoveredDevice.name),
                  subtitle: Text('${discoveredDevice.id} rssi: ${discoveredDevice.rssi}'),
                  onTap: () async {
                    print('Connecting to device ${discoveredDevice.name} with id ${discoveredDevice.id}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void startScan() async {
    try {
      final discoveredDevicesStream = await nordicNrfDiscoveryService.scanForDevices();
      _discoveredDevicesSubscription = discoveredDevicesStream.listen((discoveredDevice) {
        setState(() {
          discoveredDevices[discoveredDevice.id] = discoveredDevice;
        });
      });
    } on NordicNrfDiscoveryMissingPermissionException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unknown error: $e';
      });
    }
  }

  void stopScan() async {
    await _discoveredDevicesSubscription?.cancel();
  }

  void clear() async {
    await _discoveredDevicesSubscription?.cancel();
    setState(() {
      discoveredDevices.clear();
      errorMessage = '';
    });
  }
}
