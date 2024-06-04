package com.bkm.mobil.bex_flutter_plugin

import android.app.Activity
import com.bkm.bexandroidsdk.core.BEXOtpPaymentListener
import com.bkm.bexandroidsdk.core.BEXPaymentListener
import com.bkm.bexandroidsdk.core.BEXStarter
import com.bkm.bexandroidsdk.core.BEXSubmitConsumerListener
import com.bkm.bexandroidsdk.en.Environment
import com.bkm.bexandroidsdk.n.bexdomain.PosResult
import io.flutter.plugin.common.MethodChannel

/**
 * Created by ebayhan on 2019-11-23.
 */
object BexSdk {

    const val ON_PAIRING_SUCCESS = "onPairingSuccess"
    const val ON_PAIRING_FAILURE = "onPairingFailure"
    const val ON_PAIRING_CANCELLED = "onPairingCancelled"

    const val ON_PAYMENT_SUCCESS = "onPaymentSuccess"
    const val ON_PAYMENT_FAILURE = "onPaymentFailure"
    const val ON_PAYMENT_CANCELLED = "onPaymentCancelled"

    const val ON_OTP_PAYMENT_SUCCESS = "onOtpPaymentSuccess"
    const val ON_OTP_PAYMENT_FAILURE = "onOtpPaymentFailure"
    const val ON_OTP_PAYMENT_CANCELLED = "onOtpPaymentCancelled"

    var isDebugMode: Boolean = false

    fun submitConsumer(activity: Activity?, callbackChannel: MethodChannel?, token: String?) {
        if (token != null) {
            BEXStarter.startSDKForSubmitConsumer(activity, getEnvironment(), token, object : BEXSubmitConsumerListener {
                override fun onSuccess(p0: String?, p1: String?) {
                    sendMessage(callbackChannel, ON_PAIRING_SUCCESS, hashMapOf("first6" to p0, "last2" to p1))
                }

                override fun onFailure(p0: Int, p1: String?) {
                    sendMessage(callbackChannel, ON_PAIRING_FAILURE, hashMapOf("errorId" to p0, "errorMsg" to p1))
                }

                override fun onCancelled() {
                    sendMessage(callbackChannel, ON_PAIRING_CANCELLED)
                }
            })
        }
    }

    fun resubmitConsumer(activity: Activity?, callbackChannel: MethodChannel?, ticket: String?) {
        if (ticket != null) {
            BEXStarter.startSDKForReSubmitConsumer(activity, getEnvironment(), ticket, object : BEXSubmitConsumerListener {
                override fun onSuccess(p0: String?, p1: String?) {
                    sendMessage(callbackChannel, ON_PAIRING_SUCCESS, hashMapOf("first6" to p0, "last2" to p1))
                }

                override fun onFailure(p0: Int, p1: String?) {
                    sendMessage(callbackChannel, ON_PAIRING_FAILURE, hashMapOf("errorId" to p0, "errorMsg" to p1))
                }

                override fun onCancelled() {
                    sendMessage(callbackChannel, ON_PAIRING_CANCELLED)
                }
            })
        }
    }

    fun payment(activity: Activity?, callbackChannel: MethodChannel?, token: String?) {
        if (token != null) {
            BEXStarter.startSDKForPayment(activity, getEnvironment(), token, object : BEXPaymentListener {
                override fun onSuccess(p0: PosResult) {
                    sendMessage(callbackChannel, ON_PAYMENT_SUCCESS, getPosResultMap(p0))
                }

                override fun onFailure(p0: Int, p1: String?) {
                    sendMessage(callbackChannel, ON_PAYMENT_FAILURE, hashMapOf("errorId" to p0, "errorMsg" to p1))
                }

                override fun onCancelled() {
                    sendMessage(callbackChannel, ON_PAYMENT_CANCELLED)
                }
            })
        }
    }

    fun otpPayment(activity: Activity?, callbackChannel: MethodChannel?, token: String?) {
        if (token != null) {
            BEXStarter.startSDKForOtpPayment(activity, getEnvironment(), token, object : BEXOtpPaymentListener {
                override fun onSuccess() {
                    sendMessage(callbackChannel, ON_OTP_PAYMENT_SUCCESS)
                }

                override fun onFailure(p0: Int, p1: String?) {
                    sendMessage(callbackChannel, ON_OTP_PAYMENT_FAILURE, hashMapOf("errorId" to p0, "errorMsg" to p1))
                }

                override fun onCancelled() {
                    sendMessage(callbackChannel, ON_OTP_PAYMENT_CANCELLED)
                }
            })
        }
    }

    private fun sendMessage(callbackChannel: MethodChannel?, method: String, params: HashMap<String, Any?> = hashMapOf()) {
        callbackChannel?.invokeMethod(method, params)
    }

    private fun getPosResultMap(posResult: PosResult): HashMap<String, Any?> {
        return hashMapOf(
            "posMessage" to posResult.posMessage,
            "md" to posResult.md,
            "signature" to posResult.signature,
            "timestamp" to posResult.timestamp,
            "token" to posResult.token,
            "xid" to posResult.xid
        )
    }

    private fun getEnvironment(): Environment {
        return if (isDebugMode) {
            Environment.PREPROD
        } else {
            Environment.PROD
        }
    }
}