As of writing Ad Kit is not available to all developers, reach out to your partner engineer on how to get whitelisted or apply for access on https://snapkit.com/ad-kit.
Make sure to read the first section on https://kit.snapchat.com/docs/ad-kit-android as it provides important information on how to properly test AdKit. Currently this requires using a US-based VPN.

## Android configuration

None.

## iOS configuration


## Using Adkit

After the deviceready event you can access AdKit on the window object. The first thing you'll want to do is initialize by calling window.AdKit.init(appId). The appId in this case is the "Snap Kit App ID" that can be found by navigating to your app on the Snapkit developer portal.

```
AdKitPlugin.prototype.initialize = function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this));
};

AdKitPlugin.prototype.onDeviceReady = function() {
    if(window.AdKit)
    {
        //Found AdKit, initialize...
        window.AdKit.onSnapAdInitSucceeded = this.onSnapAdInitSucceeded.bind(this);
        window.AdKit.onSnapAdInitFailed = this.onSnapAdInitFailed.bind(this);

        var snapKitAppId = "1abc2345-1234-1234-1234-1abc2345abc";
        window.AdKit.init(snapKitAppId);
    }
}

AdKitPlugin.prototype.onSnapAdInitSucceeded = function() {
    console.log("AdKit init success!");
};

AdKitPlugin.prototype.onSnapAdInitFailed = function(err) {
    console.log("AdKit init failed!", err);
};
```

## Loading interstitials/rewarded ads

To request an interstitial:

```
window.AdKit.loadInterstitial(slotId);
```

This loads an interstitial into memory which can be played anytime. To load a rewarded ad use the corresponding

```
window.AdKit.loadRewarded(slotId);
```

You can load several ads into memory and play them one by one. For example, you can load an interstitial ad with various slotIDs, then load a few rewarded ads; then, you'll be able to play interstitial ads or rewarded ads as you please, as long as the requested slotID has an ad loaded in memory.

You can listen to the success or failure of ad loading:

```
....
window.AdKit.onSnapAdLoadSucceeded = this.onSnapAdLoadSucceeded.bind(this);
window.AdKit.onSnapAdLoadFailed = this.onSnapAdLoadFailed.bind(this);
...

AdKitPlugin.prototype.onSnapAdLoadSucceeded = function(slotId) {
    console.log("Loaded ad ("  + slotId + ")");
};

AdKitPlugin.prototype.onSnapAdLoadFailed = function(slotId) {
    console.log("Failed to load ad (" + slotId + ")");
};
```

## Playing ads

If an ad is loaded with the passed in slotId, you play the ad by calling:

```
window.AdKit.playAd(slotId)
```

## Events

In addition to events previously mentioned (init success/fail and loaded ad sucess/fail), AdKit comes with these events:

```
...

window.AdKit.onSnapAdRewardedEarned = this.onSnapAdRewardedEarned.bind(this);
window.AdKit.onSnapAdVisible = this.onSnapAdVisible.bind(this);
window.AdKit.onSnapAdClicked = this.onSnapAdClicked.bind(this);
window.AdKit.onSnapAdDismissed = this.onSnapAdDismissed.bind(this);
window.AdKit.onSnapAdImpressionHappened = this.onSnapAdImpressionHappened.bind(this);

...

AdKitPlugin.prototype.onSnapAdRewardedEarned = function(slotId) {
    console.log("onSnapAdRewardedEarned", slotId);
};

AdKitPlugin.prototype.onSnapAdVisible = function(slotId) {
    console.log("onSnapAdVisible", slotId);
};

AdKitPlugin.prototype.onSnapAdClicked = function(slotId) {
    console.log("onSnapAdClicked", slotId);
};

AdKitPlugin.prototype.onSnapAdDismissed = function(slotId) {
    console.log("onSnapAdDismissed", slotId);
};

AdKitPlugin.prototype.onSnapAdImpressionHappened = function(slotId) {
    console.log("onSnapAdImpressionHappened", slotId);
};

```