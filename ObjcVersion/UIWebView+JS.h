//
//  UIWebView+JS.h
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#pragma mark - 用于使用 JS 抓取网页
@interface UIWebView (JS)

-(NSArray*)getArchiveLinks;
-(NSArray*)getArchiveTitles;
-(NSArray*)getArticleLinks;
-(NSArray*)getArticleTitles;

@end


#pragma mark - 用于设定 View 的大小为屏幕大小
@interface UIWebView (Expand)

-(void)expandToFullView;

@end


@interface WKWebView (Expand)

-(void)expandToFullView;

@end
