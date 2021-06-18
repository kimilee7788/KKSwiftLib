//
//  KMCollectionViewController.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/8.

import Foundation
import UIKit
import EmptyStateKit

class KMCollectionViewController: KMBaseViewController,KMCustomLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var nodata = MainState.noInternet
    var noSearch = MainState.noSearch
    var dataArray:Array<Any> = []
    var collectionView:KMCollectionView?
    var layout:KMCustomLayout?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.layout = KMCustomLayout.init(style: .KMLayoutVerticalEqualWidth)
        self.layout?.delegate = self
        self.collectionView = KMCollectionView.init(frame: .zero, collectionViewLayout: self.layout ?? UICollectionViewLayout.init())
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsVerticalScrollIndicator = false;
        self.collectionView?.showsHorizontalScrollIndicator = false;
        self.collectionView?.allowsSelection = true

        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if self.collectionView != nil {
           self.view.addSubview(self.collectionView!)
            self.KM_registerCollectionViewCell(self.collectionView!)
        }
    
        var format = EmptyStateFormat()
        format.buttonColor = "44CCD6".color
        format.position = EmptyStatePosition(view: .top, text: .center, image: .top)
        format.verticalMargin = 80
        format.horizontalMargin = 40
        format.imageSize = CGSize(width: 159, height: 140)
        format.buttonShadowRadius = 10
        format.titleAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 26)!, .foregroundColor: UIColor.white]
        format.descriptionAttributes = [.font:UIFont.systemFont(ofSize: 14), .foregroundColor: "#333333".color]
        format.gradientColor = ("3854A5".color, "2A1A6C".color)
        
        //todo 设置动画
        
        self.collectionView?.emptyState.format = format
        
        self.dataArray = Array.init()
        
    }

    override func KM_layoutConstraints() {
        super.KM_layoutConstraints()
        self.collectionView?.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            if self.navBar != nil{
                make.top.equalTo(self.navBar!.snp.bottom)
            }else{
                make.top.equalToSuperview()
            }
        }
    }

    func KM_customLayoutSizeForFooter(layout: KMCustomLayout, section: Int) -> CGSize {
        return .zero
    }
    
    func KM_customLayoutSizeForHeader(layout: KMCustomLayout, section: Int) -> CGSize {
        return .zero
    }
    
    func KM_customLayoutSizeforItem(layout: KMCustomLayout, indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func KM_registerCollectionViewCell(_ collectionView:UICollectionView){
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count  = self.dataArray.count
        
        if count == 0 {
            collectionView.emptyState.show(nodata)
        } else {
            collectionView.emptyState.hide()
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        abort()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func updateLayout(customLayout:KMCustomLayout){
        if self.collectionView != nil {
            self.collectionView!.collectionViewLayout = customLayout
        }
        self.collectionView?.reloadData()
    }
    
}
