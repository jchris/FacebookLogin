var exec = require('cordova/exec');

exports.getUserData = function(fbAppID, done) {
    exec(function(userData){
      done(false, userData)
    }, function(err){
      done(err)
    }, "FacebookLogin", "getUserData", [fbAppID]);
};
