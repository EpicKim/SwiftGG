//
//  MainTableVC.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/10.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

class MainTableVC: UITableViewController, UIWebViewDelegate {
    
    fileprivate let webview = UIWebView()
    fileprivate var tableData = [CellDataModel]()
    fileprivate let key = "Main"
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SwiftGG"
        webview.delegate = self
        
        // 导航栏加入刷新按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(requestContent))
        
        // peek
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        // 加载本地数据
        tableData = self.getContentFromDevice(key:key)
        tableView.reloadData()
        
        // 加载网页
        requestContent()
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
            title: tableData[indexPath.row].title,
            link: tableData[indexPath.row].link)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - 自动 Push
    fileprivate func pushArticlesVC(title:String, link:String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "articlesTableVC") as? ArticlesTableVC
            else { return }
        vc.titleText = title
        vc.link = link

        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Peek
extension MainTableVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "articlesTableVC") as? ArticlesTableVC else {
            return nil
        }
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }
        vc.titleText = tableData[indexPath.row].title
        vc.link = tableData[indexPath.row].link
        guard let cell = tableView.cellForRow(at: indexPath) else {return nil}
        previewingContext.sourceRect = cell.frame
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
