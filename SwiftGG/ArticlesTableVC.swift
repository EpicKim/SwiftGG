//
//  ArticlesTableVC.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit
import SafariServices

class ArticlesTableVC: UITableViewController, UIWebViewDelegate {

    let webview = UIWebView()
    var tableData = [CellDataModel]()
    
    static var pageTitle:String! // 页面 title
    static var pageLink:String! // 初始化这个页面时，需要访问的网页
    
    private func getKey() -> String { return ArticlesTableVC.pageTitle }
    
    
    // MARK: - Main
    override func viewWillAppear(animated: Bool) {
        // 加载本地数据
        tableData = self.getContentFromDevice(key: self.getKey())
        tableView.reloadData()
        // 加载网页
        guard let url = NSURL(string: ArticlesTableVC.pageLink) else { return }
        webview.loadRequest(NSURLRequest(URL: url))
        webview.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ArticlesTableVC.pageTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Web View
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // 从 webview 抓取内容
        let titles = webview.getArticleTitles()
        let links = webview.getArticleLinks()
        // 处理抓取到的内容
        tableData.setByData(titles: titles, links: links)
        // 根据内容刷新页面
        self.dealUI_byComparingData(tableView,
            oldData: self.getContentFromDevice(key: self.getKey()),
            newData: tableData, key: self.getKey())
    }
    
    
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // push
        guard let url = NSURL(string: tableData[indexPath.row].link) else { return }
        
        if #available(iOS 9.0, *) {
            let safari = SFSafariViewController(URL: url)
            self.presentViewController(safari, animated: true, completion: nil)
        } else {
            let safari = FakeSafariViewController(URL: url)
            guard let navi = self.navigationController else { return }
            navi.pushViewController(safari, animated: true)
        }
        
        // deselect
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
