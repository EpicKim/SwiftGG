//
//  TableVCExtension.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/11.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    // 对比新旧数据，决定是否刷新页面
    func dealUI_byComparingData(
        tableview:UITableView,
        oldData:[CellDataModel], newData:[CellDataModel], key:String) {
            
            if oldData != newData {
                // 发现数据有更新
                tableview.reloadData()
                self.setContentToDevice(newData, key: key)
            }else {
                // Do Nothing
                // 没有新数据，就不消耗资源，不刷新页面
            }
    }
    
    // 存储数据到本地
    func setContentToDevice (content:[CellDataModel], key:String) {
        
        let pathPrefix = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask, true).first
        let pathSuffix = "/" + key + ".plist"
        if let path = pathPrefix?.stringByAppendingString(pathSuffix) {
            NSKeyedArchiver.archiveRootObject(content, toFile: path)
        }
    }
    
    // 从本地获取数据
    func getContentFromDevice (key key:String) -> [CellDataModel] {
        
        let pathPrefix = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.AllDomainsMask, true).first
        let pathSuffix = "/" + key + ".plist"
        
        guard let path = pathPrefix?.stringByAppendingString(pathSuffix)
            else { return [] }
        guard let content = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [CellDataModel]
            else { return [] }
        
        return content
    }
}
