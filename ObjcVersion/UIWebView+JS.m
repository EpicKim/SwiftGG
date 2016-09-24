//
//  UIWebView+JS.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "UIWebView+JS.h"


#pragma mark - 用于使用 JS 抓取网页
@implementation UIWebView (JS)

// 抓取归档链接
-(NSArray*)getArchiveLinks{
    [self stringByEvaluatingJavaScriptFromString: @"var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveLinks() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *linkSet = [self stringByEvaluatingJavaScriptFromString:@"getArchiveLinks();"];
    NSArray *linkArr = [linkSet componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *filteredLinkArr = [linkArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* object, NSDictionary *bindings) {
        return [object hasPrefix:@"http://"];
    }]];
    return filteredLinkArr;
}

// 抓取归档标题
-(NSArray*)getArchiveTitles{
    [self stringByEvaluatingJavaScriptFromString: @"var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArchiveTitles() {var div = document.getElementsByClassName('archive-list')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].text + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *titleSet = [self stringByEvaluatingJavaScriptFromString:@"getArchiveTitles();"];
    NSArray *titleArr = [titleSet componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"+"]];
    NSArray *filteredTitleArr = [titleArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* object, NSDictionary *bindings) {
        return [object hasPrefix:@"20"];
    }]];
    return filteredTitleArr;
}

// 抓取各个归档内文章链接
-(NSArray*)getArticleLinks{
    [self stringByEvaluatingJavaScriptFromString: @"var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleLinks() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].href + ' '};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *linkSet = [self stringByEvaluatingJavaScriptFromString:@"getArticleLinks();"];
    NSArray *linkArr = [linkSet componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *filteredLinkArr = [linkArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* object, NSDictionary *bindings) {
        return [object hasPrefix:@"http://"];
    }]];
    return filteredLinkArr;
}

// 抓取各个归档内文章链接
-(NSArray*)getArticleTitles{
    [self stringByEvaluatingJavaScriptFromString: @"var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getArticleTitles() {var div = document.getElementsByClassName('archive-part clearfix')[0];var atags = div.getElementsByTagName('a');var txt = '';for (x in atags){txt=txt + atags[x].title + '+'};return txt;}\";document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *titleSet = [self stringByEvaluatingJavaScriptFromString:@"getArticleTitles();"];
    NSArray *titleArr = [titleSet componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"+"]];
    NSArray *filteredTitleArr = [titleArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* object, NSDictionary *bindings) {
        return (![object isEqualToString:@"undefined"] && ![object isEqualToString:@""]);
    }]];
    return filteredTitleArr;
}

@end



#pragma mark - 用于设定 View 的大小为屏幕大小
@implementation UIWebView (Expand)

-(void)expandToFullView {
    self.frame = [UIScreen mainScreen].bounds;
}

@end


@implementation WKWebView (Expand)

-(void)expandToFullView {
    self.frame = [UIScreen mainScreen].bounds;
}

@end
