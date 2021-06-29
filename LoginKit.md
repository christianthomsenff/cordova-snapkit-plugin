# Cordova Snapkit plugin

This plugin allows you to integrate Snapchat features into your HTML5 app. It uses the native implementations of 
Loginkit, CreativeKit, Adkit (see https://kit.snapchat.com/docs) and provides a way for apps exported with Cordova to interact with them.

An example Playcanvas project that uses all 3 kits can be found at: https://playcanvas.com/project/771129/overview/snapkitplugin-demo

## Installation

cordova plugin add https://github.com/christianthomsenff/cordova-snapkit-plugin

## Setup in the Snapkit Developer Portal

To use Snapkit you need to create an app in their developer portal.
See their documentation on the developer portal https://kit.snapchat.com/docs/developer-portal

# LoginKit


## Android  congfiuration

LoginKit requires some changes to the AndroidManifest. Paste the following in your app's config.xml between the ```<platform name="android">``` start and end tag. Input correct values for client id, redirect url and scheme,host,path.

```
        <config-file parent="/manifest/application" target="AndroidManifest.xml">
            <meta-data android:name="com.snapchat.kit.sdk.clientId" android:value="your app’s client id" />
            <meta-data android:name="com.snapchat.kit.sdk.redirectUrl" android:value="the url that will handle login completion" />
            <meta-data android:name="com.snapchat.kit.sdk.scopes" android:resource="@array/snap_connect_scopes" />

            <activity android:name="com.snapchat.kit.sdk.SnapKitActivity" android:launchMode="singleTask">
                <intent-filter>
                    <action android:name="android.intent.action.VIEW" />
                    <category android:name="android.intent.category.DEFAULT" />
                    <category android:name="android.intent.category.BROWSABLE" />

                    <!--
                        Enter the parts of your redirect url below
                        e.g., if your redirect url is myapp://snap-kit/oauth2
                            android:scheme="myapp"
                            android:host="snap-kit"
                            android:path="oauth2"
                    !-->

                    <data
                        android:scheme="the scheme of your redirect url"
                        android:host="the host of your redirect url"
                        android:path="the path of your redirect url"
                        />
                </intent-filter>
            </activity>
        </config-file>
```

Now create a file called arrays.xml and paste in:

```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string-array name="snap_connect_scopes">
        <item>https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar</item>
        <item>https://auth.snapchat.com/oauth2/api/user.display_name</item>
    </string-array>
</resources>
```
Save it at the path res/values/arrays.xml at the root of your project. 
This defines which scopes LoginKit have access to. Here both the display name and bitmoji.

And add a line after the ```</config-file>``` tag that copies this file to the correct location when building.

```
<resource-file src="res/values/arrays.xml" target="app/src/main/res/values/arrays.xml" />
```

More info on scopes and Android configuration can be found at: https://kit.snapchat.com/docs/login-kit-android

 ## iOS configuration

 ## Using LoginKit

Loginkit is ready for use after Cordova's deviceready event fires. Note you can subscribe to the event at any time. If you subscribe after the event has fired  the callback function will be called immediately. 
The plugin can be accessed through the window object: ```window.LoginKit```

```
LoginKitPlugin.prototype.initialize = function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this));
};

LoginKitPlugin.prototype.onDeviceReady = function() {
    if(window.LoginKit) {
        //LoginKit is available
    } else {
        //Could not find loginkit
    }
};
```

### Login

To initiate a login simply call the corresponding methods on window.Loginkit.

```
window.LoginKit.login();
```

For updates on login success or failure, LoginKit provides two events you can subscribe to:

```
window.LoginKit.onLoginSucceeded = this.onLoginSucceeded.bind(this);
window.LoginKit.onLoginFailed = this.onLoginFailed.bind(this);


LoginKitPlugin.prototype.onLoginSucceeded = function() {
    //Player is now logged in
};

LoginKitPlugin.prototype.onLoginFailed = function(err) {
    console.log("Login failed", err);
};
```

### Logout


Similarly to logout a user simply call:

```
window.LoginKit.logout();
```

And subscribe to the onLogout event:

```
window.LoginKit.onLogout = this.onLogout.bind(this);

LoginKitPlugin.prototype.onLogout = function() {
    //Player is now logged out
};
```

### Checking logged in status

To check if a user is currently logged in call isLoggedIn. It's a promise that resolves to either "true" or "false".

```
window.LoginKit.isLoggedIn().then(response => {
    if(response == "true")
    {
        //Player is logged in
    }
    
    if(response == "false")
    {
        //Player is not logged in
    }
});
```

### Getting userdata

When a user is logged in we can access his Snapchat display name, 2D bitmoji and external ID. This is done by passing in a query string to the method fetchUserData. A query string for bitmoji, displayname and externalID would look like:

```
var queryString = "{me{bitmoji{avatar},displayName,externalId}}"
```

Passing it to the fetchUserData returns a response object that contains the requested fields.

```
window.LoginKit.fetchUserData(queryString).then(response => {
    //response.displayname
    //response.externalId
    //response.bitmoji
});
```

Make sure to take into account that not all Snapchat users have bitmojis. If they do, the bitmoji field will return a base64 string. You can convert it into a Playcanvas texture:

```
var tex = new pc.Texture(this.app.graphicsDevice, {});
var img = document.createElement('img');
img.src = response.bitmoji;
img.crossOrigin = 'anonymous';
img.onload = (evt) => {
    tex.setSource(img); 
    this.bitmoji.element.texture = tex;
};
```

