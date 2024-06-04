import 'dart:async';

import 'package:bex_flutter_plugin/BexListener.dart';
import 'package:bex_flutter_plugin/BexPosResult.dart';
import 'package:flutter/services.dart';

class BexSdk {
  static const _SUBMIT_CONSUMER = "submitConsumer";
  static const _RESUBMIT_CONSUMER = "resubmitConsumer";
  static const _PAYMENT = "payment";
  static const _OTP_PAYMENT = "otpPayment";
  static const _SET_DEBUG_MODE = "setDebugMode";

  static const _ON_PAIRING_SUCCESS = "onPairingSuccess";
  static const _ON_PAIRING_FAILURE = "onPairingFailure";
  static const _ON_PAIRING_CANCELLED = "onPairingCancelled";

  static const _ON_PAYMENT_SUCCESS = "onPaymentSuccess";
  static const _ON_PAYMENT_FAILURE = "onPaymentFailure";
  static const _ON_PAYMENT_CANCELLED = "onPaymentCancelled";

  static const _ON_OTP_PAYMENT_SUCCESS = "onOtpPaymentSuccess";
  static const _ON_OTP_PAYMENT_FAILURE = "onOtpPaymentFailure";
  static const _ON_OTP_PAYMENT_CANCELLED = "onOtpPaymentCancelled";

  static const _SDK_NOT_INITIALIZED = "BexSdk not initialized. Please call \"BexSdk.init()\" first.";

  static MethodChannel _channel = const MethodChannel('bex_flutter_plugin');
  static BexPairingListener? _pairingListener;
  static BexPaymentListener? _paymentListener;
  static BexOtpPaymentListener? _otpPaymentListener;

  static bool isSdkInitialized = false;

  static void init({bool isDebugEnabled = false}) {
    isSdkInitialized = true;
    final methodChannel = MethodChannel('bex_flutter_plugin/callback');
    methodChannel.setMethodCallHandler(BexSdk._methodHandler);
    _channel.invokeMethod(_SET_DEBUG_MODE, {"isDebugMode": isDebugEnabled});
  }

  static void submitConsumer(String token, BexPairingListener listener) async {
    if (!BexSdk.isSdkInitialized) throw Exception(_SDK_NOT_INITIALIZED);
    _pairingListener = listener;
    _channel.invokeMethod(_SUBMIT_CONSUMER, {"token": token});
  }

  static void resubmitConsumer(String ticket, BexPairingListener listener) async {
    if (!BexSdk.isSdkInitialized) throw Exception(_SDK_NOT_INITIALIZED);
    _pairingListener = listener;
    _channel.invokeMethod(_RESUBMIT_CONSUMER, {"ticket": ticket});
  }

  static void payment(String token, BexPaymentListener listener) async {
    if (!BexSdk.isSdkInitialized) throw Exception(_SDK_NOT_INITIALIZED);
    _paymentListener = listener;
    _channel.invokeMethod(_PAYMENT, {"token": token});
  }

  static void otpPayment(String ticket, BexOtpPaymentListener listener) async {
    if (!BexSdk.isSdkInitialized) throw Exception(_SDK_NOT_INITIALIZED);
    _otpPaymentListener = listener;
    _channel.invokeMethod(_OTP_PAYMENT, {"ticket": ticket});
  }

  static Future<void> _methodHandler(MethodCall call) async {
    switch (call.method) {
      case _ON_PAIRING_SUCCESS:
        _pairingListener?.onPairingSuccess(call.arguments["first6"], call.arguments["last2"]);
        break;
      case _ON_PAIRING_FAILURE:
        _pairingListener?.onPairingFailure(call.arguments["errorId"], call.arguments["errorMsg"]);
        break;
      case _ON_PAIRING_CANCELLED:
        _pairingListener?.onPairingCancelled();
        break;

      case _ON_PAYMENT_SUCCESS:
        _paymentListener?.onPaymentSuccess(BexPosResult.fromJson(call.arguments));
        break;
      case _ON_PAYMENT_FAILURE:
        _paymentListener?.onPaymentFailure(call.arguments["errorId"], call.arguments["errorMsg"]);
        break;
      case _ON_PAYMENT_CANCELLED:
        _paymentListener?.onPaymentCancelled();
        break;

      case _ON_OTP_PAYMENT_SUCCESS:
        _otpPaymentListener?.onOtpPaymentSuccess();
        break;
      case _ON_OTP_PAYMENT_FAILURE:
        _otpPaymentListener?.onOtpPaymentFailure(call.arguments["errorId"], call.arguments["errorMsg"]);
        break;
      case _ON_OTP_PAYMENT_CANCELLED:
        _otpPaymentListener?.onOtpPaymentCancelled();
        break;
    }
  }
}
