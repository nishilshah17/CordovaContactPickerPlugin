var ContactPicker = function(){};

window.pickContact = function(success, failure) {
    cordova.exec(success, failure, "ContactPicker", "pickContact", []);
};

cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };

    if(!window.plugins) window.plugins = {};
    window.plugins.ContactPicker = new ContactPicker();
});
