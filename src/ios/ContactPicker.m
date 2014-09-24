#import "ContactPicker.h"
#import <Cordova/CDVAvailability.h>

@implementation ContactPicker
@synthesize callbackID;
//static BOOL defaultAction = NO;
//static NSString *field;

- (void) pickContact:(CDVInvokedUrlCommand*)command{
    self.callbackID = command.callbackId;
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];

    picker.peoplePickerDelegate = (id)self;
    picker.displayedProperties = displayedItems;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.viewController dismissViewControllerAnimated:NO completion:nil];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Canceled Person Picker"]
      toErrorCallbackString:self.callbackID]];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{

  NSString *displayName = (__bridge NSString *)ABRecordCopyCompositeName(person);
  ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
  NSString* phoneNumber = @"";
  for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
      if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
          phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multiPhones, i);
          break;
      }
  }

  NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithCapacity:2];

  [contact setObject:displayName forKey: @"displayName"];
  [contact setObject:phoneNumber forKey: @"phoneNumber"];

  [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact] toSuccessCallbackString:self.callbackID]];
  [self.viewController dismissViewControllerAnimated:NO completion:nil];
  return NO;
}

- (BOOL)personViewController:(ABPersonViewController*)personView
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifierForValue
{
    return NO;
}

//for ios 8 support
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
        didSelectPerson:(ABRecordRef)person
        property:(ABPropertyID)property
        identifier:(ABMultiValueIdentifier)identifier {

    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

@end
