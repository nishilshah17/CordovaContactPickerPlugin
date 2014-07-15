var ContactPicker = function(){};

ContactPicker.prototype.pickContact = function(success, failure) {
    cordova.exec(success, failure, "ContactPicker", "pickContact", []);
};

// Plug in to Cordova
cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };

    if(!window.plugins) window.plugins = {};
    window.plugins.ContactPicker = new ContactPicker();
});
