//
//  WebviewExtension.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

// JS 抓取链接
extension UIWebView {
    
    // 抓取归档链接
    func getArchiveLinks() -> [String] {
        self.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveLinks() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let linkSet = self.stringByEvaluatingJavaScriptFromString("getArchiveLinks();") else { return [] }
        var linkArr = linkSet.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        linkArr = linkArr.filter({ $0.hasPrefix("http://") })
        return linkArr
    }
    
    // 抓取归档标题
    func getArchiveTitles() -> [String] {
        self.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveTitles() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].text + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let titleSet = self.stringByEvaluatingJavaScriptFromString("getArchiveTitles();") else { return [] }
        var titleArr = titleSet.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "+"))
        titleArr = titleArr.filter({ $0.hasPrefix("20") })
        return titleArr
    }
    
    // 抓取各个归档内文章链接
    func getArticleLinks() -> [String] {
        self.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleLinks() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let linkSet = self.stringByEvaluatingJavaScriptFromString("getArticleLinks();") else { return [] }
        var linkArr = linkSet.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        linkArr = linkArr.filter({ $0.hasPrefix("http://") })
        return linkArr
    }
    
    // 抓取各个归档内文章链接
    func getArticleTitles() -> [String] {
        self.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleTitles() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].title + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);")
        guard let titleSet = self.stringByEvaluatingJavaScriptFromString("getArticleTitles();") else { return [] }
        var titleArr = titleSet.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "+"))
        titleArr = titleArr.filter({
            ($0 != "undefined") && ($0 != "")
        })
        return titleArr
    }
    
    
    // 根据当前数据情况，决定是否应该停止加载网页
    func autoStopLoading(byData arr:[AnyObject]) {
        if arr.count != 0 {
            self.stopLoading()
        }
    }
    
}