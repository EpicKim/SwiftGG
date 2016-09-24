//
//  UITableViewController+DataHandle.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "UITableViewController+DataHandle.h"

@implementation UITableViewController (DataHandle)

// 对比新旧数据，决定是否刷新页面
-(void)reloadbyComparingDataWithTableView:(UITableView*)tableView oldData:(NSArray*)oldData newData:(NSArray*)newData key:(NSString*)key{
    
    NSSet *oldSet = [NSSet setWithArray:oldData];
    NSSet *newSet = [NSSet setWithArray:newData];
    if (![oldSet isEqualToSet:newSet]) {
        // 发现数据有更新
        [tableView reloadData];
        [self setContentToDeviceWithContent:newData key:key];
    }else {
        // Do Nothing
        // 没有新数据，就不消耗资源，不刷新页面
    }
}

// 存储数据到本地
-(void)setContentToDeviceWithContent:(NSArray*)content key:(NSString*)key{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:content];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

// 从本地获取数据
-(NSArray*)getContentFromDeviceWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults dictionaryRepresentation].allKeys containsObject: key]) {
        NSData *encodedObject = [defaults objectForKey:key];
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }else {
        return [[NSArray alloc] init];
    }
}

@end
