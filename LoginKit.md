# Cordova Snapkit plugin

This plugin allows you to integrate Snapchat features into your HTML5 app. It uses the native implementations of 
Loginkit, CreativeKit, Adkit (see https://kit.snapchat.com/docs) and provides a way for apps exported with Cordova to interact with them.

An example Playcanvas project that uses all 3 kits can be found at: https://playcanvas.com/project/771129/overview/snapkitplugin-demo

## Installation

cordova plugin add cordova-snapkit-plugin

# LoginKit

LoginKit lets your user login with their Snapchat account and gives access to their username and bitmoji.

Loginkit is ready for use after Cordova's deviceready event fires. The plugin can be accessed through the window object: ```window.LoginKit```

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

