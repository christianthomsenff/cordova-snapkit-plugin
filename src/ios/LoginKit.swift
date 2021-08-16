import SCSDKLoginKit
import SCSDKSnapKit
import WebKit

@objc(LoginKit) class LoginKit : CDVPlugin 
{
    
    override func pluginInitialize() {
        super.pluginInitialize();
    }

    @objc(initSDK:)
    func initSDK(command: CDVInvokedUrlCommand) {
        SCSDKSnapKit.initSDK();
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(login:)
    func login(command: CDVInvokedUrlCommand) {
        SCSDKLoginClient.login(from: self.viewController!) { (success: Bool, error: Error?) in
            if success {
                print("Login success!");
                
                
                self.commandDelegate!.evalJs("var callback = window.LoginKit.onLoginSucceeded; if(callback) callback();")
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK");
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
            if let error = error {
                print(error);
                
                self.commandDelegate!.evalJs("var callback = window.LoginKit.onLoginFailed; if(callback) callback();")
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Fail!");
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
    }

    @objc(isLoggedIn:)
    func isLoggedIn(command: CDVInvokedUrlCommand) 
    {       
        if SCSDKLoginClient.isUserLoggedIn
        {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
        else
        {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "false");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }

    @objc(logout:)
    func logout(command: CDVInvokedUrlCommand)
    {
        SCSDKLoginClient.clearToken();

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);

        self.commandDelegate!.evalJs("var callback = window.LoginKit.onLogout; if(callback) callback();")
    }

    @objc(fetchUserData:)
    func fetchUserData(command: CDVInvokedUrlCommand) 
    {
        let queryString: String = command.arguments[0] as! String;
        
        let successBlock = { (response: [AnyHashable: Any]?) in
            guard let response = response as? [String: Any],
                let data = response["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else {
                    print("Something went wrong!");
                    return
            }
            
            var avatar = "";
            let displayName = me["displayName"] as? String
            let externalid = me["externalId"] as? String;
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                if(bitmoji["avatar"] != nil)
                {
                    avatar = bitmoji["avatar"] as! String;
                }
            }
            
            let resultDict = ["bitmoji": avatar, "externalid": externalid, "displayname": displayName]
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: resultDict as [String: String?]);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
        
        let failureBlock = { (error: Error?, success: Bool) in
            if let error = error 
            {
                print("Failed to fetch user data!");
                let pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: String.init(format: "FetchUserData failed. Details: %@", error.localizedDescription));
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
        
        SCSDKLoginClient.fetchUserData(withQuery: queryString,
                                       variables: nil,
                                       success: successBlock,
                                       failure: failureBlock)
    }

    
    @objc(getAccessToken:)
    func getAccessToken(command: CDVInvokedUrlCommand) 
    {
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "NOT IMPLEMENTED");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
}
