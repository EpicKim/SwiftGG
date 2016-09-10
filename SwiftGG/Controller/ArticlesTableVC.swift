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
    
    var titleText: String = "" // 这个页面的 title 应有的值，名称区别于 self.title
    var link: String = "" // 这个页面需要访问的链接，据此来获取内容
    
    private let webview = UIWebView()
    private var tableData = [CellDataModel]()
    private func getKey() -> String { return self.titleText }
    
    
    
    // MARK: - Main
    override func viewWillAppear(_ animated: Bool) {
        // 加载本地数据
        tableData = self.getContentFromDevice(key: self.getKey())
        tableView.reloadData()
        // 加载网页
        requestContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleText
        webview.delegate = self
        // 导航栏加入刷新按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(requestContent))
    }
    
    func requestContent() {
        guard let url = URL(string: link) else { return }
        webview.loadRequest(URLRequest(url: url))
    }
    
    // MARK: - Web View
    func webViewDidStartLoad(_ webView: UIWebView) {
        // title 提示
        title = "内容刷新中"
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // title 提示
        title = titleText
        // 从 webview 抓取内容
        let titles = webview.getArticleTitles()
        let links = webview.getArticleLinks()
        // 处理抓取到的内容
        tableData.setByData(titles: titles, links: links)
        // 根据内容刷新页面
        self.reloadbyComparingData(tableview: tableView,
            oldData: self.getContentFromDevice(key: self.getKey()),
            newData: tableData, key: self.getKey())
    }
    
    
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        cell.textLabel?.text = tableData[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // push
        guard let url = URL(string: tableData[(indexPath as NSIndexPath).row].link) else { return }
        
        if #available(iOS 9.0, *) {
            let safari = SFSafariViewController(url: url)
            self.present(safari, animated: true, completion: nil)
        } else {
            let safari = FakeSafariViewController(URL: url)
            guard let navi = self.navigationController else { return }
            navi.pushViewController(safari, animated: true)
        }
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
