#import <Flutter/Flutter.h>

@interface BexFlutterPlugin : NSObject<FlutterPlugin>

+ (BexFlutterPlugin*) sharedPlugin;

@property (nonatomic, strong) FlutterMethodChannel *callbackChannel;

- (void)sendMessage:(NSString*)method params:(NSDictionary*)params;

@end
