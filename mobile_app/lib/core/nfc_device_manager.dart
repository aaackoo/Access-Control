import 'dart:async';
import 'package:flutter/services.dart';

class NfcDeviceManager {
  static const MethodChannel _channel = MethodChannel('nfc_device_manager');

  static Future<bool> get isNfcSupported async {
    try {
      // debugPrint('Checking NFC support...');
      final bool result = await _channel.invokeMethod('isNfcSupported');
      // debugPrint('NFC supported: $result');
      return result;
    } catch (_) {
      // debugPrint('NFC check error: $_');
      return false;
    }
  }

  static Future<void> cancelRead() async {
    try {
      await _channel.invokeMethod('cancelRead');
    } catch (_) {}
  }

  static Future<NfcReadResult> readDeviceId({
    required String alertMessage,
    required String scanningCompletedMessage,
  }) async {
    try {
      // debugPrint('Starting NFC read...');
      final result = Map<String, dynamic>.from(
        await _channel.invokeMethod('readDeviceId', {
          'alertMessage': alertMessage,
          'scanningCompletedMessage': scanningCompletedMessage,
        }),
      );

      // debugPrint('NFC read result: $result');
      return NfcReadResult.fromMap(result);
    } on PlatformException catch (_) {
      // debugPrint('NFC read platform exception: ${e.code} - ${e.message}');
      return NfcReadResult(success: false, timestamp: DateTime.now());
    } catch (_) {
      // debugPrint('NFC read error: $_');
      return NfcReadResult(success: false, timestamp: DateTime.now());
    }
  }
}

class NfcReadResult {
  NfcReadResult({
    required this.success,
    this.deviceId,
    this.isProtected = false,
    required this.timestamp,
  });

  factory NfcReadResult.fromMap(Map<String, dynamic> map) {
    return NfcReadResult(
      success: map['success'] ?? false,
      deviceId: map['deviceId'],
      isProtected: map['isProtected'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (map['timestamp'] * 1000).round(),
      ),
    );
  }

  final bool success;
  final String? deviceId;
  final bool isProtected;
  final DateTime timestamp;

  @override
  String toString() {
    return 'NfcReadResult{success: $success, deviceId: $deviceId, isProtected: $isProtected}';
  }
}

// UNUSED — NfcException, NfcOperation, NfcStatus are not referenced anywhere.

// class NfcException implements Exception {
//   NfcException(this.code, this.message);
//   final String code;
//   final String message;
//
//   @override
//   String toString() => 'NfcException{code: $code, message: $message}';
// }

// enum NfcOperation { read }

// enum NfcStatus { idle, scanning, connected, reading, error }
