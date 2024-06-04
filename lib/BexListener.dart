import 'package:bex_flutter_plugin/BexPosResult.dart';

class BexPairingListener {
  void onPairingSuccess(String? first6, String? last2) {}

  void onPairingCancelled() {}

  void onPairingFailure(int? errorId, String? errorMsg) {}
}

class BexPaymentListener {
  void onPaymentSuccess(BexPosResult posResult) {}

  void onPaymentCancelled() {}

  void onPaymentFailure(int? errorId, String? errorMsg) {}
}

class BexOtpPaymentListener {
  void onOtpPaymentSuccess() {}

  void onOtpPaymentCancelled() {}

  void onOtpPaymentFailure(int? errorId, String? errorMsg) {}
}
