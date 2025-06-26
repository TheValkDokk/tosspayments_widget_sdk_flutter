//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_inappwebview_ios/InAppWebViewFlutterPlugin.h>)
#import <flutter_inappwebview_ios/InAppWebViewFlutterPlugin.h>
#else
@import flutter_inappwebview_ios;
#endif

#if __has_include(<os_info_plugin/OsInfoPlugin.h>)
#import <os_info_plugin/OsInfoPlugin.h>
#else
@import os_info_plugin;
#endif

#if __has_include(<tosspayments_webview_flutter/FLTosspaymentsWebViewFlutterPlugin.h>)
#import <tosspayments_webview_flutter/FLTosspaymentsWebViewFlutterPlugin.h>
#else
@import tosspayments_webview_flutter;
#endif

#if __has_include(<url_launcher_ios/URLLauncherPlugin.h>)
#import <url_launcher_ios/URLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [InAppWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"InAppWebViewFlutterPlugin"]];
  [OsInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"OsInfoPlugin"]];
  [FLTosspaymentsWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTosspaymentsWebViewFlutterPlugin"]];
  [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
}

@end
