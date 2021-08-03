package org.apache.cordova.plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;
import android.location.Location;

import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

import com.snap.adkit.external.SnapAdKit;
import com.snap.adkit.external.SnapAdEventListener;
import com.snap.adkit.external.SnapAdKitEvent;
import com.snap.adkit.external.SnapAdInitSucceeded;
import com.snap.adkit.external.SnapAdInitFailed;
import com.snap.adkit.dagger.AdKitApplication;

public class AdKit extends CordovaPlugin {

    SnapAdKit snapAdKit;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public void onDestroy()
    {
        super.onDestroy();
        this.snapAdKit.destroy();
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if(action.equals("initializeAdKit")) {
            this.InitializeAdKit(args.getString(0), callbackContext);
            return true;
        }

        if(action.equals("loadInterstitial")) {
            this.LoadInterstitial(args.getString(0), callbackContext);
            return true;
        }

        if(action.equals("loadRewarded")) {
            this.LoadRewarded(args.getString(0), callbackContext);
            return true;
        }

        if(action.equals("playAd")) {
            this.PlayAd(callbackContext);
            return true;
        }

        return false;
    }

    private void InitializeAdKit(String snapKitAppId, CallbackContext callbackContext) {
        SnapAdEventListener adListener = new SnapAdEventListener() {
            @Override
            public void onEvent(SnapAdKitEvent event, String slotId) {
                String eventName = event.toString();
                final int indexOfParenthesis = eventName.indexOf("(");
                if(indexOfParenthesis != -1){
                    eventName = event.toString().substring(0, indexOfParenthesis);
                }
                Log.d("AdKit", "Got some event! " + eventName + "");

                switch(eventName)
                {
                    case "SnapAdInitSucceeded":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdInitSucceeded; if(callback) callback();");
                        break;
                        
                    case "SnapAdInitFailed":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdInitFailed; if(callback) callback('" + event + "');");
                    break;
                    
                    case "SnapAdLoadSucceeded":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdLoadSucceeded; if(callback) callback('" + slotId + "');");
                        break;
                    
                    case "SnapAdLoadFailed":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdLoadFailed; if(callback) { callback('" + slotId + "'); }");
                        break;
                        
                    case "SnapAdRewardedEarned":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdRewardedEarned; if(callback) callback('" + slotId + "');");
                        break;
                        
                    case "SnapAdVisible":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdVisible; if(callback) callback('" + slotId + "');");
                        break;
                    
                    case "SnapAdClicked":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdClicked; if(callback) callback('" + slotId + "');");
                        break;
                    
                    case "SnapAdDismissed":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdDismissed; if(callback) callback('" + slotId + "');");
                        break;
                    
                    case "SnapAdImpressionHappened":
                        executeGlobalJavascript("var callback = window.AdKit.onSnapAdImpressionHappened; if(callback) callback('" + slotId + "');");
                        break;

                    default:                
                    Log.d("AdKit", "Switch didn't get the event...");
                        break;
                }
            }
        };
        
        try {
            Log.d("AdKit", "Trying init....!");
            final Context context = this.cordova.getActivity().getApplicationContext();
            AdKitApplication.init(context);
            SnapAdKit snapAdKit = AdKitApplication.getSnapAdKit();
            snapAdKit.init();

            Log.d("AdKit", "Init called!");

            /*final Location location = new Location("my-location");
            location.setLatitude(33.7490d);
            location.setLongitude(84.3880d);*/
            snapAdKit.setupListener(adListener);
            snapAdKit.register(snapKitAppId, null);
            this.snapAdKit = snapAdKit;

            callbackContext.success("OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }
    
    private void executeGlobalJavascript(final String jsString) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                webView.loadUrl("javascript:" + jsString);
            }
        });
    }

    private void LoadInterstitial(String slotId, CallbackContext callbackContext) {
        try {
            this.snapAdKit.updateSlotId(slotId);
            this.snapAdKit.loadInterstitial();

            callbackContext.success("Load interstitial OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void LoadRewarded(String slotId, CallbackContext callbackContext) {
        try {
            this.snapAdKit.updateSlotId(slotId);
            this.snapAdKit.loadRewarded();

            callbackContext.success("Load rewarded OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void PlayAd(CallbackContext callbackContext) {
        try {
            this.snapAdKit.playAd();

            callbackContext.success("Play ad OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }
}