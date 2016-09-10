//
//  WebviewExtension.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import WebKit


// MARK: -  用于设定 View 的大小为屏幕大小
protocol ExpandableView {
    func expandToFullView()
}

private func expand(_ view:UIView) {
    view.frame = UIScreen.main.bounds
}

extension WKWebView: ExpandableView {
    func expandToFullView() { expand(self) }
}

extension UIWebView: ExpandableView {
    func expandToFullView() { expand(self) }
}



// MARK: -  用于使用 JS 抓取网页
extension UIWebView {
    
    // 抓取归档链接
    func getArchiveLinks() -> [String] {
        self.stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveLinks() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let linkSet = self.stringByEvaluatingJavaScript(from: "getArchiveLinks();") else { return [] }
        var linkArr = linkSet.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        linkArr = linkArr.filter({ $0.hasPrefix("http://") })
        return linkArr
    }
    
    // 抓取归档标题
    func getArchiveTitles() -> [String] {
        self.stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveTitles() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].text + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        
        guard let titleSet = self.stringByEvaluatingJavaScript(from: "getArchiveTitles();") else { return [] }
        
        var titleArr = titleSet.components(separatedBy: CharacterSet(charactersIn: "+"))
        titleArr = titleArr.filter({ $0.hasPrefix("20") })
        return titleArr
    }
    
    // 抓取各个归档内文章链接
    func getArticleLinks() -> [String] {
        self.stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleLinks() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let linkSet = self.stringByEvaluatingJavaScript(from: "getArticleLinks();") else { return [] }
        var linkArr = linkSet.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        linkArr = linkArr.filter({ $0.hasPrefix("http://") })
        return linkArr
    }
    
    // 抓取各个归档内文章链接
    func getArticleTitles() -> [String] {
        self.stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleTitles() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].title + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let titleSet = self.stringByEvaluatingJavaScript(from: "getArticleTitles();") else { return [] }
        var titleArr = titleSet.components(separatedBy: CharacterSet(charactersIn: "+"))
        titleArr = titleArr.filter({
            ($0 != "undefined") && ($0 != "")
        })
        return titleArr
    }
    
}
