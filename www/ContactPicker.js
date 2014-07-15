var ContactPicker = function(){};

ContactPicker.prototype.pickContact = function(success, failure){
    cordova.exec(success, failure, "ContactPicker", "pickContact", []);
};
