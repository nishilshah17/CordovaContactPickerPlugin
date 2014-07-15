var ContactPicker = function(){};

ContactPicker.prototype.pickContact = function(success, failure, field, defaultAction){
    cordova.exec(success, failure, "ContactPicker", "pickContact", [field, defaultAction]);
};

cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };


    if(!window.plugins) window.plugins = {};
    window.plugins.ContactPicker = new ContactPicker();
});
