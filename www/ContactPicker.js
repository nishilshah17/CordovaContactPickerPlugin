var ContactPicker = function(){};

ContactPicker.prototype.pickContact = function(success, failure, field){
    cordova.exec(success, failure, "ContactPicker", "pickContact", [field]);
};
