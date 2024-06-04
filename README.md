# BKM EXPRESS FLUTTER PLUGIN

## NE İŞE YARAR?
> BKM Express Flutter Plugin, kullanıcının BKMExpress ile yapacağı ödemeler için, işyeri uygulamasından çıkmadan, kart eşleme, kart değiştirme ve güvenli ödeme yapma seçeneklerini sunmaktadır.

## SİSTEM GEREKSİNİMLERİ NELERDİR?

 *  Android: Min SDK Version 15 desteklenmektedir.
 *  iOS: Min iOS 9.0 versiyonu desteklenmektedir.

## NASIL ÇALIŞIR?

BKM Express Flutter paketinin kullanılabilmesi için işyerleri BKM Express entegrasyonlarını tamamlaması gerekmektedir. Daha sonra işyeri servis uygulamaları BKMExpress core servislerine bağlanarak kendilerine verilen **TOKEN**'ı SDK tarafından sunulan methodlara parametrik olarak ileterek kart eşleştirme, değiştirme ve güvenli ödeme akışını başlatabilirler.

## ORTAMLAR

Kart eşleme paketi iki farklı ortamda çalışmaktadır. 
* PROD
* PREPROD

**NOT:** Entegrasyon sırasında işyerlerine verilen anahtarların sorumluluğu, **işyerine** aittir.

### Flutter Entegrasyonu

 BKM Express Flutter Plugin kullanmak için sırası ile aşağıdaki adımlar izlenmelidir.

* Projenizin pubspec.yaml dosyasına paketi ekleyiniz.

        dependencies:
           bex_flutter_plugin: ^1.1.1

* Komut satırından eklenen paketleri çekiniz.

            $ flutter pub get

* Projenin Android entegrasyonu için lütfen size sunmuş olduğumuz kullanıcı adı ve şifreyi, Android projesinde bulunan local.properties dosyasına aşağıdaki gibi ekleyiniz.

            bkm_username=<<YOUR_USERNAME>>
            bkm_password=<<YOUR_PASSWORD>>
            bkm_maven_url = http://54.174.1.67/artifactory/bexandroidsdk-release-android
**NOT:** Android veya iOS özelinde herhangi bir entegrasyon gerekmemektedir.

### Dart Entegrasyonu

Flutter entegrasyonunu yaptıktan sonra pakete ait dart kütüphanelerini kodunuza ekleyiniz.

    import 'package:bex_flutter_plugin/BexListener.dart';
    import 'package:bex_flutter_plugin/BexPosResult.dart';
    import 'package:bex_flutter_plugin/BexSdk.dart';
    
Paketi kullanmak için ilk olarak init fonksiyonunu çağırmanız gerekmektedir. PreProd ortama bağlanmak için init aşamasında isDebugEnabled true olarak setlenmelidir.

     BexSdk.init(); // Prod
    
     BexSdk.init(isDebugEnabled: true); // PreProd
    
BKMExpress SDK arayüzlerinden geri haber alabilmek için **BexPaymentListener**, **BexPairingListener** ve **BexOtpPaymentListener** kullanılması gerekmektedir.

#### BexPaymentListener
    void onPaymentSuccess(BexPosResult posResult) {}
    void onPaymentCancelled() {}
    void onPaymentFailure(int errorId, String errorMsg) {}
    
#### BexPairingListener
    void onPairingSuccess(String first6, String last2) {}
    void onPairingCancelled() {}
    void onPairingFailure(int errorId, String errorMsg) {}
    
#### BexOtpPaymentListener
    void onOtpPaymentSuccess() {}
    void onOtpPaymentCancelled() {}
    void onOtpPaymentFailure(int errorId, String errorMsg) {}
    
### Örnek Ödeme Akışı
    class _PaymentState extends State<Payment> implements BexPaymentListener {
      String paymentToken = "Payment token will be given by BKM after the merchant integration";
    
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
        print("Payment Failure - errorId: " + errorId.toString() + ", errorMsg: " + errorMsg);
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

### Örnek Eşleşme Akışı
    class _PairingState extends State<Pairing> implements BexPairingListener {
      String submitToken = "Quick pay token will be given by BKM after the merchant integration";
      String resubmitTicket = "Ticket will be given by BKM after the merchant integration";
    
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
        print("Pairing Failure - errorId: " + errorId.toString() + ", errorMsg: " + errorMsg);
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
    
### Örnek OTP'li Hızlı Ödeme Doğrulama Akışı
    class _OtpPaymentState extends State<Payment> implements BexOtpPaymentListener {
      String paymentTicket = "Payment ticket will be given by BKM after the merchant integration";
    
      @override
      void initState() {
        super.initState();
        BexSdk.init(isDebugEnabled: true);
      }
    
      _otpPayment() async {
        BexSdk.otpPayment(paymentTicket, this);
      }
    
      @override
      void onOtpPaymentCancelled() {
        print("OTP Payment Cancelled!");
      }
      
      @override
      void onOtpPaymentFailure(int errorId, String errorMsg) {
        print("OTP Payment Failure - errorId: " + errorId.toString() + ", errorMsg: " + errorMsg);
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
                   child: RaisedButton(
                     child: Text('OTP\'li Hızlı Ödeme Doğrulama'),
                     onPressed: _otpPayment,
                 )),
            ],
          ),
        );
      }
    }