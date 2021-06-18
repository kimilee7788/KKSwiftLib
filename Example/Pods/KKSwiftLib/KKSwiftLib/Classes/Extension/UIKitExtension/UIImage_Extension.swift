//
//  UIImageExtend.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/18.
//

import Foundation
import PhotosUI
extension UIImage {
    
    //MARK: - 剪裁指定区域
    
    func imageAtRect(rect: CGRect) -> UIImage{
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    //MARK: - 创建颜色图片(1像素)
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    //MARK: -创建颜色图片(1像素)
    static func from(color: UIColor,rect:CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    //MARK: -创建圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    
}

//MARK: -创建颜色图片(1像素)

extension UIImage
{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

//相册

class KMPhoto:NSObject{
    
    static let shared = KMPhoto.init()
    
    var callBack: ((_ image:Array<UIImage>)->())?
    
//    func getPhoto(delegate:Any,controller:UIViewController,selectionLimit:Int,action: @escaping ((_ image:Array<UIImage>)->())){
//        
//        self.callBack = action
//        
//        let pickerController = DKImagePickerController()
//        pickerController.maxSelectableCount = selectionLimit
//        pickerController.sourceType = .photo
//        pickerController.showsCancelButton = true
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            
//            var imgs:Array<UIImage> = []
//            
//            for asset in assets {
//                let opt = PHImageRequestOptions.init()
//                opt.isSynchronous = true
//                asset.fetchOriginalImage(options:opt) { image, info in
//                    imgs.append(image!)
//                }
//                
//            }
//            self.callBack?(imgs)
//        }
//        
//        controller.present(pickerController, animated: true) {}
//    }
    
    class func writeImage(image:UIImage,name:String){
        if let data = image.pngData() {
            let filename = KMPhoto.getDocumentsDirectory().appendingPathComponent(String("\(name).png"))
            //                print("写入图片: \(filename)")
            try? data.write(to: filename)
        }
    }
    
    class func writeText(text:String,name:String){
        let data = text.data(using:.utf8)
        let filename = KMPhoto.getDocumentsDirectory().appendingPathComponent(String("\(name).txt"))
        JKPrint("写入TXT文件：\(filename)")
        try? data?.write(to: filename)
    }
    
    class func getTxtPath(name:String) -> String {
        let filename = KMPhoto.getDocumentsDirectory().appendingPathComponent(String("\(name).txt"))
        return filename.path
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    class func getImage(name:String) -> UIImage {
        let filename = KMPhoto.getDocumentsDirectory().appendingPathComponent(String("\(name).png"))
        //    print("读取图片: \(filename)")
        let img = UIImage.init(contentsOfFile: filename.path)
        return img ?? UIImage.init(named: "t1")!
    }
    
    
   class func getPDFWithImage(imags:Array<UIImage>) -> String {
        
        if imags.count == 0 {return ""}
        let filename = KMPhoto.getDocumentsDirectory().appendingPathComponent(String("123.pdf"))
        let  result = UIGraphicsBeginPDFContextToFile(filename.path, CGRect.zero, nil)
        let pdfBounds = UIGraphicsGetPDFContextBounds()
        let pdfWidth = pdfBounds.size.width
        let pdfHeight = pdfBounds.size.height
        
        for (_, value) in imags.enumerated() {
            
            UIGraphicsBeginPDFPage();
            let imageW:CGFloat = value.size.width;
            let imageH:CGFloat = value.size.height;
            
            if (imageW <= pdfWidth && imageH <= pdfHeight) {
                let originX = (pdfWidth - imageW) * 0.5;
                let  originY = (pdfHeight - imageH) * 0.5;
                value.draw(in: CGRect.init(x: originX, y: originY, width: imageW, height: imageH))
            }else{
                var w:CGFloat = 0.0
                var h:CGFloat = 0.0
                if ((imageW / imageH) > (pdfWidth / pdfHeight)){
                    w = CGFloat(Int(pdfWidth - 20.0));
                    h = CGFloat(Int(CGFloat(w) * imageH / imageW));
                    
                }else{
                    //             图片高宽比大于PDF
                    h = CGFloat(Int(pdfHeight - 20));
                    w = CGFloat(Int(h * imageW / imageH));
                }
                value.draw(in: CGRect.init(x: (pdfWidth - w) * 0.5, y: (pdfHeight - h) * 0.5, width: w, height: h))
            }
        }
        UIGraphicsEndPDFContext();
        print(filename.absoluteString)
        return filename.path
    }
}
/**
 
 + (BOOL)convertPDFWithImages:(NSArray<UIImage *>*)images fileName:(NSString *)fileName{
 
 if (!images || images.count == 0) return NO;
 
 // pdf文件存储路径
 NSString *pdfPath = [self saveDirectory:fileName];
 NSLog(@"****************文件路径：%@*******************",pdfPath);
 
 BOOL result = UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, NULL);
 
 // pdf每一页的尺寸大小
 
 CGRect pdfBounds = UIGraphicsGetPDFContextBounds();
 CGFloat pdfWidth = pdfBounds.size.width;
 CGFloat pdfHeight = pdfBounds.size.height;
 
 NSLog(@"%@",NSStringFromCGRect(pdfBounds));
 
 [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
 // 绘制PDF
 UIGraphicsBeginPDFPage();
 
 // 获取每张图片的实际长宽
 CGFloat imageW = image.size.width;
 CGFloat imageH = image.size.height;
 //        CGRect imageBounds = CGRectMake(0, 0, imageW, imageH);
 //        NSLog(@"%@",NSStringFromCGRect(imageBounds));
 
 // 每张图片居中显示
 // 如果图片宽高都小于PDF宽高
 if (imageW <= pdfWidth && imageH <= pdfHeight) {
 
 CGFloat originX = (pdfWidth - imageW) * 0.5;
 CGFloat originY = (pdfHeight - imageH) * 0.5;
 [image drawInRect:CGRectMake(originX, originY, imageW, imageH)];
 
 }
 else{
 CGFloat w,h; // 先声明缩放之后的宽高
 //            图片宽高比大于PDF
 if ((imageW / imageH) > (pdfWidth / pdfHeight)){
 w = pdfWidth - 20;
 h = w * imageH / imageW;
 
 }else{
 //             图片高宽比大于PDF
 h = pdfHeight - 20;
 w = h * imageW / imageH;
 }
 [image drawInRect:CGRectMake((pdfWidth - w) * 0.5, (pdfHeight - h) * 0.5, w, h)];
 }
 }];
 
 UIGraphicsEndPDFContext();
 
 return result;
 }
 
 */
