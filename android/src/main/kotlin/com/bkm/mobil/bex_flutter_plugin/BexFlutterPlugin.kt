package com.bkm.mobil.bex_flutter_plugin

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BexFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    companion object {
        const val SET_DEBUG_MODE = "setDebugMode"
        const val SUBMIT_CONSUMER = "submitConsumer"
        const val RESUBMIT_CONSUMER = "resubmitConsumer"
        const val PAYMENT = "payment"
        const val OTP_PAYMENT = "otpPayment"
    }

    private lateinit var channel: MethodChannel
    private lateinit var callbackChannel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bex_flutter_plugin")
        callbackChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "bex_flutter_plugin/callback")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            SET_DEBUG_MODE -> {
                BexSdk.isDebugMode = call.argument<Boolean>("isDebugMode") ?: false
            }
            SUBMIT_CONSUMER -> {
                BexSdk.submitConsumer(activity, callbackChannel, call.argument<String>("token"))
            }
            RESUBMIT_CONSUMER -> {
                BexSdk.resubmitConsumer(activity, callbackChannel, call.argument<String>("ticket"))
            }
            PAYMENT -> {
                BexSdk.payment(activity, callbackChannel, call.argument<String>("token"))
            }
            OTP_PAYMENT -> {
                BexSdk.otpPayment(activity, callbackChannel, call.argument<String>("ticket"))
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
}
