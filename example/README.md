### Pairing

    import 'package:bex_flutter_plugin/BexListener.dart';
    import 'package:bex_flutter_plugin/BexSdk.dart';
    import 'package:flutter/material.dart';
    
    class Pairing extends StatefulWidget {
      @override
      _PairingState createState() => _PairingState();
    }
    
    class _PairingState extends State<Pairing> implements BexPairingListener {
      String submitToken =
          "Quick pay token will be given by BKM after the merchant integration";
      String resubmitTicket =
          "Ticket will be given by BKM after the merchant integration";
    
      @override
      void initState() {
        super.initState();
        BexSdk.init(isDebugEnabled: true);
      }
    
      _submitConsumer() async {
        BexSdk.submitConsumer(submitToken, this);
      }
    
      _resubmitConsumer() async {
        BexSdk.resubmitConsumer(resubmitTicket, this);
      }
    
      @override
      void onPairingSuccess(String first6, String last2) {
        print("Pairing Success - first6: " + first6 + ", last2: " + last2);
      }
    
      @override
      void onPairingFailure(int errorId, String errorMsg) {
        print("Pairing Failure - errorId: " +
            errorId.toString() +
            ", errorMsg: " +
            errorMsg);
      }
    
      @override
      void onPairingCancelled() {
        print("Pairing Cancelled!");
      }
    
      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    child: Text('Kart Eşleştir'),
                    onPressed: _submitConsumer,
                  )),
              SizedBox(
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    child: Text('Kart Değiştir'),
                    onPressed: _resubmitConsumer,
                  )),
            ],
          ),
        );
      }
    }

### Payment

    import 'package:bex_flutter_plugin/BexListener.dart';
    import 'package:bex_flutter_plugin/BexPosResult.dart';
    import 'package:bex_flutter_plugin/BexSdk.dart';
    import 'package:flutter/material.dart';
    
    class Payment extends StatefulWidget {
      @override
      _PaymentState createState() => _PaymentState();
    }
    
    class _PaymentState extends State<Payment> implements BexPaymentListener {
      String paymentToken =
          "Payment token will be given by BKM after the merchant integration";
    
      @override
      void initState() {
        super.initState();
        BexSdk.init(isDebugEnabled: true);
      }
    
      _payment() async {
        BexSdk.payment(paymentToken, this);
      }
    
      @override
      void onPaymentCancelled() {
        print("Payment Cancelled!");
      }
    
      @override
      void onPaymentFailure(int errorId, String errorMsg) {
        print("Payment Failure - errorId: " +
            errorId.toString() +
            ", errorMsg: " +
            errorMsg);
      }
    
      @override
      void onPaymentSuccess(BexPosResult posResult) {
        print("Payment Success - posResult.token: " + posResult.token);
      }
    
      @override
      Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                    child: Text('Ödeme Yap'),
                    onPressed: _payment,
                  )),
            ],
          ),
        );
      }
    }
