import SAKSDK
import SAKSDK.SAKRegisterRequestConfigurationBuilder;
import SAKSDK.SAKMobileAd;

@objc(AdKit) class AdKit : CDVPlugin 
{
    
    override func pluginInitialize() {
        super.pluginInitialize();
        print("Ad kit initialize!");
    }
    
    @objc(initializeAdkit:)
    func initializeAdKit(command: CDVInvokedUrlCommand) {
        
        print("initializeAdKit!");
        
        DispatchQueue.global(qos: .background).async {
            let config = SAKRegisterRequestConfigurationBuilder();
            config.withSnapKitAppId("59c024eb-4726-479b-b48c-f279af6d1776");
            
            let builtConfig = config.build()!;
            let shared = SAKMobileAd.shared();
            shared.start(with: builtConfig, completion: { (success: Bool, error: Error? ) in
                if success {
                    print("Ad init success!");
                } else {
                    print("Ad init not success :(");
                }
                
                if let error = error {
                    print("Ad kit init error!");
                    print(error);
                    print(error.localizedDescription);
                }
            });
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    
    @objc(loadInterstitial:)
    func loadInterstitial(command: CDVInvokedUrlCommand) {
        
        print("Loading interstitial...");

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    @objc(loadRewarded:)
    func loadRewarded(command: CDVInvokedUrlCommand) {
        
        print("Loading rewarded...");

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    @objc(playAd:)
    func playAd(command: CDVInvokedUrlCommand) {
        print("Playing ad...");

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
   
}
