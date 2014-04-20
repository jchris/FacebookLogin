# Log in with Facebook

Not much code. iOS only (for now). Pull reqs welcome.

## Install

    phonegap local plugin add https://github.com/jchris/FacebookLogin.git

## Usage

    window.cordova.plugins.FacebookLogin.getUserData(fbAppID, function(err, userData){
        console.log(err, userData)
        })

## Remember

You have to set your Xcode BundleID on the Facebook App manger.

## Please

If you have something similar on Android, consider sending a pull request so we can add this plugin to the registry.
