//
//  KMCollectionView.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/8.
//

import Foundation
import UIKit

public enum KMLayoutStyle : Int{
    case
    KMLayoutVerticalEqualWidth = 0,//竖向 等宽不等高
    KMLayoutVerticalEqualHeight, //竖向 等高不等款
    KMLayoutHorizontalEqualWeight // 横向 等高不等宽 不支持header footer
    
}
@objc protocol KMCustomLayoutDelegate:NSObjectProtocol{
    //竖直滚动生效
    @objc func KM_customLayoutSizeforItem(layout:KMCustomLayout,indexPath:IndexPath)->CGSize
    @objc func KM_customLayoutSizeForHeader(layout:KMCustomLayout,section:Int) -> CGSize
    @objc func KM_customLayoutSizeForFooter(layout:KMCustomLayout,section:Int) -> CGSize
    
    @objc optional func KM_customLayoutWithColumnCount(layout:KMCustomLayout) -> CGFloat
    @objc optional func KM_customLayoutWithRowCount(layout:KMCustomLayout) -> CGFloat
    
    @objc optional func KM_customLayoutWithColumnMargin(layout:KMCustomLayout) -> CGFloat
    @objc optional func KM_customLayoutWithRowMargin(layout:KMCustomLayout) -> CGFloat
    @objc optional func KM_customLayoutWithEdgeInset(layout:KMCustomLayout) -> UIEdgeInsets
    
}
public class KMCustomLayout: UICollectionViewLayout {
    var layoutStyle:KMLayoutStyle
    //存放所有cell
    var attributes = [UICollectionViewLayoutAttributes]()
    //存放每一列最大y值
    var columnHeights:[CGFloat] = []
    //存放每一行最大x值
    var rowWidths:[CGFloat] = []
    //内容的高度
    var maxColumnHeight:CGFloat = 0
    //内容的宽度
    var maxRowWidth:CGFloat = 0
    
    weak var delegate:(KMCustomLayoutDelegate)?
    func columnMargin()->CGFloat{
        return self.delegate?.KM_customLayoutWithColumnMargin?(layout: self) ?? 1
    }
    func rowMargin()->CGFloat {
        return self.delegate?.KM_customLayoutWithRowMargin?(layout: self) ?? 1
    }
    func columnCount() -> CGFloat{
        return self.delegate?.KM_customLayoutWithColumnCount?(layout: self) ?? 1
    }
    
    func rowCount() -> CGFloat{
        return self.delegate?.KM_customLayoutWithRowCount?(layout: self) ?? 1
    }
    func edgesInsets() -> UIEdgeInsets{
        return self.delegate?.KM_customLayoutWithEdgeInset?(layout: self) ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    init(style:KMLayoutStyle) {
        self.layoutStyle = style
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func prepare() {
        super.prepare()
        
        if self.layoutStyle == .KMLayoutVerticalEqualWidth {
            self.maxColumnHeight = 0
            self.columnHeights.removeAll()
            for _ in 0..<Int(self.columnCount()) {
                self.columnHeights.append(self.edgesInsets().top)
            }
        }else if self.layoutStyle == .KMLayoutHorizontalEqualWeight{
            self.maxRowWidth = 0
            self.rowWidths.removeAll()
            for _ in 0..<Int(self.rowCount()) {
                self.rowWidths.append(self.edgesInsets().left)
            }
        }else if self.layoutStyle == .KMLayoutVerticalEqualHeight{
            self.maxColumnHeight = 0
            self.columnHeights.removeAll()
            self.columnHeights.append(self.edgesInsets().top)
            self.maxRowWidth = 0
            self.rowWidths.removeAll()
            self.rowWidths.append(self.edgesInsets().left)
        }
        self.attributes.removeAll()
        
        
        let sectionCount = self.collectionView?.numberOfSections ?? 0
        for section in 0..<sectionCount {
            if self.delegate?.responds(to: #selector(KMCustomLayoutDelegate.KM_customLayoutSizeForHeader(layout:section:))) ?? false {
                if let headerAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(item: 0, section: section)){
                    self.attributes.append(headerAttrs)
                }
            }
            let rowCount = self.collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0..<rowCount {
                let indexPath = IndexPath.init(item: row, section: section)
                if let attrs = self.layoutAttributesForItem(at: indexPath) {
                    self.attributes.append(attrs)
                }
            }
            
            if self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForFooter(layout:section:))) ?? false {
                if let footerAttrs = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(item: 0, section: section)) {
                    self.attributes.append(footerAttrs)
                }
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        if self.layoutStyle == .KMLayoutVerticalEqualWidth {
            attrs.frame = self.itemFrameOfVerticalWidth(indexPath: indexPath)
        }else if self.layoutStyle == .KMLayoutVerticalEqualHeight{
            attrs.frame = self.itemFrameOfVerticalHeight(indexPath: indexPath)
        }else if self.layoutStyle == .KMLayoutHorizontalEqualWeight{
            attrs.frame = self.itemFrameOfHorizontalWidth(indexPath: indexPath)
        }
        return attrs
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs:UICollectionViewLayoutAttributes?
        if  elementKind == UICollectionView.elementKindSectionHeader {
            attrs = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attrs?.frame = self.headerViewFrameOfVertical(indexPath: indexPath)
        }else{
            attrs = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            attrs?.frame = self.footerViewFrameOfVertical(indexPath: indexPath)
        }
        return attrs
    }
    
    public override var collectionViewContentSize: CGSize{
        if self.layoutStyle == .KMLayoutVerticalEqualWidth {
            return CGSize(width: 0, height: self.maxColumnHeight + self.edgesInsets().bottom)
        }else if self.layoutStyle == .KMLayoutHorizontalEqualWeight{
            return CGSize(width: self.maxRowWidth + self.edgesInsets().right, height: 0)
        }else if self.layoutStyle == .KMLayoutVerticalEqualHeight{
            return CGSize (width: 0, height: self.maxColumnHeight + self.edgesInsets().bottom)
        }
        return .zero
        
    }
    
    //MARK:-Help Methods
    //竖向瀑布流 item等宽不等高
    func itemFrameOfVerticalWidth(indexPath:IndexPath) -> CGRect{
        let collectionW = self.collectionView?.frame.size.width ?? SCREENWIDTH
        
        let w = (collectionW - self.edgesInsets().left - self.edgesInsets().right - (self.columnCount() - 1) * self.columnMargin())/self.columnCount()
        
        let h = self.delegate?.KM_customLayoutSizeforItem(layout: self, indexPath: indexPath).height ?? 0
        
        var destColumn:Int = 0
        
        var minColumnHeight = self.columnHeights.first ?? 0
        
        for i in 1..<Int(self.columnCount()) {
            let columnHeight = self.columnHeights[i]
            if minColumnHeight > columnHeight {
                minColumnHeight = columnHeight
                destColumn = i
            }
        }
        let x = self.edgesInsets().left + CGFloat(destColumn) * (w + self.columnMargin())
        var y = minColumnHeight
        if y != self.edgesInsets().top {
            y += self.rowMargin()
        }
        self.columnHeights[destColumn] = CGRect(x: x, y: y, width: w, height: h).maxY
        let columnHeight = self.columnHeights[destColumn]
        if self.maxColumnHeight < columnHeight {
            self.maxColumnHeight = columnHeight
        }
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //竖向瀑布流 item等高不等宽
    
    func itemFrameOfVerticalHeight(indexPath:IndexPath) -> CGRect{
        let collectionW = self.collectionView?.frame.size.width ?? SCREENWIDTH
        var headViewSize = CGSize.zero
        if self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForHeader(layout:section:))) ?? false {
            headViewSize = self.delegate!.KM_customLayoutSizeForHeader(layout: self, section: indexPath.section)
        }
        let w = self.delegate?.KM_customLayoutSizeforItem(layout: self, indexPath: indexPath).width ?? 0
        let h = self.delegate?.KM_customLayoutSizeforItem(layout: self, indexPath: indexPath).height ?? 0
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        if collectionW - self.rowWidths.first! > w + self.edgesInsets().right {
            if self.rowWidths.first == self.edgesInsets().left {
                x = self.edgesInsets().left
            }else{
                x = self.rowWidths.first! + self.columnMargin()
            }
            
            if self.columnHeights.first! == self.edgesInsets().top  {
                
                y = self.edgesInsets().top
            }else if self.columnHeights.first! == self.edgesInsets().top + headViewSize.height {
                y = self.edgesInsets().top + headViewSize.height + self.rowMargin()
            }else{
                y = self.columnHeights.first! - h
            }
            
            self.rowWidths[0] = x + h
            
            if self.columnHeights.first! == self.edgesInsets().top || self.columnHeights.first! == self.edgesInsets().top + headViewSize.height {
                self.columnHeights[0] = y + h
            }
        }else{
            //换行
            x = self.edgesInsets().left
            y = self.columnHeights.first! + self.rowMargin()
            self.rowWidths[0] = x + w
            self.columnHeights[0] = y + h
        }
        
        
        self.maxColumnHeight = self.columnHeights.first!
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //横向 item等高不等宽
    func itemFrameOfHorizontalWidth(indexPath:IndexPath) -> CGRect{
        let collectionH = self.collectionView?.frame.size.height ?? SCREENHEIGHT
        let h = (collectionH - self.edgesInsets().top - self.edgesInsets().bottom - (self.rowCount() - 1) * self.rowMargin())/self.rowCount()
        
        let w = self.delegate?.KM_customLayoutSizeforItem(layout: self, indexPath: indexPath).width ?? 0
        
        var destRow:Int = 0
        var minRowWidth = self.rowWidths.first!
        
        for i in 1..<self.rowWidths.count {
            let rowWidth = self.rowWidths[i]
            if minRowWidth > rowWidth {
                minRowWidth = rowWidth
                destRow = i
            }
        }
        let y = self.edgesInsets().top + CGFloat(destRow) * (h + self.rowMargin())
        var x = minRowWidth
        if x != self.edgesInsets().left {
            x += self.columnMargin()
        }
        
        self.rowWidths[destRow] = CGRect(x: x, y: y, width: w, height: h).maxX
        
        let rowWidth = self.rowWidths[destRow]
        if self.maxRowWidth < rowWidth {
            self.maxRowWidth = rowWidth
        }
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    func headerViewFrameOfVertical(indexPath:IndexPath)->CGRect{
        var size = CGSize.zero
        if self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForHeader(layout:section:))) ?? false {
            size = self.delegate!.KM_customLayoutSizeForHeader(layout: self, section: indexPath.section)
        }
        
        if self.layoutStyle == .KMLayoutVerticalEqualWidth {
            let x:CGFloat = 0
            var y:CGFloat = 0
            if self.maxColumnHeight == 0{
                y = self.edgesInsets().top
            }else{
                y = self.maxColumnHeight
            }
            
            if !(self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForHeader(layout:section:))) ?? false ) || (self.delegate?.KM_customLayoutSizeForHeader(layout: self, section: indexPath.section).height == 0 ){
                if self.maxColumnHeight == 0{
                    y = self.edgesInsets().top
                }else{
                    y = self.maxColumnHeight + self.rowMargin()
                }
            }
            
            self.maxColumnHeight = y + size.height
            self.columnHeights.removeAll()
            for _ in 0..<Int(self.columnCount()) {
                self.columnHeights.append(self.maxColumnHeight)
            }
            return CGRect(x: x, y: y, width: self.collectionView?.frame.size.width ?? SCREENWIDTH, height: size.height)
            
        }else if self.layoutStyle == .KMLayoutVerticalEqualHeight{
            let x:CGFloat = 0
            var y:CGFloat = 0
            if self.maxColumnHeight == 0{
                y = self.edgesInsets().top
            }else{
                y = self.maxColumnHeight
            }
            
            if !(self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForHeader(layout:section:))) ?? false ) || (self.delegate?.KM_customLayoutSizeForHeader(layout: self, section: indexPath.section).height == 0 ){
                if self.maxColumnHeight == 0{
                    y = self.edgesInsets().top
                }else{
                    y = self.maxColumnHeight + self.rowMargin()
                }
            }
            
            self.maxColumnHeight = y + size.height
            self.rowWidths[0] = self.collectionView?.frame.size.width ?? SCREENWIDTH
            
            self.columnHeights[0] = self.maxColumnHeight
            return CGRect(x: x, y: y, width: self.collectionView?.frame.size.width ?? SCREENWIDTH, height: size.height)
            
        }
        return .zero
    }
    
    func footerViewFrameOfVertical(indexPath:IndexPath)->CGRect{
        var size:CGSize = .zero
        if self.delegate?.responds(to:#selector(KMCustomLayoutDelegate.KM_customLayoutSizeForFooter(layout:section:))) ?? false {
            size = self.delegate!.KM_customLayoutSizeForFooter(layout: self, section: indexPath.section)
        }
        
        if self.layoutStyle == .KMLayoutVerticalEqualWidth {
            let x:CGFloat = 0
            var y:CGFloat = 0
            if size.height == 0{
                y = self.maxColumnHeight
            }else{
                y = self.maxColumnHeight + self.rowMargin()
            }
            self.columnHeights.removeAll()
            for _ in 0..<Int(self.columnCount()) {
                self.columnHeights.append(self.maxColumnHeight)
            }
            return CGRect (x: x, y: y, width: self.collectionView?.frame.size.width ?? SCREENWIDTH, height: size.height)
            
            
        }else if self.layoutStyle == .KMLayoutVerticalEqualHeight{
            let x:CGFloat = 0
            var y:CGFloat = 0
            if size.height == 0 {
                y = self.maxColumnHeight
            }else{
                y = self.maxColumnHeight + self.rowMargin()
            }
            self.maxColumnHeight  = y+size.height
            self.rowWidths[0] = self.collectionView?.frame.size.width ?? SCREENWIDTH
            self.columnHeights[0] = self.maxColumnHeight
            return CGRect (x: x, y: y, width: self.collectionView?.frame.size.width ?? SCREENWIDTH, height: size.height)
            
        }
        return .zero
        
    }
    
}

