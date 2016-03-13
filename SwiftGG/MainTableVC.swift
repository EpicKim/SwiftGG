//
//  MainTableVC.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

class MainTableVC: UITableViewController, UIWebViewDelegate {
    
    let webview = UIWebView()
    var tableData = [CellDataModel]()
    let key = "Main"
    
    
    // MARK: - Main
    override func viewWillAppear(animated: Bool) {
        // 加载本地数据
        tableData = self.getContentFromDevice(key:key)
        tableView.reloadData()
        // 加载网页
        guard let url = NSURL(string: "http://swift.gg/archives/") else { return }
        webview.loadRequest(NSURLRequest(URL: url))
        webview.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftGG"
        
        // 自动 push 第一行
        let data = self.getContentFromDevice(key: key)
        if data.count > 0 {
            pushArticlesVC(
                title: data[0].title,
                link: data[0].link)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Web View
    func webViewDidFinishLoad(webView: UIWebView) {
        // 从 webview 抓取内容
        let titles = webview.getArchiveTitles()
        let links = webview.getArchiveLinks()
        // 处理抓取到的内容
        tableData.setByData(titles: titles, links: links)
        // 根据内容刷新页面
        self.dealUI_byComparingData(tableView,
            oldData: self.getContentFromDevice(key: key),
            newData: tableData, key: key)
    }

    
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = tableData[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // deselect
        pushArticlesVC(
            title: tableData[indexPath.row].title,
            link: tableData[indexPath.row].link)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    // MARK: - 自动 Push
    func pushArticlesVC(title title:String, link:String) {
        // set title & link
        ArticlesTableVC.pageTitle = title
        ArticlesTableVC.pageLink = link
        // push
        guard let navi = self.navigationController else { return }
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ArticlesTableVC") else { return }
        navi.pushViewController(vc, animated: true)
    }
    
}
