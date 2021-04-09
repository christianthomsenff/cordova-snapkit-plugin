package org.apache.cordova.plugin;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.snapchat.kit.sdk.SnapCreative;
import com.snapchat.kit.sdk.creative.api.SnapCreativeKitApi;
import com.snapchat.kit.sdk.creative.exceptions.SnapMediaSizeException;
import com.snapchat.kit.sdk.creative.exceptions.SnapStickerSizeException;
import com.snapchat.kit.sdk.creative.exceptions.SnapVideoLengthException;
import com.snapchat.kit.sdk.creative.media.SnapMediaFactory;
import com.snapchat.kit.sdk.creative.media.SnapSticker;
import com.snapchat.kit.sdk.creative.models.SnapContent;
import com.snapchat.kit.sdk.creative.models.SnapLiveCameraContent;
import com.snapchat.kit.sdk.creative.models.SnapPhotoContent;
import com.snapchat.kit.sdk.creative.models.SnapVideoContent;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.Uri;
import android.provider.MediaStore;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;
import android.widget.VideoView;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

/**
 * This class echoes a string called from JavaScript.
 */
public class CreativeKit extends CordovaPlugin {

    SnapCreativeKitApi snapCreativeKitApi;
    SnapMediaFactory snapMediaFactory;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        
        Context context = this.cordova.getActivity().getApplicationContext();
        snapCreativeKitApi = SnapCreative.getApi(context);
        snapMediaFactory = SnapCreative.getMediaFactory(context);
    }
    
    private static void copyFile(InputStream inputStream, File file) throws IOException {
        byte[] buffer = new byte[1024];
        int length;

        try (FileOutputStream outputStream = new FileOutputStream(file)) {
            while ((length = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, length);
            }
        }
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if(action.equals("share")) {
            this.SharePhoto(args.getJSONObject(0), callbackContext);
            return true;
        }

        return false;
    }

    private void SharePhoto(JSONObject json, CallbackContext callbackContext) {
        try {
            String dataURL = json.getString("dataUrl").replace("data:image/png;base64", "");
            File stickerFile = saveBase64Image(this.cordova.getActivity().getApplicationContext(), dataURL);
            final SnapContent content = new SnapLiveCameraContent();

            /*if (!TextUtils.isEmpty(mCaptionField.getText())) {
                content.setCaptionText(mCaptionField.getText().toString());
            }
            if (!TextUtils.isEmpty(mUrlField.getText())) {
                content.setAttachmentUrl(mUrlField.getText().toString());
            }*/

            final SnapSticker snapSticker = snapMediaFactory.getSnapStickerFromFile(stickerFile);
            snapSticker.setHeight(json.getInt("height"));
            snapSticker.setWidth(json.getInt("width"));
            snapSticker.setPosX((float) json.getDouble("centerX"));
            snapSticker.setPosY((float) json.getDouble("centerY"));
            snapSticker.setRotationDegreesClockwise(json.getInt("rotation"));
            content.setSnapSticker(snapSticker);

            snapCreativeKitApi.send(content);
            stickerFile.deleteOnExit();
            
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error("Error! " + e);
        }
    }

    private File saveBase64Image(final Context context, final String imageData) throws IOException {
        final byte[] imgBytesData = android.util.Base64.decode(imageData,
                android.util.Base64.DEFAULT);
    
        final File file = File.createTempFile("image", null, context.getCacheDir());
        final FileOutputStream fileOutputStream;
        try {
            fileOutputStream = new FileOutputStream(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    
        final BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(
                fileOutputStream);
        try {
            bufferedOutputStream.write(imgBytesData);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                bufferedOutputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return file;
    }
}