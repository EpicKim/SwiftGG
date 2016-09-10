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
    
    var url:URL!
    private let webView = WKWebView()
    private let progressView = UIProgressView()
    private let progressKeyPath = "estimatedProgress"
    
    // MARK: - Init
    convenience init (URL: Foundation.URL) {
        self.init()
        self.url = URL
    }
    
    
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webView
        webView.expandToFullView()
        webView.frame = view.frame
        webView.load(URLRequest(url: url))
        webView.addObserver(self, forKeyPath: progressKeyPath, options: .new, context: nil) // 加载进度监听
        view.addSubview(webView)
        
        // progressView
        progressView.setFrameBy(self)
        webView.addSubview(progressView)
        
        // 屏幕旋转监听
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenRotate),
            name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: progressKeyPath)
    }

    
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == progressKeyPath {
            
            // 防止进度条突变
            UIView.animate(withDuration: 0.5, animations: {
                self.progressView.setProgress(
                    Float(self.webView.estimatedProgress),
                    animated: true)
            })
            // 渐隐
            if webView.estimatedProgress == 1 {
                UIView.animate(withDuration: 1, animations: {
                    self.progressView.alpha = 0
                })
            }
        }
    }
    
    func screenRotate() {
        webView.expandToFullView()
        // 保证 progressView 不错位
        progressView.setFrameBy(self)
    }
    
}



extension UIProgressView {
    func setFrameBy (_ vc:UIViewController) {
        guard let barFrame = vc.navigationController?.navigationBar.frame else { return }
        let barHeight = barFrame.height + barFrame.origin.y
        self.frame = CGRect(x: 0, y: barHeight, width: vc.view.frame.width, height: 2)
    }
}



