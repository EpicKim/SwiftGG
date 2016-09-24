//
//  CellDataModel.h
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDataModel : NSObject

@property(nonatomic, strong, readwrite) NSString *title;
@property(nonatomic, strong, readwrite) NSString *link;

-(instancetype)initWithTitle:(NSString*)title link:(NSString*)link;

@end
