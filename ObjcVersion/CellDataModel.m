//
//  CellDataModel.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "CellDataModel.h"

@implementation CellDataModel

-(instancetype)initWithTitle:(NSString*)title link:(NSString*)link {
    self = [super init];
    if (self) {
        self.title = title;
        self.link = link;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.link forKey:@"link"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.link = [decoder decodeObjectForKey:@"link"];
    }
    return self;
}

@end
