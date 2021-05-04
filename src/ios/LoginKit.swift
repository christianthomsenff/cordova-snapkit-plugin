import SCSDKLoginKit
import WebKit

@objc(LoginKit) class LoginKit : CDVPlugin 
{
    
    override func pluginInitialize() {
        super.pluginInitialize();
        
        
        /*SCSDKLoginClient.initialize();
        
        SCSDKLoginClient.refreshAccessToken(completion: { (accessToken: String?, error: Error?) in
            
            if let error = error
            {
                print("Error!");
                print(error);
            }
        });*/
    }
    
    @objc(login:)
    func login(command: CDVInvokedUrlCommand) {
        
            SCSDKLoginClient.login(from: self.viewController!) { (success: Bool, error: Error?) in
                if success {
                    print("Login success!");
                                        
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
        /*DispatchQueue.main.async {
            SCSDKLoginClient.login(from: self.viewController!) { (success : Bool, error : Error?) in
                
                if success {
                    print("Login success!");
                                        
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK");
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                    
                    self.commandDelegate!.evalJs("var callback = window.LoginKit.onLoginSucceeded; if(callback) callback();")
                } else {
                    
                    print("Login njot success :(");
                }

                if let error = error {
                    print("Login error!");
                    print(error);
                    
                    self.commandDelegate!.evalJs("var callback = window.LoginKit.onLoginFailed; if(callback) callback();")
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Fail!");
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                }
            }
        };*/
    }

    @objc(isLoggedIn:)
    func isLoggedIn(command: CDVInvokedUrlCommand) 
    {
        print("Hello from LoginKit is logged in?");
        print("Access token:" + SCSDKLoginClient.getAccessToken());
            
        if SCSDKLoginClient.isUserLoggedIn
        {
            print("Logged in = true");
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
        else
        {
            print("Logged in = false");
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "false");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }

    @objc(logout:)
    func logout(command: CDVInvokedUrlCommand)
    {
        print("Logging out");
        SCSDKLoginClient.clearToken();

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);

        self.commandDelegate!.evalJs("var callback = window.LoginKit.onLogout; if(callback) callback();")
    }

    @objc(fetchUserData:)
    func fetchUserData(command: CDVInvokedUrlCommand) 
    {
        print("Fetching user data");
        let queryString: String = command.arguments[0] as! String;
        
        let successBlock = { (response: [AnyHashable: Any]?) in
            guard let response = response as? [String: Any],
                let data = response["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else {
                    print("Something went wrong!");
                    return
            }

            print("Successing");
            
            var avatar: String?;
            let displayName = me["displayName"] as? String
            let externalid = me["externalId"] as? String
            if let bitmoji = me["bitmoji"] as? [String: Any] { 
                avatar = bitmoji["avatar"] as? String
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
}
