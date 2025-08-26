package net.nativemind.libs.flutter.smsussd.flutter_smsussd

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.provider.Telephony
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/** FlutterSmsussdPlugin */
class FlutterSmsussdPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var activity: Activity? = null

  companion object {
    private const val SMS_PERMISSION_REQUEST_CODE = 123
    private val REQUIRED_PERMISSIONS = arrayOf(
      Manifest.permission.SEND_SMS,
      Manifest.permission.READ_SMS,
      Manifest.permission.RECEIVE_SMS
    )
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_smsussd")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "sendSms" -> {
        val phoneNumber = call.argument<String>("phoneNumber")
        val message = call.argument<String>("message")
        
        if (phoneNumber == null || message == null) {
          result.error("INVALID_ARGUMENTS", "Phone number and message are required", null)
          return
        }
        
        sendSms(phoneNumber, message, result)
      }
      "getSmsMessages" -> {
        getSmsMessages(result)
      }
      "getSmsMessagesByPhoneNumber" -> {
        val phoneNumber = call.argument<String>("phoneNumber")
        if (phoneNumber == null) {
          result.error("INVALID_ARGUMENTS", "Phone number is required", null)
          return
        }
        getSmsMessagesByPhoneNumber(phoneNumber, result)
      }
      "requestSmsPermissions" -> {
        requestSmsPermissions(result)
      }
      "hasSmsPermissions" -> {
        result.success(hasSmsPermissions())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun sendSms(phoneNumber: String, message: String, result: Result) {
    if (!hasSmsPermissions()) {
      result.error("PERMISSION_DENIED", "SMS permissions not granted", null)
      return
    }

    try {
      val smsManager = SmsManager.getDefault()
      val parts = smsManager.divideMessage(message)
      
      if (parts.size > 1) {
        // Send multipart SMS
        val sentIntents = ArrayList<android.content.Intent>()
        val deliveredIntents = ArrayList<android.content.Intent>()
        
        for (i in parts.indices) {
          val sentIntent = android.content.Intent("SMS_SENT")
          val deliveredIntent = android.content.Intent("SMS_DELIVERED")
          
          sentIntents.add(sentIntent)
          deliveredIntents.add(deliveredIntent)
        }
        
        smsManager.sendMultipartTextMessage(
          phoneNumber,
          null,
          parts,
          sentIntents,
          deliveredIntents
        )
      } else {
        // Send single SMS
        smsManager.sendTextMessage(
          phoneNumber,
          null,
          message,
          null,
          null
        )
      }
      
      result.success(true)
    } catch (e: Exception) {
      result.error("SMS_SEND_ERROR", "Failed to send SMS: ${e.message}", null)
    }
  }

  private fun getSmsMessages(result: Result) {
    if (!hasSmsPermissions()) {
      result.error("PERMISSION_DENIED", "SMS permissions not granted", null)
      return
    }

    try {
      val messages = mutableListOf<Map<String, Any>>()
      val contentResolver: ContentResolver = context.contentResolver
      val cursor: Cursor? = contentResolver.query(
        Telephony.Sms.CONTENT_URI,
        null,
        null,
        null,
        "${Telephony.Sms.DATE} DESC"
      )

      cursor?.use { c ->
        val idIndex = c.getColumnIndex(Telephony.Sms._ID)
        val addressIndex = c.getColumnIndex(Telephony.Sms.ADDRESS)
        val bodyIndex = c.getColumnIndex(Telephony.Sms.BODY)
        val dateIndex = c.getColumnIndex(Telephony.Sms.DATE)
        val typeIndex = c.getColumnIndex(Telephony.Sms.TYPE)

        while (c.moveToNext()) {
          val message = mapOf(
            "id" to c.getString(idIndex),
            "address" to (c.getString(addressIndex) ?: ""),
            "body" to (c.getString(bodyIndex) ?: ""),
            "date" to c.getLong(dateIndex),
            "type" to c.getInt(typeIndex)
          )
          messages.add(message)
        }
      }

      result.success(messages)
    } catch (e: Exception) {
      result.error("SMS_READ_ERROR", "Failed to read SMS messages: ${e.message}", null)
    }
  }

  private fun getSmsMessagesByPhoneNumber(phoneNumber: String, result: Result) {
    if (!hasSmsPermissions()) {
      result.error("PERMISSION_DENIED", "SMS permissions not granted", null)
      return
    }

    try {
      val messages = mutableListOf<Map<String, Any>>()
      val contentResolver: ContentResolver = context.contentResolver
      val cursor: Cursor? = contentResolver.query(
        Telephony.Sms.CONTENT_URI,
        null,
        "${Telephony.Sms.ADDRESS} = ?",
        arrayOf(phoneNumber),
        "${Telephony.Sms.DATE} DESC"
      )

      cursor?.use { c ->
        val idIndex = c.getColumnIndex(Telephony.Sms._ID)
        val addressIndex = c.getColumnIndex(Telephony.Sms.ADDRESS)
        val bodyIndex = c.getColumnIndex(Telephony.Sms.BODY)
        val dateIndex = c.getColumnIndex(Telephony.Sms.DATE)
        val typeIndex = c.getColumnIndex(Telephony.Sms.TYPE)

        while (c.moveToNext()) {
          val message = mapOf(
            "id" to c.getString(idIndex),
            "address" to (c.getString(addressIndex) ?: ""),
            "body" to (c.getString(bodyIndex) ?: ""),
            "date" to c.getLong(dateIndex),
            "type" to c.getInt(typeIndex)
          )
          messages.add(message)
        }
      }

      result.success(messages)
    } catch (e: Exception) {
      result.error("SMS_READ_ERROR", "Failed to read SMS messages: ${e.message}", null)
    }
  }

  private fun requestSmsPermissions(result: Result) {
    if (hasSmsPermissions()) {
      result.success(true)
      return
    }

    activity?.let { act ->
      ActivityCompat.requestPermissions(
        act,
        REQUIRED_PERMISSIONS,
        SMS_PERMISSION_REQUEST_CODE
      )
      result.success(true)
    } ?: run {
      result.error("NO_ACTIVITY", "No activity available for permission request", null)
    }
  }

  private fun hasSmsPermissions(): Boolean {
    return REQUIRED_PERMISSIONS.all { permission ->
      ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
