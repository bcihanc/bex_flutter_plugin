#import "BexFlutterPlugin.h"
#import "BKMExpressSDK/BKMExpressSDK.h"

@interface BexFlutterPlugin () <BKMExpressPairingDelegate, BKMExpressPaymentDelegate, BKMExpressOTPVerifyDelegate>
@end

@implementation BexFlutterPlugin

#define SET_DEBUG_MODE @"setDebugMode"
#define SUBMIT_CONSUMER @"submitConsumer"
#define RESUBMIT_CONSUMER @"resubmitConsumer"
#define PAYMENT @"payment"
#define OTP_PAYMENT @"otpPayment"

#define ON_PAIRING_SUCCESS @"onPairingSuccess"
#define ON_PAIRING_FAILURE @"onPairingFailure"
#define ON_PAIRING_CANCELLED @"onPairingCancelled"

#define ON_PAYMENT_SUCCESS @"onPaymentSuccess"
#define ON_PAYMENT_FAILURE @"onPaymentFailure"
#define ON_PAYMENT_CANCELLED @"onPaymentCancelled"

#define ON_OTP_PAYMENT_SUCCESS @"onOtpPaymentSuccess"
#define ON_OTP_PAYMENT_FAILURE @"onOtpPaymentFailure"
#define ON_OTP_PAYMENT_CANCELLED @"onOtpPaymentCancelled"

static BexFlutterPlugin* instance = nil;
static BOOL isDebugMode = NO;

+ (BexFlutterPlugin*) sharedPlugin {
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  @synchronized(self) {
    if (instance == nil) {
      instance = [[BexFlutterPlugin alloc] init:registrar];
      [registrar addApplicationDelegate:instance];
    }
  }
}

- (instancetype)init:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"bex_flutter_plugin" binaryMessenger:[registrar messenger]];
    self.callbackChannel = [FlutterMethodChannel methodChannelWithName:@"bex_flutter_plugin/callback" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:self channel:channel];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([SET_DEBUG_MODE isEqualToString:call.method]) {
      NSNumber* isDebugModeNumber = call.arguments[@"isDebugMode"];
      isDebugMode = [isDebugModeNumber boolValue];
  } else if ([SUBMIT_CONSUMER isEqualToString:call.method]) {
      NSString* token = call.arguments[@"token"];
      [self submitConsumer:token];
  } else if ([RESUBMIT_CONSUMER isEqualToString:call.method]) {
      NSString* ticket = call.arguments[@"ticket"];
      [self resubmitConsumer:ticket];
  } else if ([PAYMENT isEqualToString:call.method]) {
      NSString* token = call.arguments[@"token"];
      [self payment:token];
  } else if ([OTP_PAYMENT isEqualToString:call.method]) {
      NSString* ticket = call.arguments[@"ticket"];
      [self otpPayment:ticket];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)sendMessage:(NSString*)method params:(NSDictionary*)params {
    [self.callbackChannel invokeMethod:method arguments:params];
}

#pragma Bex Sdk methods

- (void)submitConsumer:(NSString *)token {
    BKMExpressPairViewController *vc = [[BKMExpressPairViewController alloc] initWithToken:token delegate:self];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc setEnableDebugMode:isDebugMode];
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)resubmitConsumer:(NSString *)ticket {
    BKMExpressPairViewController *vc = [[BKMExpressPairViewController alloc] initWithTicket:ticket withDelegate:self];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc setEnableDebugMode:isDebugMode];
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)payment:(NSString *)token {
    BKMExpressPaymentViewController *vc = [[BKMExpressPaymentViewController alloc] initWithPaymentToken:token delegate:self];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc setEnableDebugMode:isDebugMode];
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)otpPayment:(NSString *)ticket {
    BKMExpressOTPVerifyController *vc = [[BKMExpressOTPVerifyController alloc] initWithTicket:ticket withDelegate:self];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc setEnableDebugMode:isDebugMode];
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

#pragma Pairing delegate methods

- (void)bkmExpressPairingDidComplete:(NSString *)first6Digits withLast2Digits:(NSString *)last2Digits{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"first6"] = first6Digits;
    data[@"last2"] = last2Digits;
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAIRING_SUCCESS params:data];
}

- (void)bkmExpressPairingDidFail:(NSError *)error{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (error != nil) {
        data[@"errorId"] = [NSNumber numberWithLong:error.code];
        data[@"errorMsg"] = error.localizedDescription;
    } else {
        data[@"errorId"] = @200;
        data[@"errorMsg"] = @"Pairing Failed";
    }
    
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAIRING_FAILURE params:data];
}

- (void)bkmExpressPairingDidCancel{
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAIRING_CANCELLED params:[NSMutableDictionary dictionary]];
}


#pragma Payment delegate methods

- (void)bkmExpressPaymentDidCompleteWithPOSResult:(BKMPOSResult *)posResult{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"posMessage"] = [posResult posMessage];
    data[@"md"] = [posResult md];
    data[@"signature"] = [posResult signature];
    data[@"timestamp"] = [posResult timestamp];
    data[@"token"] = [posResult token];
    data[@"xid"] = [posResult xid];
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAYMENT_SUCCESS params:data];
}

- (void)bkmExpressPaymentDidFail:(NSError *)error{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (error != nil) {
        data[@"errorId"] = [NSNumber numberWithLong:error.code];
        data[@"errorMsg"] = error.localizedDescription;
    } else {
        data[@"errorId"] = @200;
        data[@"errorMsg"] = @"Payment Failed";
    }
    
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAYMENT_FAILURE params:data];
}

- (void)bkmExpressPaymentDidCancel{
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_PAYMENT_CANCELLED params:[NSMutableDictionary dictionary]];
}

- (void)bkmExpressOTPVerified {
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_OTP_PAYMENT_SUCCESS params:[NSMutableDictionary dictionary]];
}

- (void)bkmExpressOTPCanceled {
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_OTP_PAYMENT_CANCELLED params:[NSMutableDictionary dictionary]];
}

- (void)bkmExpressOTPFailed:(NSError *)error {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (error != nil) {
        data[@"errorId"] = [NSNumber numberWithLong:error.code];
        data[@"errorMsg"] = error.localizedDescription;
    } else {
        data[@"errorId"] = @200;
        data[@"errorMsg"] = @"OTP Payment Failed";
    }
    
    [[BexFlutterPlugin sharedPlugin] sendMessage:ON_OTP_PAYMENT_FAILURE params:data];
}


@end
