//
//  UITableViewController+DataHandle.h
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (DataHandle)

-(void)reloadbyComparingDataWithTableView:(UITableView*)tableView oldData:(NSArray*)oldData newData:(NSArray*)newData key:(NSString*)key;
-(void)setContentToDeviceWithContent:(NSArray*)content key:(NSString*)key;
-(NSArray*)getContentFromDeviceWithKey:(NSString*)key;

@end
