//
//  MainTableVC.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

class MainTableVC: UITableViewController, UIWebViewDelegate {
    
    private let webview = UIWebView()
    private var tableData = [CellDataModel]()
    private let key = "Main"
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        
        // 加载本地数据
        tableData = self.getContentFromDevice(key:key)
        tableView.reloadData()
        
        // 加载网页
        requestContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftGG"
        webview.delegate = self
        
        // 导航栏加入刷新按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(requestContent))
        
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
    
    @objc private func requestContent() {
        guard let url = URL(string: "http://swift.gg/archives/") else { return }
        webview.loadRequest(URLRequest(url: url))
    }
    
    
    // MARK: - Web View
    func webViewDidStartLoad(_ webView: UIWebView) {
        // title 提示
        title = "内容刷新中"
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // title 提示
        self.title = "SwiftGG"
        // 从 webview 抓取内容
        let titles = webview.getArchiveTitles()
        let links = webview.getArchiveLinks()
        // 处理抓取到的内容
        tableData.setByData(titles: titles, links: links)
        // 根据内容刷新页面
        self.reloadbyComparingData(tableview: tableView,
            oldData: self.getContentFromDevice(key: key),
            newData: tableData, key: key)
    }

    
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = tableData[(indexPath as NSIndexPath).row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        pushArticlesVC(
            title: tableData[(indexPath as NSIndexPath).row].title,
            link: tableData[(indexPath as NSIndexPath).row].link)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - 自动 Push
    private func pushArticlesVC(title:String, link:String) {
        // get vc
        guard let navi = self.navigationController else { return }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "articlesTableVC") as? ArticlesTableVC
            else { return }
        // set value
        vc.titleText = title
        vc.link = link
        // push
        navi.pushViewController(vc, animated: true)
    }
    
}
