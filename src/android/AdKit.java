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
import com.snap.adkit.dagger.AdKitApplication;

/**
 * This class echoes a string called from JavaScript.
 */
public class AdKit extends CordovaPlugin {

    /*class AdEventListener implements SnapAdEventListener {

        public void onEvent(SnapAdKitEvent event, String slotId) {
            Log.d("AdKit", "Got some event! " + event);
            executeGlobalJavascript("var callback = window.AdKit.onEvent; if(callback) callback();");
        }

    }*/

    SnapAdEventListener adListener;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Log.d("AdKit", "Hello world!");
        
        adListener = new SnapAdEventListener() {
            @Override
            public void onEvent(SnapAdKitEvent event, String slotId) {
                Log.d("AdKit", "Got some event! " + event);
                executeGlobalJavascript("var callback = window.AdKit.onEvent; if(callback) callback();");
            }
        };
        
        Context context = this.cordova.getActivity().getApplicationContext();
        AdKitApplication.init(context);
        SnapAdKit snapAdKit = AdKitApplication.getSnapAdKit();
        snapAdKit.setupListener(adListener);
        snapAdKit.init();

        final Location location = new Location("my-location");
        location.setLatitude(1.2345d);
        location.setLongitude(1.2345d);

        snapAdKit.register("59c024eb-4726-479b-b48c-f279af6d1776", location);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if(action.equals("loadInterstitial")) {
            this.LoadInterstitial(callbackContext);
            return true;
        }

        if(action.equals("loadRewarded")) {
            this.LoadRewarded(callbackContext);
            return true;
        }

        if(action.equals("playAd")) {
            this.LoadRewarded(callbackContext);
            return true;
        }

        return false;
    }
    
    private void executeGlobalJavascript(final String jsString) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                webView.loadUrl("javascript:" + jsString);
            }
        });
    }

    private void LoadInterstitial(CallbackContext callbackContext) {
        try {
           /* Context context = this.cordova.getActivity().getApplicationContext();
            View viewRoot = this.cordova.getActivity().getWindow().getDecorView().getRootView();
            View mLoginButton = SnapLogin.getButton(context, (ViewGroup) viewRoot);
*/
            callbackContext.success("Load interstitial OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void LoadRewarded(CallbackContext callbackContext) {
        try {
           /* Context context = this.cordova.getActivity().getApplicationContext();
            View viewRoot = this.cordova.getActivity().getWindow().getDecorView().getRootView();
            View mLoginButton = SnapLogin.getButton(context, (ViewGroup) viewRoot);
*/
            callbackContext.success("Load rewarded OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void PlayAd(CallbackContext callbackContext) {
        try {
           /* Context context = this.cordova.getActivity().getApplicationContext();
            View viewRoot = this.cordova.getActivity().getWindow().getDecorView().getRootView();
            View mLoginButton = SnapLogin.getButton(context, (ViewGroup) viewRoot);
*/
            callbackContext.success("Play ad OK");
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }
}