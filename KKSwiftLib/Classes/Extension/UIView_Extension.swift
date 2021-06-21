//
//  UivewEctension.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/18.
//

import Foundation

extension UIView{
    
    @objc func rotationView(_ rotationGestureRecognizer: UIRotationGestureRecognizer?) {
        
       var rotationAngle: CGFloat = 0.0 //旋转的角度
       var latestFrame = CGRect.zero

       if rotationGestureRecognizer?.state == .began || rotationGestureRecognizer?.state == .changed {
        self.transform = (self.transform.rotated(by: (rotationGestureRecognizer?.rotation)!))
          rotationAngle = rotationAngle + (rotationGestureRecognizer?.rotation ?? 0.0)
          rotationGestureRecognizer?.rotation = 0
       } else if rotationGestureRecognizer?.state == .ended {
          latestFrame = self.frame ?? CGRect.zero
       }
    }
    
    @objc func pinchView(_ pinchGestureRecognizer: UIPinchGestureRecognizer?) {
        
        let rotationAngle: CGFloat = 0.0 //旋转的角度

       if pinchGestureRecognizer?.state == .began || pinchGestureRecognizer?.state == .changed {
          if rotationAngle == 0 {
           //narrow
            self.transform = (self.transform.scaledBy(x: (pinchGestureRecognizer?.scale)!, y: (pinchGestureRecognizer?.scale)!))
            pinchGestureRecognizer?.scale = 1
          }
       }
    }
    
    @objc func panView(pan:UIPanGestureRecognizer){
        if (pan.state == .began || pan.state == .changed) {
            let translation = pan.translation(in: self.superview)
            self.center = CGPoint.init(x: self.center.x+translation.x, y: self.center.y + translation.y)
            pan.setTranslation(.zero, in: self.superview)
        }
    }

    //MARK: -添加旋转
    
    func addRotation(){
        let RotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotationView(_:)))
        self.addGestureRecognizer(RotationGestureRecognizer)
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
    }
    
    //MARK: -添加移动
    
    func addMove(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panView(pan:)))
        self.addGestureRecognizer(panGestureRecognizer)
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
    }
    
    //MARK: -添加缩放

    func addPinch(){
        let panGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchView(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
    }
    
    //MARK: - UIView转UIImage
    static func getImageFromView(view: UIView) -> UIImage {
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
    let context = UIGraphicsGetCurrentContext()
    view.layer.render(in: context!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
        
    }
    
}


//添加虚线
extension UIView {
    
    func addDashedBorder(borderColor:UIColor,lineWidth:Float) {

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = borderColor.cgColor
    shapeLayer.lineWidth = CGFloat(lineWidth)
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    self.layer.addSublayer(shapeLayer)
    }
    
}



