//
//  KMNavBar.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/7.


import Foundation

import UIKit

@objc protocol KMNavBarDelegate {
    @objc optional func KM_navBarLeftButtonClicked(sender:KMNavButton?)
    @objc optional func KM_navBarTitleControlClicked(sender:UIControl?)
    @objc optional func KM_navBarRightButtonClicked(sender:KMNavButton?)
}


public class KMNavBar: KMView {
    
  weak var delegate:(KMNavBarDelegate)?

    weak var navBGView:KMView?
    weak var backgroundImageView:UIImageView?
    weak var navigationView:KMView?
    weak var statusBarView:KMView?
    weak var titleControl:UIControl?
    weak var titleLabel:UILabel?
    weak var leftButton:KMNavButton!
    weak var rightButton:KMNavButton!
    weak var separator:KMView!
    
    override func loadView() {
        super.loadView()
    
        do {
            let v = KMView.init()
            v.backgroundColor = UIColor.white
            self.addSubview(v)
            self.navBGView = v
        }
        
        do {
            let v = UIImageView.init()
            v.backgroundColor = UIColor.clear
            v.contentMode = .scaleToFill
            self.navBGView?.addSubview(v)
            self.backgroundImageView = v
        }
        do {
            let v = KMView.init()
            v.backgroundColor = UIColor.clear
            self.navBGView?.addSubview(v)
            self.statusBarView = v
        }
        do {
            let v = KMView.init()
            v.backgroundColor = UIColor.clear
            self.navBGView?.addSubview(v)
            self.navigationView = v
        }
        
        do {
            let v = UIControl.init()
            v.addTarget(self, action: #selector(handleTitleControlClick), for: .touchUpInside)
            self.navigationView?.addSubview(v)
            self.titleControl = v
        }
        do {
            let v = UILabel.init()
            self.titleControl?.addSubview(v)
            self.titleLabel = v
        }
        do {
            let v = KMNavButton.init()
            v.isHidden = true
            v.addTarget(self, action: #selector(handleLeftButtonClick), for: .touchUpInside)
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.navigationView?.addSubview(v)
            self.leftButton = v
        }
        
        
        do {
            let v = KMNavButton.init()
            v.isHidden = true
            v.addTarget(self, action: #selector(handleRightButtonClick), for: .touchUpInside)
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.navigationView?.addSubview(v)
            self.rightButton = v
        }
        do{
            let v = KMView()
            v.isHidden = true
            self.navigationView?.addSubview(v)
            self.separator = v
        }
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        self.navBGView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        self.backgroundImageView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
        self.statusBarView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(NAV_STATUS)
        })
        
        self.navigationView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.statusBarView?.snp.bottom ?? 0)
            make.left.right.bottom.equalTo(0)
        })
        
        self.separator.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        })
        
        self.leftButton.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.greaterThanOrEqualTo(44)
        })
        
        self.rightButton?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.width.greaterThanOrEqualTo(44)
        })
        
        self.titleControl?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.leftButton?.snp.right ?? 0).offset(8)
            make.right.lessThanOrEqualTo(self.rightButton?.snp.left ?? 0).offset(-8)
            make.top.bottom.equalTo(0)
        })
        
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        
    }

    func setNavLeftTypeBack(){
        
        self.setNavLeftButton(title: "back", imageString: "", font: "15px_medium".font, color: UIColor.black, imagePositionType: .left, titleImageSpec: 15, spaceEdgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        
    }
    
    func setNavLeftTypeClose(){
        self.setNavLeftButton(imageString: "", spaceEdgeInsets:UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13) , imageSize: CGSize(width: 18, height: 18))
    }
    
    func setNavTitle(title:String = "",font:UIFont = "17px_bold".font,color:UIColor = UIColor.black,numberOfLine:Int = 1,fontFitWidth:Bool = false,textAlignment:NSTextAlignment = .center){
        self.titleLabel?.text = title
        self.titleLabel?.font = font
        self.titleLabel?.textColor = color
        self.titleLabel?.textAlignment = textAlignment
        self.titleLabel?.numberOfLines = numberOfLine
        self.titleLabel?.adjustsFontSizeToFitWidth = fontFitWidth
        if self.superview != nil{
        self.layoutIfNeeded()
        }
    }
    
    func setSeparator(hidden:Bool,color:UIColor = "#EDEDED".color){
        self.separator.isHidden = hidden
        self.separator.backgroundColor = color
    }
    
    func setNavLeftButton(title:String = "",selectedTitle:String = "",imageString:String = "",selectedImageString:String = "",font:UIFont = "15px_bold".font,color:UIColor = UIColor.black,selectedTitleColor:UIColor = UIColor.black,imagePositionType:KMNavButtonType = .left,titleImageSpec:CGFloat = 0,spaceEdgeInsets:UIEdgeInsets = .zero,maxWidth:CGFloat? = nil,imageSize:CGSize? = nil){
        
        if title.isEmpty && imageString.isEmpty {
            self.leftButton.isHidden = true
            return
        }
        self.leftButton.isHidden = false
        
        if !imageString.isEmpty {
            self.leftButton.normalImage = imageString.image
        }else{
            self.leftButton.normalImage = nil
        }
        
        if !selectedImageString.isEmpty{
            self.leftButton.selectedImage = selectedImageString.image
        }else{
            self.leftButton.selectedImage = nil
        }
        if !selectedTitle.isEmpty{
            self.leftButton.selectedTitle = selectedTitle
        }
        
        self.leftButton.buttonLabelFont = font
        self.leftButton.buttonLabelTextColor = color
        self.leftButton.normalTitle = title
        self.leftButton.buttonSelectedLabelTextColor = selectedTitleColor
        self.leftButton.imageTitleSpace = titleImageSpec
        self.leftButton.imageSize = imageSize
        self.leftButton.type = imagePositionType
        self.leftButton.spaceEdgeInsets = spaceEdgeInsets
        
    }
    
    func setNavRightButton(title:String = "",selectedTitle:String = "",imageString:String = "",selectedImageString:String = "",font:UIFont = "15px_bold".font,color:UIColor = UIColor.black,selectedTitleColor:UIColor = UIColor.black,imagePositionType:KMNavButtonType = .left,titleImageSpec:CGFloat = 0,spaceEdgeInsets:UIEdgeInsets = .zero,maxWidth:CGFloat? = nil,imageSize:CGSize? = nil){
        
        if title.isEmpty && imageString.isEmpty {
            self.rightButton.isHidden = true
            return
        }
        self.rightButton.isHidden = false
        
        if !imageString.isEmpty {
            self.rightButton.normalImage = imageString.image
        }else{
            self.rightButton.normalImage = nil
        }
        
        if !selectedImageString.isEmpty{
            self.rightButton.selectedImage = selectedImageString.image
        }else{
            self.rightButton.selectedImage = nil
        }
        
        if !selectedTitle.isEmpty{
            self.rightButton.selectedTitle = selectedTitle
        }
        
        self.rightButton.buttonLabelFont = font
        self.rightButton.buttonLabelTextColor = color
        self.rightButton.normalTitle = title
        self.rightButton.buttonSelectedLabelTextColor = selectedTitleColor
        self.rightButton.imageTitleSpace = titleImageSpec
        self.rightButton.imageSize = imageSize
        self.rightButton.type = imagePositionType
        self.rightButton.spaceEdgeInsets = spaceEdgeInsets
        
    }
    
    func setNavBarColor(color:UIColor = UIColor.white){
        self.navBGView?.backgroundColor = color
    }
    
    func setNavigationViewColor(color:UIColor = UIColor.white){
        self.navigationView?.backgroundColor = color
    }
    
    func setNavStatusAndBgImage(statusColor:UIColor = UIColor.clear,imageString:String = ""){
        self.statusBarView?.backgroundColor = statusColor
        if !imageString.isEmpty {
            self.backgroundImageView?.image = imageString.image
        }
    }
    
    @objc func handleLeftButtonClick(){
        self.delegate?.KM_navBarLeftButtonClicked?(sender: self.leftButton)
    }
    
    @objc func handleTitleControlClick(){
        self.delegate?.KM_navBarTitleControlClicked?(sender: self.titleControl)
    }
    
    @objc func handleRightButtonClick(){
        self.delegate?.KM_navBarRightButtonClicked?(sender: self.rightButton)
    }
    
}

