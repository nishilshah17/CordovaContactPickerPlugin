#import "ContactPicker.h"
#import <Cordova/CDVAvailability.h>

@implementation ContactPicker
@synthesize callbackID;
static BOOL defaultAction = NO;
static NSString *field;

- (void) pickContact:(CDVInvokedUrlCommand*)command{
    self.callbackID = command.callbackId;
    //field = [command.arguments objectAtIndex:0];
    //defaultAction = [command.arguments objectAtIndex:1];

    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];

    picker.peoplePickerDelegate = (id)self;
    picker.displayedProperties = displayedItems;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self.viewController presentViewController:picker animated:YES completion:nil];
    [self.popoverController presentPopoverFromBarButtonItem:nil permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    //[self.viewController dismissViewControllerAnimated:NO completion:nil];
    [self.popoverController dismissPopoverAnimated:YES];
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
  [self.popoverController dismissPopoverAnimated:YES];
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
