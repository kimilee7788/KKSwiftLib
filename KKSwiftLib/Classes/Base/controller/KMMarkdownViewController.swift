//
//  KMMarkdownViewController.swift
//  Scanner7
//
//  Created by lee kimi on 2021/6/16.
//

import Foundation
import EFMarkdown
open class KMMarkdownViewController: KMBaseViewController {
    var markdownView:EFMarkdownView?
    
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
            // 1. EFMarkdown
            let markdown = "# Hello"
            var html = ""
            do {
                html = try EFMarkdown().markdownToHTML(markdown, options: EFMarkdownOptions.safe)
                // This will return "<h1>Hello</h1>\n"
                print(html)
            } catch let error as NSError {
                print ("Error: \(error.domain)")
            }
            
            let mk = EFMarkdownView()
            self.view.addSubview(mk)
            self.markdownView = mk
            self.markdownView?.load(markdown: testMarkdownFileContent())
        }
    }

    open override func KM_layoutConstraints() {
        super.KM_layoutConstraints()
        self.markdownView?.snp.makeConstraints({ make in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    open func testMarkdownFileContent() -> String {
        if let templateURL = Bundle.main.url(forResource: "FAQ", withExtension: "md") {
            do {
                return try String(contentsOf: templateURL, encoding: String.Encoding.utf8)
            } catch {
                return ""
            }
        }
        return ""
    }
}
