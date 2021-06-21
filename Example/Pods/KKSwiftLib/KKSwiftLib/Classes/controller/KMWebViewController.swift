//
//  KMWebViewController.swift
//  Scanner7
//
//  Created by lee kimi on 2021/6/11.
//

import Foundation
import WebKit
import SnapKit

open class KMWebViewController: KMBaseViewController {
    
    var webView:WKWebView?
    var url:String?
    
    open override func KM_loadNavigationBar() {
        super.KM_loadNavigationBar()
        self.navBar?.setNavLeftButton(imageString: "BACK", spaceEdgeInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), imageSize: CGSize(width: 17, height: 17))
        self.navBar?.setNavBarColor(color: .white)
    }
    
    open override func KM_navBarLeftButtonClicked(sender: KMNavButton?) {
        navigationServices.pop(animated: true)
    }
    
    open override func KM_loadViews() {
        super.KM_loadViews()
        do{
            let view = WKWebView.init()
            view.backgroundColor = UIColor.orange
            self.view.addSubview(view)
            self.webView = view
        }
    }
    
    open override func KM_layoutConstraints() {
        super.KM_layoutConstraints()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        webView?.snp.makeConstraints({ make in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
        webView?.loadUrl(url)
    }
}
