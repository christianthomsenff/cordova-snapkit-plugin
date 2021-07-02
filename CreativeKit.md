## Setup in the Snapkit Developer Portal

To use Creative Kit you need to create an app in their developer portal.
See their documentation on the developer portal https://kit.snapchat.com/docs/developer-portal

# Creative Kit

Currently this plugin only supports sending overlay stickers. 
Note that stickers must be PNGs 1 MB or smaller.

## Android congfiuration

Paste the following in your app's config.xml between the ```<platform name="android">``` and add your app's Oauth2 client ID from Snapkit's developer portal.

```
<config-file parent="/manifest/application" target="AndroidManifest.xml">
    <meta-data android:name="com.snapchat.kit.sdk.clientId" android:value="your app’s OAuth2 client id" />
<config-file>
```

Add access to FileProvider by adding the following in the ```<config-file ...>``` tag:

```
<provider android:authorities="${applicationId}.fileprovider" android:exported="false" android:grantUriPermissions="true" android:name="androidx.core.content.FileProvider">
    <meta-data android:name="android.support.FILE_PROVIDER_PATHS" android:resource="@xml/file_paths" />
</provider>
```

Images have to be saved to a temporary location before they can be shared. 
Create an xml file and save it at the path res/xml/file_paths.xml with the following

```
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <cache-path name="tmp" path="/" />
</paths>
```

And this line in your ```<platform name="android">``` tag to ensure the file is copied over when building.

```
<resource-file src="res/xml/file_paths.xml" target="app/src/main/res/xml/file_paths.xml" />
```

## iOS configuration

Add the following in your config.xml between the iOS platform tags and input your OAuth2 clientID from Snapkit's developer portal.

```
<config-file parent="SCSDKClientId" target="*-Info.plist">
    <string>Your OAuth2 clientID</string>
</config-file>

<config-file parent="LSApplicationQueriesSchemes" target="*-Info.plist">
    <array>
        <string>snapchat</string>
    </array>
</config-file>
```

 ## Using CreativeKit

 CreativeKit can be accessed on ```window.CreativeKit```, and provides a share method that takes a sticker object. 
 The sticker object allows you to specify rotation, size, placement and the optional caption and attachmentUrl fields.
 Clicking the sticker will take the user to the attachmentUrl if specified. 
 The dataUrl field expects an image encoded as a base64 string.
 Example:

```
var sticker = {
    width: 500,
    height: 500,
    centerX: 0.5,
    centerY: 0.5,
    rotation: 300,
    dataUrl: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==",
    caption: "Cool caption" //Optional,
    attachmentUrl: "https://snap.com" //Optional
};

window.CreativeKit.share(sticker).then(() => {
    console.log("Share OK");
}).catch(err => {
    console.log(err);
});
```

Note as of writing the sticker won't show up on iOS without an attachmentUrl!