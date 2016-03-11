//
//  CellDataModel.swift
//  SwiftGG
//
//  Created by 徐开源 on 16/3/11.
//  Copyright © 2016年 徐开源. All rights reserved.
//

import UIKit

class CellDataModel: NSObject {
    
    var title:String!
    var link:String!
    
    init(title:String, link:String) {
        self.title = title
        self.link = link
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(link, forKey: "link")
    }
    
    init(coder aDecoder: NSCoder!) {
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.link = aDecoder.decodeObjectForKey("link") as! String
    }
}
