import SCSDKCreativeKit

@objc(CreativeKit) class CreativeKit : CDVPlugin
{
    var snapAPI: SCSDKSnapAPI?

    override func pluginInitialize() {
        super.pluginInitialize();
        snapAPI = SCSDKSnapAPI();
    }
    
    @objc(share:)
    func share(command: CDVInvokedUrlCommand) {
        guard let args = command.arguments[0] as? [AnyHashable: Any],
            let dataUrl = args["dataUrl"] as? String,
            let posX = args["centerX"] as? CGFloat,
            let posY = args["centerY"] as? CGFloat,
            let width = args["width"] as? CGFloat,
            let height = args["height"] as? CGFloat,
            let rotation = args["rotation"] as? CGFloat else {
                print("Wrong parameters in sticker!");
                return;
            }
            
        let sticker = SCSDKSnapSticker(stickerUrl: URL(string: dataUrl)!, isAnimated: false);
        sticker.width = width;
        sticker.height = height;
        sticker.posX = posX;
        sticker.posY = posY;
        sticker.rotation = rotation;
        
        let snap = SCSDKNoSnapContent()
        snap.sticker = sticker /* Optional */

        let caption = args["caption"] as? String;
        let attachmentUrl = args["attachmentUrl"] as? String;
        
        if(caption != nil)
        {
            snap.caption = caption;
        }

        if(attachmentUrl != nil)
        {
            snap.attachmentUrl = attachmentUrl;
        }
        
        snapAPI?.startSending(snap) { [self] (error: Error?) in
            if let error = error {
                print("Error sharing", error);
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error sharing! " + error.localizedDescription);
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                } else {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK!");
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            }
        }
        	
        
    }

}
