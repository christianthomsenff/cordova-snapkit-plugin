package org.apache.cordova.plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.snapchat.kit.sdk.SnapLogin;
import com.snapchat.kit.sdk.core.controller.LoginStateController;
import com.snapchat.kit.sdk.login.models.MeData;
import com.snapchat.kit.sdk.login.models.UserDataResponse;
import com.snapchat.kit.sdk.login.networking.FetchUserDataCallback;

/**
 * This class echoes a string called from JavaScript.
 */
public class LoginKit extends CordovaPlugin {

    private LoginStateController.OnLoginStateChangedListener mLoginStateChangedListener;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        mLoginStateChangedListener = new LoginStateController.OnLoginStateChangedListener() {
                @Override
                public void onLoginSucceeded() {
                    executeGlobalJavascript("var callback = window.LoginKit.onLoginSucceeded; if(callback) callback();");
                }
    
                @Override
                public void onLoginFailed() {
                    executeGlobalJavascript("var callback = window.LoginKit.onLoginFailed; if(callback) callback();");
                }
    
                @Override
                public void onLogout() {
                    executeGlobalJavascript("var callback = window.LoginKit.onLogout; if(callback) callback();");
                }
            };

        Context context = this.cordova.getActivity().getApplicationContext();
        SnapLogin.getLoginStateController(context).addOnLoginStateChangedListener(mLoginStateChangedListener);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if(action.equals("isLoggedIn")) {
            this.IsLoggedIn(callbackContext);
            return true;
        }

        if(action.equals("login")) {
            this.Login(callbackContext);
            return true;
        }

        if(action.equals("logout")) {
            this.Logout(callbackContext);
            return true;
        }

        if(action.equals("addLoginButton")) {
            this.AddLoginButton(callbackContext);
            return true;
        }

        if(action.equals("fetchUserData")) {
            this.FetchUserDataWithQuery(args.getString(0), callbackContext);
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

    private void AddLoginButton(CallbackContext callbackContext) {
        try {
            Context context = this.cordova.getActivity().getApplicationContext();
            View viewRoot = this.cordova.getActivity().getWindow().getDecorView().getRootView();
            View mLoginButton = SnapLogin.getButton(context, (ViewGroup) viewRoot);

            callbackContext.success();
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void Login(CallbackContext callbackContext) {
        try {
            Context context = this.cordova.getActivity().getApplicationContext();
            SnapLogin.getAuthTokenManager(context).startTokenGrant();

            callbackContext.success();
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    private void Logout(CallbackContext callbackContext) {
        try {
        Context context = this.cordova.getActivity().getApplicationContext();
        SnapLogin.getAuthTokenManager(context).clearToken();
    
        callbackContext.success();
        } catch(Error err) {
            callbackContext.error("Error! " + err.toString());
        }
    }

    public void IsLoggedIn(CallbackContext callbackContext) {
        try {
            boolean isUserLoggedIn = SnapLogin.isUserLoggedIn(this.cordova.getActivity().getApplicationContext());
            
            if(isUserLoggedIn) {
                callbackContext.success("true");
            } else {
                callbackContext.success("false");
            }
        } catch(Error err) {
            callbackContext.error("ERROR! " + err.toString());
        }
    }

    public void Verify(String phone, String region) {
        //
    }

    public void UnlinkAllSessions() {
        //
    }

    public String GetAccessToken() {
        return "";
    }

    public boolean HasAccessToScope(String scope) {
        return false;
    }

    public void FetchUserDataWithQuery(String query, CallbackContext callbackContext) {
        boolean isUserLoggedIn = SnapLogin.isUserLoggedIn(this.cordova.getActivity().getApplicationContext());
        if(!isUserLoggedIn)
        {
            callbackContext.error("Could not fetch. User is not logged in!");
            return;
        }

        Context context = this.cordova.getActivity().getApplicationContext();
        SnapLogin.fetchUserData(context, query, null, new FetchUserDataCallback() {
            @Override
            public void onSuccess(@Nullable UserDataResponse userDataResponse) {
                if (userDataResponse == null || userDataResponse.getData() == null) {
                    return;
                }
        
                MeData meData = userDataResponse.getData().getMe();
                if (meData == null) {
                    return;
                }
                
                try {
                JSONObject responseObject = new JSONObject();
        
                if(meData.getDisplayName() != null)
                    responseObject.put("displayname", meData.getDisplayName());
        
                if(meData.getExternalId() != null)
                responseObject.put("externalId", meData.getExternalId());

                if(meData.getBitmojiData() != null)
                {
                    responseObject.put("bitmoji", meData.getBitmojiData().getAvatar());
                }
                
                callbackContext.success(responseObject);
            } catch(JSONException e)
            {                
                callbackContext.error("ERROR! " + e);
            }
            }
        
            @Override
            public void onFailure(boolean isNetworkError, int statusCode) {
                callbackContext.error("ERROR!" + isNetworkError  + " statusCode: " + statusCode);
            }
        });
    }

}