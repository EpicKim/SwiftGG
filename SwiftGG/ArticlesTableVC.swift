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
    static var archiveLink:String! // 初始化这个页面时，需要访问的网页
    
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "文章"
        
        // 加载网页
        guard let url = NSURL(string: ArticlesTableVC.archiveLink) else { return }
        webview.loadRequest(NSURLRequest(URL: url))
        webview.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Web View
    func webViewDidFinishLoad(webView: UIWebView) {
        // 抓取链接 - 列表根据链接刷新
        let titles = webview.getArticleTitles()
        let links = webview.getArticleLinks()
        
        if titles.count == links.count {
            for var i = 0; i < titles.count; i++ {
                let cellDataObj = CellDataModel(
                    title: titles[i], link:
                    links[i])
                tableData.append(cellDataObj)
            }
            
            tableView.reloadData()
            webview.autoStopLoading(byData: tableData)
        }
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
        let safari = SFSafariViewController(URL: url)
        self.presentViewController(safari, animated: true, completion: nil)
        // deselect
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
