import 'package:permission_handler/permission_handler.dart';

/// A common exception for all errors that can occur in the nordic_nrf_discovery library.
sealed class NordicNrfDiscoveryException implements Exception {
  /// Creates a [NordicNrfDiscoveryException] with the specified error [message].
  NordicNrfDiscoveryException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'NordicNrfDiscoveryException: $message';
}

/// An exception thrown when the required permissions are not granted.
class NordicNrfDiscoveryMissingPermissionException extends NordicNrfDiscoveryException {
  /// Creates a [NordicNrfDiscoveryMissingPermissionException] with the specified error [message].
  NordicNrfDiscoveryMissingPermissionException(this.permission, [String? message])
      : super(message ?? 'Permission $permission is required to use this feature.');

  /// The required permission.
  final Permission permission;

  @override
  String toString() =>
      'NordicNrfDiscoveryMissingPermissionException: missing permission $permission, $message';
}
