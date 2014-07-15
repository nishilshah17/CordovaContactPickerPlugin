#import "ContactPicker.h"
#import <Cordova/CDVAvailability.h>

@implementation ContactPicker
@synthesize callbackID;

- (void) pickContact:(CDVInvokedUrlCommand*)command{
    self.callbackID = command.callbackId;
    NSString* field = [command.arguments objectAtIndex:0];
    BOOL* defaultAction = [command.arguments objectAtIndex:1];

    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];

    picker.peoplePickerDelegate = self;
    picker.displayedProperties = displayedItems;
    [self.viewController presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.viewController dismissModalViewControllerAnimated:YES];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Canceled Person Picker"]
      toErrorCallbackString:self.callbackID]];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
  ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
  int index = ABMultiValueGetIndexForIdentifier(multi, identifier);
  NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, index);
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
  [contact setObject:email forKey: @"email"];
  [contact setObject:displayName forKey: @"displayName"];
  [contact setObject:phoneNumber forKey: @"phoneNumber"];

  [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact] toSuccessCallbackString:self.callbackID]];
  [self.viewController dismissModalViewControllerAnimated:YES];
  return NO;
}

- (BOOL)personViewController:(ABPersonViewController*)personView
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifierForValue
{
    return NO;
}

@end
