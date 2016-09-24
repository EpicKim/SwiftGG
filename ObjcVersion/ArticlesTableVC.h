//
//  ArticlesTableVC.h
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticlesTableVC : UITableViewController <UIWebViewDelegate>

@property(nonatomic, strong, readwrite) NSString *titleText; // 这个页面的 title 应有的值，名称区别于 self.title
@property(nonatomic, strong, readwrite) NSString *link; // 这个页面需要访问的链接，据此来获取内容

@end
