import SCSDKCreativeKit

@objc(CreativeKit) class CreativeKit : CDVPlugin 
{
    var snapAPI: SCSDKSnapAPI?

    override func pluginInitialize() {
        super.pluginInitialize();
        print("Creative kit initialize!");
        snapAPI = SCSDKSnapAPI()
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
                print("Something went wrong!");
                return;
        }
            
            let sticker = SCSDKSnapSticker(stickerUrl: URL(string: dataUrl)!, isAnimated: false);
            sticker.posX = posX;
            sticker.posY = posY;
            sticker.rotation = rotation;
            
            let snap = SCSDKNoSnapContent()
            snap.sticker = sticker /* Optional */
            snap.caption = "Cool caption" /* Optional */
            snap.attachmentUrl = "https://www.snapchat.com" /* Optional */
            
            //view.isUserInteractionEnabled = false
            snapAPI?.startSending(snap) { [weak self] (error: Error?) in
              //self?.view.isUserInteractionEnabled = true
                print("Sending callback");
                
                if let error = error {
                    print("Got some error!", error);
                }
                
              // Handle response
            }
                    
        //} else {
        //    print("error with decodedData")
        //}
        

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        /*
             
        
        let sticker = try? SCSDKSnapSticker(stickerUrl: url!, isAnimated: false)

        /* Modeling a Snap using SCSDKNoSnapContent */
        let snap = SCSDKNoSnapContent()
        //snap.sticker = sticker /* Optional */
        snap.caption = "Cool caption" /* Optional */
        snap.attachmentUrl = "https://www.snapchat.com" /* Optional */
        
        //view.isUserInteractionEnabled = false
        snapAPI?.startSending(snap) { [weak self] (error: Error?) in
          //self?.view.isUserInteractionEnabled = true
            print("Sending callback");
            
            if let error = error {
                print("Got some error!", error);
            }
            
          // Handle response
        }
        

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "OK!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        //} else

        /* Stickers to be used in Snap */
        //let stickerImage = /* Prepare a sticker image */
        //let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        /* Alternatively, use a URL instead */
 */
    }
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
}
extension String {
    func urlSafeBase64Decoded() -> String? {
        var st = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
        let remainder = self.count % 4
        if remainder > 0 {
            st = self.padding(toLength: self.count + 4 - remainder,
                              withPad: "=",
                              startingAt: 0)
        }
        guard let d = Data(base64Encoded: st, options: .ignoreUnknownCharacters) else{
            return nil
        }
        return String(data: d, encoding: .utf8)
    }
}
