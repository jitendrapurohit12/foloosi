#import "FoloosiPlugin.h"
#if __has_include(<foloosi/foloosi-Swift.h>)
#import <foloosi/foloosi-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "foloosi-Swift.h"
#endif

@implementation FoloosiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFoloosiPlugin registerWithRegistrar:registrar];
}
@end
