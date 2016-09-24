//
//  NSArray+DataHandle.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "NSMutableArray+DataHandle.h"
#import "CellDataModel.h"

@implementation NSMutableArray (DataHandle)

-(void)setByDataWithTitles:(NSArray*)titles links:(NSArray*)links {
    // 保证链接与标题数量一致
    if (titles.count == links.count) {
        // 清空
        [self removeAllObjects];
        // 填值
        for (int i = 0; i < titles.count; i++) {
            
            NSString* title = titles[i];
            NSString* link = links[i];
            
            if ((title)&&(link)) {
                CellDataModel* cellDataObj = [[CellDataModel alloc] initWithTitle:title link:link];
                [self addObject:cellDataObj];
            }
        }
    }
}

@end
