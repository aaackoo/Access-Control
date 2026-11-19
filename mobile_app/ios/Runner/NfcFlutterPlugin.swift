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
        switch call.method {
        case "isNfcSupported":
            let isSupported = NFCNDEFReaderSession.readingAvailable
            print("NFC readingAvailable: \(isSupported)")
            result(isSupported)

        case "readDeviceId":
            let args = call.arguments as? [String: Any]
            let alertMessage = args?["alertMessage"] as? String
            scanningCompletedMessage = args?["scanningCompletedMessage"] as? String ?? "Done"
            readDeviceId(alertMessage: alertMessage, newResult: result)

        case "cancelRead":
            nfcSession?.invalidate()
            nfcSession = nil
            self.result = nil
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func readDeviceId(alertMessage: String?, newResult: @escaping FlutterResult) {
        print("Checking NFC availability...")
        print("NFCNDEFReaderSession.readingAvailable: \(NFCNDEFReaderSession.readingAvailable)")

        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available on this device")
            newResult(FlutterError(code: "NFC_NOT_AVAILABLE", message: "NFC is not available on this device", details: nil))
            return
        }

        // Teardown any existing session before starting fresh. self.result here is still the OLD
        // result — newResult has not been assigned yet, so the error goes to the right caller.
        if nfcSession != nil {
            print("[NFC] Previous session still active — tearing it down before starting new session")
            self.result?(FlutterError(code: "SESSION_REPLACED", message: "NFC session replaced by new scan", details: nil))
            self.result = nil
            nfcSession?.invalidate()
            nfcSession = nil
        }

        // Assign the new result only after teardown is complete
        self.result = newResult

        print("Starting NFC session...")
        // invalidateAfterFirstRead: false — these tags always go through didDetect tags (manual path),
        // so we need the session alive to retry on transient RF errors (error code 102)
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
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
        print("[NFC] didInvalidateWithError called")
        if let nfcError = error as? NFCReaderError {
            print("[NFC]   NFCReaderError code: \(nfcError.code.rawValue) — \(nfcError.localizedDescription)")
        } else {
            print("[NFC]   Non-NFCReaderError: \(error)")
        }
        nfcSession = nil
        DispatchQueue.main.async {
            guard let pending = self.consumeResult() else {
                print("[NFC]   didInvalidateWithError: no pending result to consume (already handled)")
                return
            }
            if let nfcError = error as? NFCReaderError {
                switch nfcError.code {
                case .readerSessionInvalidationErrorUserCanceled:
                    pending(FlutterError(code: "USER_CANCELED", message: "User canceled NFC operation", details: nil))
                case .readerSessionInvalidationErrorSessionTimeout:
                    pending(FlutterError(code: "TIMEOUT", message: "NFC session timeout", details: nil))
                default:
                    print("[NFC]   Unhandled NFCReaderError code: \(nfcError.code.rawValue)")
                    pending(FlutterError(code: "NFC_ERROR", message: error.localizedDescription, details: nil))
                }
            } else {
                pending(FlutterError(code: "NFC_ERROR", message: error.localizedDescription, details: nil))
            }
        }
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("[NFC] didDetectNDEFs called — auto-read path (happy path)")
        DispatchQueue.main.async {
            guard let pending = self.consumeResult() else {
                print("[NFC]   didDetectNDEFs: no pending result to consume")
                return
            }
            if let record = messages.first?.records.first,
               let deviceId = self.parseDeviceId(from: record.payload) {
                print("[NFC]   didDetectNDEFs: parsed deviceId = \(deviceId)")
                pending(["success": true, "deviceId": deviceId, "timestamp": Date().timeIntervalSince1970])
            } else {
                print("[NFC]   didDetectNDEFs: failed to parse deviceId from payload")
                pending(FlutterError(code: "READ_ERROR", message: "Failed to read Device ID from NFC tag", details: nil))
            }
            // NOTE: session auto-invalidates because invalidateAfterFirstRead=true; this call is redundant
            session.invalidate()
        }
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("[NFC] didDetect tags called — manual read path")
        guard let tag = tags.first else {
            print("[NFC]   didDetect tags: no tags in array")
            session.invalidate(errorMessage: "No NFC tag detected")
            return
        }

        session.connect(to: tag) { error in
            if let error = error {
                print("[NFC]   connect failed: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Connection failed: \(error.localizedDescription)")
                return
            }
            print("[NFC]   connect succeeded, calling readNDEF...")
            self.readNDEF(from: tag, session: session, attempt: 1)
        }
    }

    private func readNDEF(from tag: NFCNDEFTag, session: NFCNDEFReaderSession, attempt: Int) {
        tag.readNDEF { message, error in
            if let error = error {
                print("[NFC]   readNDEF attempt \(attempt) FAILED: \(error.localizedDescription)")
                if let nfcError = error as? NFCReaderError {
                    print("[NFC]   readNDEF NFCReaderError code: \(nfcError.code.rawValue)")
                    // Code 102 = NFCReaderTransceiveErrorTagResponseError — transient RF drop, retry once
                    if nfcError.code == .readerTransceiveErrorTagResponseError && attempt == 1 {
                        print("[NFC]   Retrying readNDEF (attempt 2)...")
                        self.readNDEF(from: tag, session: session, attempt: 2)
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                guard let pending = self.consumeResult() else {
                    print("[NFC]   readNDEF callback: no pending result to consume — invalidating orphaned session")
                    session.invalidate()
                    return
                }
                if let error = error {
                    session.invalidate(errorMessage: "Read failed: \(error.localizedDescription)")
                    pending(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
                    return
                }
                if let record = message?.records.first,
                   let deviceId = self.parseDeviceId(from: record.payload) {
                    print("[NFC]   readNDEF succeeded on attempt \(attempt), deviceId = \(deviceId)")
                    session.alertMessage = self.scanningCompletedMessage
                    session.invalidate()
                    pending(["success": true, "deviceId": deviceId, "timestamp": Date().timeIntervalSince1970])
                } else {
                    print("[NFC]   readNDEF: message had no parseable deviceId")
                    session.invalidate(errorMessage: "Nepodarilo sa prečítať zariadenie")
                    pending(FlutterError(code: "READ_ERROR", message: "Failed to read Device ID from NFC tag", details: nil))
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
