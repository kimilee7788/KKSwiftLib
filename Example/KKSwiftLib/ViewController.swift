//
//  ViewController.swift
//  KKSwiftLib
//
//  Created by kimilee7788 on 06/17/2021.
//  Copyright (c) 2021 kimilee7788. All rights reserved.
//

import UIKit
import KKSwiftLib
import EFMarkdown
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.after(5) {
            self.present(sdd.init(), animated: true) {
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

 class sdd: KMCollectionViewController {
    
    var subView:KMView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(KMCollectionViewCell.self, forCellWithReuseIdentifier: "KMCollectionViewCell")
    }
    
    override func KM_layoutConstraints() {
        super.KM_layoutConstraints()
        self.collectionView?.snp.remakeConstraints({ make in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    override func KM_loadNavigationBar() {
        super.KM_loadNavigationBar()
        self.navBar?.setNavBarColor(color: .blue)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KMCollectionViewCell", for: indexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }

    override func KM_customLayoutSizeforItem(layout: KMCustomLayout, indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: SCREENWIDTH/4-10, height: 100)
    }
    
    func KM_customLayoutWithColumnCount(layout: KMCustomLayout) -> CGFloat {
        return 4
    }
}
