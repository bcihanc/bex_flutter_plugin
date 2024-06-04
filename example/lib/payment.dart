import 'package:bex_flutter_plugin/BexListener.dart';
import 'package:bex_flutter_plugin/BexPosResult.dart';
import 'package:bex_flutter_plugin/BexSdk.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> implements BexPaymentListener, BexOtpPaymentListener {
  String paymentToken = "Payment token will be given by BKM after the merchant integration";

  @override
  void initState() {
    super.initState();
    BexSdk.init(isDebugEnabled: true);
  }

  _payment() async {
    BexSdk.payment(paymentToken, this);
  }

  _otpPayment() async {
    BexSdk.otpPayment(paymentToken, this);
  }

  @override
  void onPaymentCancelled() {
    print("Payment Cancelled!");
  }

  @override
  void onPaymentFailure(int? errorId, String? errorMsg) {
    print("Payment Failure - errorId: " + errorId.toString() + ", errorMsg: " + (errorMsg ?? ""));
  }

  @override
  void onPaymentSuccess(BexPosResult? posResult) {
    print("Payment Success - posResult.token: " + (posResult?.token ?? ""));
  }

  @override
  void onOtpPaymentCancelled() {
    print("OTP Payment Cancelled!");
  }

  @override
  void onOtpPaymentFailure(int? errorId, String? errorMsg) {
    print("OTP Payment Failure - errorId: " + errorId.toString() + ", errorMsg: " + (errorMsg ?? ""));
  }

  @override
  void onOtpPaymentSuccess() {
    print("OTP Payment Success");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        children: [
          SizedBox(
              width: double.infinity, // match_parent
              child: ElevatedButton(
                child: Text('Ödeme Yap'),
                onPressed: _payment,
              )),
          SizedBox(
              width: double.infinity, // match_parent
              child: ElevatedButton(
                child: Text('OTP\'li Hızlı Ödeme'),
                onPressed: _otpPayment,
              )),
        ],
      ),
    );
  }
}