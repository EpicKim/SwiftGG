//
//  FakeSafariVC.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/11.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit
import WebKit

// 如果用户使用 iOS 8，则没有 SFSafariViewController，用这个 VC 来加载一个网页
class FakeSafariViewController: UIViewController {
    
    var url:NSURL!
    let webview = WKWebView()
    
    
    // MARK: - Init
    convenience init (URL: NSURL) {
        self.init()
        self.url = URL
    }
    
    
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webview
        webview.expandToFullView()
        webview.loadRequest(NSURLRequest(URL: url))
        view.addSubview(webview)
        
        // 屏幕旋转监听
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(screenRotate),
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func screenRotate() {
        webview.expandToFullView()
    }

    
}

