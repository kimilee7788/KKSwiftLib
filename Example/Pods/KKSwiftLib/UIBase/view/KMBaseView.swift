//
//  KMBaseView.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/7.
//

import Foundation
import UIKit

open class KMView: UIView {
    
    func layoutView(){
    }
    
    func loadView() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
        self.layoutView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


open class KMLabel: UILabel {
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum KMButtonEdgeInsetsStyle {
    case KMButtonTop
    case KMButtonLeft
    case KMButtonRight
    case KMButtonBottom
}

public extension UIButton {

    func layoutButton(style: KMButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
//        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
     
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
  
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
            case .KMButtonTop:
                //上 左 下 右
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
                break;
                
            case .KMButtonLeft:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
                break;
                
            case .KMButtonBottom:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
                break;
                
            case .KMButtonRight:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
                break;
                
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
}


public enum KMNavButtonType {
    case left //图片在左 标题在右
    case right //图片在右。标题在左
}
public class KMNavButton: KMControl{

    
    var navButtonSelected:Bool = false{
        didSet{
            if oldValue == navButtonSelected {
                return
            }
            if self.navButtonSelected{
                
                if self.selectedImage != nil{
                    self.navButtonImageView.image = self.selectedImage
                    self.navButtonImageView.snp.remakeConstraints { (make) in
                        make.size.equalTo(imageSize!)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }
                    
                }else{
                    self.navButtonImageView.image = nil
                    self.navButtonImageView.snp.remakeConstraints { (make) in
                        
                        make.size.equalTo(CGSize.zero)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }
                }
                
                if self.selectedTitle != nil{
                    self.navButtonLabel.text = self.selectedTitle
                    
                }else{
                    self.navButtonLabel.text = ""
                }
                self.navButtonLabel.textColor = self.buttonSelectedLabelTextColor
            }else{
                
                if self.normalImage != nil {
                    self.navButtonImageView.image = self.normalImage
                    self.navButtonImageView.snp.remakeConstraints { (make) in
                        make.size.equalTo(imageSize!)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }
                }else{
                    self.navButtonImageView.image = nil
                    self.navButtonImageView.snp.remakeConstraints { (make) in
                        make.size.equalTo(CGSize.zero)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }
                }
                self.navButtonLabel.text = self.normalTitle
                self.navButtonLabel.textColor = self.buttonLabelTextColor
            }
            self.superview?.layoutIfNeeded()
        }
        
    }
    
    weak var navButtonContentView:UIView!
    weak var navButtonImageView:UIImageView!
    weak var navButtonLabel:UILabel!
    
    var selectedImage:UIImage? = nil
    var selectedTitle:String? = nil
    //1:设置间距
    var imageTitleSpace:CGFloat = 0
    var imageSize:CGSize? = nil
    //2:设置类型
    var type:KMNavButtonType = .left{
        didSet{
            if type == .left {
                navButtonImageView.snp.remakeConstraints { (make) in
                    
                    if imageSize != nil{
                        make.size.equalTo(imageSize!)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }else{
                        make.left.top.bottom.equalToSuperview()
                    }
                }
                navButtonLabel.snp.remakeConstraints { (make) in
                    make.right.top.bottom.equalToSuperview()
                    make.left.equalTo(navButtonImageView.snp.right).offset(imageTitleSpace)
                }
            }else{
               navButtonImageView.snp.remakeConstraints { (make) in
                    if imageSize != nil{
                        make.size.equalTo(imageSize!)
                        make.left.equalToSuperview()
                        make.centerY.equalToSuperview()
                    }else{
                        make.left.top.bottom.equalToSuperview()
                    }
                }
                navButtonLabel.snp.remakeConstraints { (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.right.equalTo(navButtonImageView.snp.left).offset(-imageTitleSpace)
                }
            }
        }
    }
    //3:设置左右间距
    
    var spaceEdgeInsets:UIEdgeInsets = .zero{
        didSet{
            
            navButtonContentView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(spaceEdgeInsets.left)
                make.top.equalToSuperview().offset(spaceEdgeInsets.top)
                make.right.equalToSuperview().offset(-spaceEdgeInsets.right)
                make.bottom.equalToSuperview().offset(-spaceEdgeInsets.bottom)
            }
        }
        
    }
    
    
    var normalTitle:String = ""{
        didSet{
            if !self.navButtonSelected {
                self.navButtonLabel.text = normalTitle
            }
            
        }
    }
    var buttonLabelFont:UIFont = "15px_bold".font{
        didSet{
            self.navButtonLabel.font = buttonLabelFont
        }
    }
    
    var buttonLabelTextColor:UIColor = UIColor.black{
        didSet{
            self.navButtonLabel.textColor = buttonLabelTextColor
        }
    }
    
    var buttonSelectedLabelTextColor:UIColor = UIColor.black
    
    var normalImage:UIImage? = nil{
        didSet{
            if !navButtonSelected {
                self.navButtonImageView.image = normalImage
            }
        }
    }
    
    override func loadViews() {
        super.loadViews()
        do{
            let v = UIView()
            v.isUserInteractionEnabled = false
            self.addSubview(v)
            self.navButtonContentView = v
        }
        do{
            let v = UIImageView()
            
            v.image = normalImage
            //无法压缩或拉伸
            v.setContentHuggingPriority(.required, for: .horizontal)
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.navButtonContentView.addSubview(v)
            self.navButtonImageView = v
        }
        do{
            let v = UILabel()
            v.textAlignment = .center
            v.text = ""
            v.font = "15px_bold".font
            v.textColor = UIColor.black
            v.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.navButtonContentView.addSubview(v)
            self.navButtonLabel = v
        }
//        nameLB.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    override func layoutView() {
        
        navButtonContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        navButtonImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        navButtonLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(navButtonImageView.snp.right)
        }
    }
}

open class KMControl: UIControl {
    func loadViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }
    func layoutView() {
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViews()
        self.layoutView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

open class KMCollectionView: UICollectionView {
    var isShouldRecognize:Bool = true
    var interfaceStyle:KMInterfaceStyle = .light{
        didSet{
            
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: interfaceStyle.rawValue) ?? .light
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.KM_loadViews()
        self.KM_layoutConstraints()
    }
    func KM_loadViews(){
        interfaceStyle = .light
    }
    func KM_layoutConstraints(){}
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.isShouldRecognize
    }
}

open class KMCollectionViewCell: UICollectionViewCell {
    
    var interfaceStyle:KMInterfaceStyle = .light{
        didSet{
            
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: interfaceStyle.rawValue) ?? .light
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.KM_loadViews()
        self.KM_layoutConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func KM_loadViews(){
        interfaceStyle = .light
    }
    func KM_layoutConstraints(){}
}

open class KMTableViewCell: UITableViewCell {
    
    var interfaceStyle:KMInterfaceStyle = .light{
        didSet{
            
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyle.init(rawValue: interfaceStyle.rawValue) ?? .light
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.KM_loadViews()
        self.KM_layoutConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func KM_loadViews(){
        interfaceStyle = .light
    }
    func KM_layoutConstraints(){}
}


public enum KMBarButtonType {
    case KMBarButtonType_Image
    case KMBarButtonType_Circle
}

open class KMBarModel{
    
   convenience init(title:String,image:String) {
        self.init()
        self.title = title
        self.image = image
    }

    open var  title:String?
    open var image:String?
    open var color:UIColor = UIColor.red
    open var isWhite = false
    open var isShowBorder = false

    open var w = 40
    
    open var type:KMBarButtonType = .KMBarButtonType_Image
}

 @objc protocol KMBarViewProtocol {
  func clickBarButton(button:UIButton);
}

open class KMBarView:KMView {
    
    weak var scrollView:UIScrollView?
    
    var buttonTitleColor = "#333333".color
    var buttonTitleFont = "14pt".font
    weak var delegate:KMBarViewProtocol?
    var barHeight:CGFloat = 85.0
    var barData:Array<KMBarModel> = []
    var coustomView:KMView?

    override open func loadView() {
        super.loadView()
        do{
            let scroll = UIScrollView.init(frame:self.frame)
            scroll.showsVerticalScrollIndicator = false
            scroll.showsHorizontalScrollIndicator = false
            scroll.isPagingEnabled = true
            self.addSubview(scroll)
            self.scrollView = scroll
            self.scrollView?.snp.makeConstraints({ make in
                make.top.bottom.left.right.equalToSuperview()
            })
        }
    }
    
    open func reSetView() {
        
        for view in self.subviews {
            if view is UIScrollView{
                for v in view.subviews {
                    v.removeFromSuperview()
                }
            }
            else{
                view.removeFromSuperview()
            }
        }
        
        if (self.coustomView != nil){
            self.addSubview(self.coustomView!)
            self.coustomView?.snp.makeConstraints({ make in
                make.size.equalTo(CGSize.init(width: SCREENWIDTH, height: self.coustomView!.frame.size.height))
                make.bottom.equalToSuperview()
            })
        }
        
        guard barData.count <= 0 else {
            let w = SCREENWIDTH/CGFloat(barData.count)
        
            for index in 0 ..< barData.count{
                let x = CGFloat(index)
                let item = barData[index]
                let b = UIButton.init()
                b.tag = index
                b.frame = CGRect.init(x: 0, y: 0, width: w, height: self.barHeight)
                switch item.type {
                case .KMBarButtonType_Image:
                    b.setTitle(item.title, for: .normal)
                    b.setTitleColor(self.buttonTitleColor, for: .normal)
                    b.titleLabel?.font = self.buttonTitleFont
                    b.setImage(UIImage.init(named: item.image ?? ""), for: .normal)
                    if (item.title != nil) {
                        b.layoutButton(style: .KMButtonTop, imageTitleSpace: 2)
                    }
                    break
                case .KMBarButtonType_Circle:
                    let image = UIImage.from(color:item.color, rect: CGRect.init(x: 0, y: 0, width: item.w, height: item.w))
                    b.setImage(UIImage.toCircle(image)(), for: .normal)
                    if item.isShowBorder == true {
                        b.imageView?.layer.borderWidth = 1
                        b.imageView?.layer.cornerRadius = CGFloat(item.w/2)
                        b.imageView?.layer.borderColor = UIColor.black.cgColor
                    }
                    break
                }
                
                b .addTarget(self, action: #selector(barButtonClick(btn:)), for: .touchUpInside)
                self.scrollView!.addSubview(b)
                b.snp.makeConstraints { make in
                    make.width.equalTo(w)
                    if(self.coustomView != nil){
                        make.height.equalTo(item.w + 40)
                    }else{
                        make.height.equalTo(self.snp.height)
                    }
//                    make.size.equalTo(CGSize.init(width: w, height: self.barHeight))
                    make.left.equalTo(w*x)
                }
            }
            return
        }
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    @objc open func barButtonClick(btn:UIButton){
        self.delegate?.clickBarButton(button: btn)
    }
}
