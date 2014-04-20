/********* CDVFacebookLogin.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface CDVFacebookLogin : CDVPlugin {
    // Member variables go here.
}

- (void)getUserData:(CDVInvokedUrlCommand*)command;
@end

@implementation CDVFacebookLogin

- (void)getUserData:(CDVInvokedUrlCommand*)command
{
    NSString* facebookAppID = [command.arguments objectAtIndex:0];

    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:facebookAppID, ACFacebookAppIdKey, @[@"email"], ACFacebookPermissionsKey, nil];


    [accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
       ^(BOOL granted, NSError *e) {
           CDVPluginResult* pluginResult = nil;
           if (granted) {
               NSArray *accounts = [accountStore accountsWithAccountType:FBaccountType];
               ACAccount *fbAccount = [accounts lastObject];
             // Get the access token
               ACAccountCredential *fbCredential = [fbAccount credential];
               NSString *accessToken = [fbCredential oauthToken];

               SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                   requestMethod:SLRequestMethodGET
                   URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                   parameters:nil];
               request.account = fbAccount;
               [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
                       NSError *deserializationError;
                       NSMutableDictionary *userData = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError] mutableCopy];
                       if (userData != nil && deserializationError == nil) {
                        [userData setObject:accessToken forKey:@"access_token"];

                        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userData] callbackId:command.callbackId];
                    } else {
                      [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
                  }
              }
          }];

           } else {
               NSLog(@"error getting permission %@",e);
               [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
           }
       }];

}
@end
