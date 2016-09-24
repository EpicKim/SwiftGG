//
//  ArticlesTableVC.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "ArticlesTableVC.h"
#import "UITableViewController+DataHandle.h"
#import "CellDataModel.h"
#import "UIWebView+JS.h"
#import "NSMutableArray+DataHandle.h"
#import <SafariServices/SafariServices.h>
#import "FakeSafariViewController.h"

@interface ArticlesTableVC ()

@property(nonatomic, strong) UIWebView *webview;
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSString *key;

@end

@implementation ArticlesTableVC

- (NSString*) key {
    return self.titleText;
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 加载本地数据
    self.tableData = [[NSMutableArray alloc] initWithArray:[self getContentFromDeviceWithKey:self.key]];
    [self.tableView reloadData];
    // 加载网页
    [self requestContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webview = [[UIWebView alloc] init];
    self.tableData = [[NSMutableArray alloc] init];
    
    self.title = self.titleText;
    self.webview.delegate = self;
    // 导航栏加入刷新按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestContent)];
}

- (void)requestContent {
    NSURL *url = [[NSURL alloc] initWithString: self.link];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webview loadRequest:request];
}


#pragma mark - Web View
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // title 提示
    self.title = @"内容刷新中";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // title 提示
    self.title = self.titleText;
    // 从 webview 抓取内容
    NSArray *titles = [self.webview getArticleTitles];
    NSArray *links = [self.webview getArticleLinks];
    // 处理抓取到的内容
    [self.tableData setByDataWithTitles:titles links:links];
    // 根据内容刷新页面
    [self reloadbyComparingDataWithTableView: self.tableView
                                     oldData:[self getContentFromDeviceWithKey:self.key]
                                     newData:self.tableData
                                         key:self.key];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleCell" forIndexPath:indexPath];
    cell.textLabel.text = ((CellDataModel*) self.tableData[indexPath.row]).title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // push
    NSString *urlString = ((CellDataModel*) self.tableData[indexPath.row]).link;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    if ([SFSafariViewController class]) {
        SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safari animated:YES completion:nil];
    } else {
        FakeSafariViewController *safari = [[FakeSafariViewController alloc] initWithUrl:url];
        [self.navigationController pushViewController:safari animated:YES];
    }
    
    // deselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
