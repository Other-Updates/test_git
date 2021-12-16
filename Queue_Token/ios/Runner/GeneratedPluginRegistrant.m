//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<bluetooth_print/BluetoothPrintPlugin.h>)
#import <bluetooth_print/BluetoothPrintPlugin.h>
#else
@import bluetooth_print;
#endif

#if __has_include(<charset_converter/CharsetConverterPlugin.h>)
#import <charset_converter/CharsetConverterPlugin.h>
#else
@import charset_converter;
#endif

#if __has_include(<flutter_bluetooth_basic/FlutterBluetoothBasicPlugin.h>)
#import <flutter_bluetooth_basic/FlutterBluetoothBasicPlugin.h>
#else
@import flutter_bluetooth_basic;
#endif

#if __has_include(<flutter_tts/FlutterTtsPlugin.h>)
#import <flutter_tts/FlutterTtsPlugin.h>
#else
@import flutter_tts;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<wifi/WifiPlugin.h>)
#import <wifi/WifiPlugin.h>
#else
@import wifi;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [BluetoothPrintPlugin registerWithRegistrar:[registry registrarForPlugin:@"BluetoothPrintPlugin"]];
  [CharsetConverterPlugin registerWithRegistrar:[registry registrarForPlugin:@"CharsetConverterPlugin"]];
  [FlutterBluetoothBasicPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBluetoothBasicPlugin"]];
  [FlutterTtsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTtsPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [WifiPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiPlugin"]];
}

@end
