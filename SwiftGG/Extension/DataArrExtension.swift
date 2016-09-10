//
//  DataArrExtension.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/13.
//  Copyright © 2016年 徐开源. All rights reserved.
//

extension Array where Element:CellDataModel {
    
    mutating func setByData(titles:[String], links:[String]) {
        
        // 保证链接与标题数量一致
        if titles.count == links.count {
            // 清空
            self.removeAll()
            // 填值
            for i in 0 ..< titles.count {
                if let cellDataObj = CellDataModel(
                    title: titles[i],
                    link: links[i]) as? Element {
                        
                        self.append(cellDataObj)
                }
            }
        }
    }
}
