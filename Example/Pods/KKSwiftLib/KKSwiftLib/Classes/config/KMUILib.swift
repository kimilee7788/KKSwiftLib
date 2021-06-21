//
//  KMUILib.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/8.
//


import Foundation
import UIKit
import CommonCrypto
import MessageUI
public extension String{
    
     var font : UIFont{
        return KMResourceManager.sharedManager().fontWithKey(fontKey: self)
    }
    
    var color : UIColor{
        return KMResourceManager.sharedManager().colorWithKey(colorKey: self)
    }
    
    

    
    var language: String{
        return KMResourceManager.sharedManager().languageStringWithKey(stringKey: self)
    }
    func colorWithAlpha(alpha:CGFloat) -> UIColor{
        return self.color.colorWithAlpha(alpha: alpha)
    }
    
    func fontWithName(fontName:String) -> UIFont{
        return KMResourceManager.sharedManager().fontWithKey(fontKey: self, fontName: fontName)
    }
    
    var image: UIImage{
        return KMResourceManager.sharedManager().imageWithKey(imageKey: self)
    }
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "";
    }
    
    var md5:String{
        let utf8 = cString(using: .utf8)
                var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
                CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
                return digest.reduce("") { $0 + String(format:"%02X", $1) }
        
    }
    
    
//    static func udid() -> String{
//        var currentDeviceUUIDStr = SAMKeychain.password(forService: "com.yoobingo.qr", account: "uuid")
//
//        if currentDeviceUUIDStr == nil || currentDeviceUUIDStr == "" {
//            currentDeviceUUIDStr = UIDevice.current.identifierForVendor?.uuidString
//            currentDeviceUUIDStr = currentDeviceUUIDStr?.replacingOccurrences(of: "-", with: "")
//            currentDeviceUUIDStr = currentDeviceUUIDStr?.lowercased()
//            SAMKeychain.setPassword(currentDeviceUUIDStr ?? "", forService: "com.yoobingo.qr", account: "uuid")
//        }
//
//        return currentDeviceUUIDStr ?? ""
//    }
    var numberValue: NSNumber? {
        if let doub = Double(self) {
            return doub as NSNumber
        }
        return nil
    }
    var urlParameters: [String: String]? {
        
        guard let url = URL(string: self),let componets = URLComponents(url: url, resolvingAgainstBaseURL: false),let queryItems = componets.queryItems else { return nil }
        
        var items:[String:String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
        
        
   }
    
    var urlComponets:URLComponents?{
        
        if !self.isURl{
            return nil
        }
        
        
        guard let url = URL(string: self), let componets = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        return componets
    }
    
    
    var isURl:Bool{
        
        if self.lowercased().hasPrefix("mailto:"){
            return true
        }
        if self.lowercased().hasPrefix("tel:"){
            return true
        }
        if self.lowercased().hasPrefix("sms:"){
            return true
        }
        
        
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false}
        
        let matches = detector.matches(in: self, options: .withTransparentBounds, range: NSRange(location: 0, length: self.count))
        
        for match in matches {
            if match.resultType == .link{
                return true
            }
        }

        return false
    }
    
    var urlQuery:String{
        
        var item = self
        item = item.replacingOccurrences(of: "%", with: "%25")
        item = item.replacingOccurrences(of: "+", with: "%2B")
        item = item.replacingOccurrences(of: " ", with: "%20")
        item = item.replacingOccurrences(of: "/", with: "%2F")
        item = item.replacingOccurrences(of: "#", with: "%23")
        item = item.replacingOccurrences(of: "&", with: "%26")
        item = item.replacingOccurrences(of: "=", with: "%3D")
        
        if let queryItem = item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return queryItem
        }
        
        return item
    }
    
    var urlQueryAllowed:String{
        if let queryItem = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            return queryItem
        }
        return self
    }
    
}


public class KMResourceManager: NSObject {
    private override init() {
        super .init()
    }
    class func sharedManager() -> KMResourceManager{
        struct onceManager {
            static var manager = KMResourceManager()
        }
        return onceManager.manager
    }
    
    func colorWithKey(colorKey:String) -> UIColor {
    
        if colorKey.hasPrefix("#"){
            let index = colorKey.index(colorKey.startIndex, offsetBy: 1)
            let hex = String(colorKey[index...])
            
            return UIColor.PythiaColorFromRGB(rgbValue: hex)
        }
        return UIColor.clear
    }
    
    func imageWithKey(imageKey:String) -> UIImage {
        return UIImage.init(named: imageKey) ?? UIImage.init()
    }
    
    func imageWithResource(fileName:String) -> UIImage{
        let filePath = Bundle.main.path(forResource: fileName, ofType: "png")
        if filePath != nil {
            return UIImage.init(contentsOfFile: filePath!) ?? UIImage.init()
        }
        
        return UIImage.init()
    }
    
    func languageStringWithKey(stringKey:String) -> String{
        
        let localizedString = NSLocalizedString(stringKey, comment: "")
        
        if localizedString.isEmpty {
            return stringKey
        }
        return localizedString
        
    }
    
    func fontWithKey(fontKey:String) -> UIFont{
        //如果出错默认为15px
        
        if fontKey.lowercased().hasSuffix("px") {
            let idx1 = fontKey.startIndex;
            let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -2);

            let fontSize = fontKey[idx1 ..< idx2];
            let font = Double(fontSize)
            return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.regular)
            
        }
        if fontKey.lowercased().hasSuffix("px-light") || fontKey.lowercased().hasSuffix("px_light"){
            let idx1 = fontKey.startIndex;
            let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -8);

            let fontSize = fontKey[idx1 ..< idx2];
            let font = Double(fontSize)
            return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.light)
        }
        
        if fontKey.lowercased().hasSuffix("px-medium") || fontKey.lowercased().hasSuffix("px_medium") {
            let idx1 = fontKey.startIndex;
            let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -9);

            let fontSize = fontKey[idx1 ..< idx2];
            let font = Double(fontSize)
            return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.medium)
        }
        if fontKey.lowercased().hasSuffix("px-semibold") || fontKey.lowercased().hasSuffix("px_semibold"){
                let idx1 = fontKey.startIndex;
                let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -11);

                let fontSize = fontKey[idx1 ..< idx2];
                let font = Double(fontSize)
                return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.semibold)
        }
        if fontKey.lowercased().hasSuffix("px-bold") || fontKey.lowercased().hasSuffix("px_bold"){
                let idx1 = fontKey.startIndex;
                let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -7);

                let fontSize = fontKey[idx1 ..< idx2];
                let font = Double(fontSize)
                return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.bold)
        }
        if fontKey.lowercased().hasSuffix("px-heavy") || fontKey.lowercased().hasSuffix("px_heavy"){
                let idx1 = fontKey.startIndex;
                let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -8);

                let fontSize = fontKey[idx1 ..< idx2];
                let font = Double(fontSize)
                return UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.heavy)
        }
        
        
        
        return UIFont.systemFont(ofSize: 15)
        
    }
     
    func fontWithKey(fontKey:String,fontName:String) -> UIFont{
        
        if fontKey.lowercased().hasSuffix("px") {
            let idx1 = fontKey.startIndex;
            let idx2 = fontKey.index(fontKey.endIndex, offsetBy: -2);

            let fontSize = fontKey[idx1 ..< idx2];
            let font = Double(fontSize)
            
            return UIFont(name: fontName, size: CGFloat(font ?? 15)) ?? UIFont.systemFont(ofSize: CGFloat(font ?? 15), weight:.regular)
            
        }
        return UIFont(name: fontName, size: 15) ?? UIFont.systemFont(ofSize: 15, weight:.regular)
        
    }
    
}

public class UIViewUtil {
    static func corner(view:UIView, byRoundingCorners corners: UIRectCorner, radii: CGFloat){
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}

public class KMSystemShareUtil {
    static func toSystemShare(images:Array<Any>,controller:UIViewController,handler:UIActivityViewController.CompletionWithItemsHandler?){
        let activityVC = UIActivityViewController.init(activityItems: images, applicationActivities:nil)
        activityVC.excludedActivityTypes = [.mail,.message,.airDrop,.postToFacebook]
        activityVC.completionWithItemsHandler = handler
        controller.present(activityVC, animated: true, completion: nil)
    }
}


public class KMMailUtil {
    
    static func sendMail(images:Array<UIImage>){
        
//        let mailSender = MFMailComposeViewController()
//        if mailSender == nil {
//            return
//        }
    }
}


public class KMPrintUtil{
    
    static func printText(url:URL,delegate:UIPrintInteractionControllerDelegate?){
        let printer = UIPrintInteractionController.init()
//      printer.delegate = self
        let info = UIPrintInfo.printInfo()
        info.outputType = .general
        printer.printInfo = info
        printer.printingItem = url
        printer.delegate = delegate
        printer.present(animated: true) { controller, completed, error in
        }
    }
    
    static func printImages(images:Array<UIImage>,delegate:UIPrintInteractionControllerDelegate?){
        
        let printer = UIPrintInteractionController.init()
//        printer.delegate = self
        let info = UIPrintInfo.printInfo()
        info.outputType = .general
        printer.printInfo = info
        printer.printingItems = images
        printer.delegate = delegate
        printer.present(animated: true) { controller, completed, error in
            
        }
    }
}




