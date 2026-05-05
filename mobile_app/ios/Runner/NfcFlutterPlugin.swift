import Flutter
import UIKit
import CoreNFC

public class NfcFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nfc_device_manager", binaryMessenger: registrar.messenger())
        let instance = NfcFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private var nfcSession: NFCNDEFReaderSession?
    private var result: FlutterResult?
    private var scanningCompletedMessage: String = "Done"
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        switch call.method {
        case "isNfcSupported":
            let isSupported = NFCNDEFReaderSession.readingAvailable
            print("NFC readingAvailable: \(isSupported)")
            result(isSupported)
            
        case "readDeviceId":
            let args = call.arguments as? [String: Any]
            let alertMessage = args?["alertMessage"] as? String
            scanningCompletedMessage = args?["scanningCompletedMessage"] as? String ?? "Done"
            readDeviceId(alertMessage: alertMessage)

        case "cancelRead":
            nfcSession?.invalidate()
            nfcSession = nil
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func readDeviceId(alertMessage: String?) {
        print("Checking NFC availability...")
        print("NFCNDEFReaderSession.readingAvailable: \(NFCNDEFReaderSession.readingAvailable)")

        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available on this device")
            result?(FlutterError(code: "NFC_NOT_AVAILABLE", message: "NFC is not available on this device", details: nil))
            return
        }

        print("Starting NFC session...")
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = alertMessage ?? "Priložte iPhone k zariadeniu"
        nfcSession?.begin()
    }
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NfcFlutterPlugin: NFCNDEFReaderSessionDelegate {

    private func consumeResult() -> FlutterResult? {
        let pending = result
        result = nil
        return pending
    }

    private func parseDeviceId(from payload: Data) -> String? {
        guard payload.count > 1 else { return nil }
        let languageCodeLength = Int(payload[0] & 0x3F)
        let textStart = 1 + languageCodeLength
        guard payload.count > textStart else { return nil }
        return String(data: payload.subdata(in: textStart..<payload.count), encoding: .utf8)
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            guard let pending = self.consumeResult() else { return }
            if let nfcError = error as? NFCReaderError {
                switch nfcError.code {
                case .readerSessionInvalidationErrorUserCanceled:
                    pending(FlutterError(code: "USER_CANCELED", message: "User canceled NFC operation", details: nil))
                case .readerSessionInvalidationErrorSessionTimeout:
                    pending(FlutterError(code: "TIMEOUT", message: "NFC session timeout", details: nil))
                default:
                    pending(FlutterError(code: "NFC_ERROR", message: error.localizedDescription, details: nil))
                }
            } else {
                pending(FlutterError(code: "NFC_ERROR", message: error.localizedDescription, details: nil))
            }
        }
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            guard let pending = self.consumeResult() else { return }
            if let record = messages.first?.records.first,
               let deviceId = self.parseDeviceId(from: record.payload) {
                pending(["success": true, "deviceId": deviceId, "timestamp": Date().timeIntervalSince1970])
            } else {
                pending(FlutterError(code: "READ_ERROR", message: "Failed to read Device ID from NFC tag", details: nil))
            }
            session.invalidate()
        }
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "No NFC tag detected")
            return
        }

        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: "Connection failed: \(error.localizedDescription)")
                return
            }

            tag.readNDEF { message, error in
                DispatchQueue.main.async {
                    guard let pending = self.consumeResult() else { return }
                    if let error = error {
                        session.invalidate(errorMessage: "Read failed: \(error.localizedDescription)")
                        pending(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
                        return
                    }
                    if let record = message?.records.first,
                       let deviceId = self.parseDeviceId(from: record.payload) {
                        session.alertMessage = self.scanningCompletedMessage
                        session.invalidate()
                        pending(["success": true, "deviceId": deviceId, "timestamp": Date().timeIntervalSince1970])
                    } else {
                        session.invalidate(errorMessage: "Nepodarilo sa prečítať zariadenie")
                        pending(FlutterError(code: "READ_ERROR", message: "Failed to read Device ID from NFC tag", details: nil))
                    }
                }
            }
        }
    }
}

// MARK: - Helper Extensions
extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
