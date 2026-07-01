package cz.supejAdam.hotelAccessApp

import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NfcManager
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "nfc_device_manager"
    private var methodChannel: MethodChannel? = null
    private var pendingResult: MethodChannel.Result? = null
    private var nfcAdapter: NfcAdapter? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val manager = getSystemService(NFC_SERVICE) as? NfcManager
        nfcAdapter = manager?.defaultAdapter

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isNfcSupported" -> result.success(nfcAdapter != null && nfcAdapter!!.isEnabled)
                "readDeviceId" -> startNfcScan(result)
                "cancelRead" -> cancelNfcScan(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun cancelNfcScan(result: MethodChannel.Result) {
        nfcAdapter?.disableForegroundDispatch(this)
        pendingResult?.error("USER_CANCELED", "User canceled NFC operation", null)
        pendingResult = null
        result.success(null)
    }

    private fun startNfcScan(result: MethodChannel.Result) {
        val adapter = nfcAdapter
        if (adapter == null || !adapter.isEnabled) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available on this device", null)
            return
        }
        pendingResult = result
        enableForegroundDispatch(adapter)
    }

    private fun enableForegroundDispatch(adapter: NfcAdapter) {
        val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        else
            PendingIntent.FLAG_UPDATE_CURRENT
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, flags)
        adapter.enableForegroundDispatch(this, pendingIntent, null, null)
    }

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }

    override fun onResume() {
        super.onResume()
        if (pendingResult != null) {
            nfcAdapter?.let { enableForegroundDispatch(it) }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action != NfcAdapter.ACTION_NDEF_DISCOVERED &&
            intent.action != NfcAdapter.ACTION_TAG_DISCOVERED
        ) return

        val result = pendingResult ?: return
        pendingResult = null
        try {
            nfcAdapter?.disableForegroundDispatch(this)
        } catch (_: IllegalStateException) {}

        val tag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
        else
            @Suppress("DEPRECATION") intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)

        if (tag == null) {
            result.error("READ_ERROR", "Failed to read NFC tag", null)
            return
        }

        val ndef = Ndef.get(tag)
        if (ndef == null) {
            result.error("READ_ERROR", "Tag does not contain NDEF data", null)
            return
        }

        try {
            ndef.connect()
            val message = ndef.ndefMessage
            ndef.close()

            val record = message?.records?.firstOrNull()
            if (record == null) {
                result.error("READ_ERROR", "Failed to read Device ID from NFC tag", null)
                return
            }

            // Text NDEF record payload: 1 byte status + language code + text
            // Status byte encodes language code length in lower 6 bits
            val payload = record.payload
            val languageCodeLength = payload[0].toInt() and 0x3F
            val deviceId = String(payload, 1 + languageCodeLength, payload.size - 1 - languageCodeLength, Charsets.UTF_8)

            result.success(
                mapOf(
                    "success" to true,
                    "deviceId" to deviceId,
                    "isProtected" to false,
                    "timestamp" to System.currentTimeMillis() / 1000.0,
                )
            )
        } catch (e: Exception) {
            result.error("READ_ERROR", "Failed to read NFC tag: ${e.message}", null)
        }
    }
}
