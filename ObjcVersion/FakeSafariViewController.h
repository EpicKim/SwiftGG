//
//  FakeSafariViewController.h
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FakeSafariViewController : UIViewController

@property(nonatomic, strong) NSURL *url;

-(instancetype)initWithUrl:(NSURL*)url;
    
@end
