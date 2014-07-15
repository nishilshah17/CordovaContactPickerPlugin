cordova.define("com.monmouth.ContactPicker", function(require, exports, module) { /**
 * @constructor
 */
var ContactPicker = function(){};


ContactPicker.prototype.pickContact = function(success, failure, field){
    cordova.exec(success, failure, "ContactPicker", "pickContact", [field]);
};

// Plug in to Cordova
cordova.addConstructor(function() {

    if (!window.Cordova) {
        window.Cordova = cordova;
    };


    if(!window.plugins) window.plugins = {};
    window.plugins.ContactPicker = new ContactPicker();
});

});
