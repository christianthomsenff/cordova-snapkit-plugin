import SAKSDK
import SAKSDK.SAKRegisterRequestConfigurationBuilder;
import SAKSDK.SAKMobileAd;

@objc(AdKit) class AdKit : CDVPlugin, SAKInterstitialDelegate, SAKRewardedAdDelegate//, SAKInterstitialDelegate, SAKRewardedAdDelegate
{

    var interstitial: SAKInterstitial?;
    var rewarded: SAKRewardedAd?;
    
    var lastLoadedAd: String = "";
    var lastInterstitialSlotId: String = "";
    var lastRewardedSlotId: String = "";
    
    override func pluginInitialize() {
        super.pluginInitialize();
    }
    
    @objc(initializeAdKit:)
    func initializeAdKit(command: CDVInvokedUrlCommand) {
                
        let snapKitAppId: String = command.arguments[0] as! String;
        print("initializeAdKit id = " +  snapKitAppId);

        DispatchQueue.global(qos: .background).async {
            let config = SAKRegisterRequestConfigurationBuilder();
            config.withSnapKitAppId(snapKitAppId);
            
            let builtConfig = config.build()!;
            let shared = SAKMobileAd.shared();
            shared.start(with: builtConfig, completion: { (success: Bool, error: Error? ) in
                if success {
                    print("Ad init success!");
                    self.fireJSCallback(eventName: "onSnapAdInitSucceeded", arg: "")
                }
                
                if let error = error {
                    print("Ad kit init error!");
                    print(error.localizedDescription);
                    self.fireJSCallback(eventName: "onSnapAdInitFailed", arg: error.localizedDescription)
                }
            });
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    
    @objc(loadInterstitial:)
    func loadInterstitial(command: CDVInvokedUrlCommand) {
        
        print("Loading interstitial...");
        
        let adSlotId: String = command.arguments[0] as! String;
        let configBuilder = SAKAdRequestConfigurationBuilder();
        configBuilder.withPublisherSlotId(adSlotId);
        
        if(interstitial == nil)
        {
            interstitial = SAKInterstitial.init();
            interstitial?.delegate = self;
        }
        
        interstitial!.loadRequest(configBuilder.build());
        lastInterstitialSlotId = adSlotId;

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    @objc(loadRewarded:)
    func loadRewarded(command: CDVInvokedUrlCommand) {
        
        print("Loading rewarded...");
        
        let adSlotId: String = command.arguments[0] as! String;
        let configBuilder = SAKAdRequestConfigurationBuilder();
        configBuilder.withPublisherSlotId(adSlotId);
        
        if(rewarded == nil)
        {
            rewarded = SAKRewardedAd.init();
            rewarded?.delegate = self;
        }
        
        rewarded!.loadRequest(configBuilder.build());
        lastRewardedSlotId = adSlotId;

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    @objc(playAd:)
    func playAd(command: CDVInvokedUrlCommand) {
        
        let adSlotId: String = command.arguments[0] as! String;
        print("Playing ad... last loaded: " + lastLoadedAd + " , requested ad id=" + adSlotId);

        if(lastInterstitialSlotId == adSlotId)
        {
            interstitial?.present(fromRootViewController: self.viewController, dismissTransition: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)));
        }

        if(lastRewardedSlotId == adSlotId)
        {
            rewarded?.present(fromRootViewController: self.viewController, dismissTransition: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
        }
            
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "true");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }
    
    /************ AD EVENTS ****************/
    
    func rewardedAd(_ ad: SAKRewardedAd, didFailWithError error: Error) {
    }
 
     func rewardedAdDidLoad(_ ad: SAKRewardedAd) {
        lastLoadedAd = "rewarded";
        fireJSCallback(eventName: "onSnapAdLoadSucceeded", arg: lastRewardedSlotId);
     }

     func rewardedAdDidExpire(_ ad: SAKRewardedAd) {
     }

     func rewardedAdWillAppear(_ ad: SAKRewardedAd) {
     }

     func rewardedAdDidAppear(_ ad: SAKRewardedAd) {
     }

     func rewardedAdWillDisappear(_ ad: SAKRewardedAd) {
     }

     func rewardedAdDidDisappear(_ ad: SAKRewardedAd) {
        fireJSCallback(eventName: "onSnapAdDismissed", arg: lastRewardedSlotId);
     }

     func rewardedAdDidShowAttachment(_ ad: SAKRewardedAd) {
     }

     func rewardedAdDidEarnReward(_ ad: SAKRewardedAd) {
     }

     func interstitialDidLoad(_ ad: SAKInterstitial) {
        lastLoadedAd = "interstitial";
        fireJSCallback(eventName: "onSnapAdLoadSucceeded", arg: lastInterstitialSlotId);
     }

     func interstitialDidExpire(_ ad: SAKInterstitial) {
     }

     func interstitialWillAppear(_ ad: SAKInterstitial) {
     }

     func interstitialDidAppear(_ ad: SAKInterstitial) {
     }

     func interstitialWillDisappear(_ ad: SAKInterstitial) {
     }

     func interstitialDidDisappear(_ ad: SAKInterstitial) {
        fireJSCallback(eventName: "onSnapAdDismissed", arg: lastInterstitialSlotId);
     }

     func interstitialDidShowAttachment(_ ad: SAKInterstitial) {
     }

     func interstitialDidTrackImpression(_ ad: SAKInterstitial) {
        fireJSCallback(eventName: "onSnapAdImpressionHappend", arg: lastInterstitialSlotId);
     }

     func interstitial(_ ad: SAKInterstitial, didFailWithError error: Error) {
     }
    
    func fireJSCallback(eventName: String, arg: String) {
        self.commandDelegate!.evalJs("var callback = window.AdKit." + eventName + "; if(callback) callback(\"\(arg)\");");
    }

}
