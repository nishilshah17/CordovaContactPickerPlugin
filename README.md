CordovaContactPicker
====================

Finally, a working plugin that allows you to select a phone number from your contacts.

To install, run:

``` java
cordova plugin add https://github.com/nishilshah17/CordovaContactPicker.git
```

To use the plugin, simply add the following JavaScript function:

``` java
window.plugins.ContactPicker.pickContact(function (contact) {
  setTimeout(function () {
    phoneNumber = contact.phone;
  }, 0);
}, onError);
```

Thanks for using this plugin!
