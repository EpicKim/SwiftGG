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
    func reloadbyComparingData(tableview:UITableView, oldData:[CellDataModel], newData:[CellDataModel], key:String) {
            
            if oldData != newData {
                // 发现数据有更新
                tableview.reloadData()
                self.setContentToDevice(content: newData, key: key)
            }else {
                // Do Nothing
                // 没有新数据，就不消耗资源，不刷新页面
            }
    }
    
    // 存储数据到本地
    func setContentToDevice(content:[CellDataModel], key:String) {
        guard let pathPrefix = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.allDomainsMask, true).first
            else { return }
        let path = pathPrefix + "/" + key + ".plist"
        NSKeyedArchiver.archiveRootObject(content, toFile: path)
    }
    
    // 从本地获取数据
    func getContentFromDevice(key:String) -> [CellDataModel] {
        guard let pathPrefix = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.allDomainsMask, true).first
            else { return [] }
        let path = pathPrefix + "/" + key + ".plist"
        guard let content = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [CellDataModel]
            else { return [] }
        return content
    }
}
