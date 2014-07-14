#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Cordova/CDVPlugin.h>

@interface ContactPicker : CDVPlugin <ABPersonViewControllerDelegate>

@property(strong) NSString* callbackID;

- (void) pickContact:(CDVInvokedUrlCommand*)command;

@end
