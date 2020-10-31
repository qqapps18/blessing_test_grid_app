#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "Runner-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"flutter/MethodChannelDemo"
                                          binaryMessenger:controller.binaryMessenger];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([call.method isEqualToString:@"Documents"]) {
      DateFormatterProvider* formatter = [[DateFormatterProvider alloc] init];
      NSArray<NSString *>* components = [formatter todaysDateComponentsFor: IdentifierHebrew];
      result(components);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
