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
    
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftGG"
        
        // 加载网页
        guard let url = NSURL(string: "http://swift.gg/archives/") else { return }
        webview.loadRequest(NSURLRequest(URL: url))
        webview.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Web View
    func webViewDidFinishLoad(webView: UIWebView) {
        // 抓取链接 - 列表根据链接刷新
        let titles = webview.getArchiveTitles()
        let links = webview.getArchiveLinks()
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = tableData[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // set link
        ArticlesTableVC.archiveLink = tableData[indexPath.row].link
        // push
        guard let navi = self.navigationController else { return }
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ArticlesTableVC") else { return }
        navi.pushViewController(vc, animated: true)
        // deselect
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
