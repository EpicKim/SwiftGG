//
//  MainTableVC.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "MainTableVC.h"
#import "UITableViewController+DataHandle.h"
#import "ArticlesTableVC.h"
#import "CellDataModel.h"
#import "UIWebView+JS.h"
#import "NSMutableArray+DataHandle.h"

@interface MainTableVC ()

@property(nonatomic, strong) UIWebView *webview;
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSString *key;

@end

@implementation MainTableVC

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview = [[UIWebView alloc] init];
    self.tableData = [[NSMutableArray alloc] init];
    self.key = @"Main";
    
    self.title = @"SwiftGG";
    self.webview.delegate = self;
    
    // 导航栏加入刷新按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestContent)];
    
    // 加载本地数据
    self.tableData = [[NSMutableArray alloc] initWithArray: [self getContentFromDeviceWithKey:self.key]];
    [self.tableView reloadData];
    
    // 加载网页
    [self requestContent];
}

- (void)requestContent {
    NSURL* url = [[NSURL alloc] initWithString:@"http://swift.gg/archives/"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self.webview loadRequest:request];
}


#pragma mark - Web View
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // title 提示
    self.title = @"内容刷新中";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // title 提示
    self.title = @"SwiftGG";
    // 从 webview 抓取内容
    NSArray *titles = [webView getArchiveTitles];
    NSArray *links = [webView getArchiveLinks];
    // 处理抓取到的内容
    [self.tableData setByDataWithTitles:titles links:links];
    // 根据内容刷新页面
    [self reloadbyComparingDataWithTableView:self.tableView
                                     oldData:[self getContentFromDeviceWithKey:_key]
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = ((CellDataModel*)self.tableData[indexPath.row]).title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect
    [self pushArticlesVCWithTitle:((CellDataModel*)self.tableData[indexPath.row]).title
                             link:((CellDataModel*)self.tableData[indexPath.row]).link];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 自动 Push
- (void)pushArticlesVCWithTitle:(NSString*)title link:(NSString*)link {
    // get vc
    UINavigationController *navi = self.navigationController;
    ArticlesTableVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"articlesTableVC"];
    // set value
    vc.titleText = title;
    vc.link = link;
    // push
    [navi pushViewController:vc animated:YES];
}


@end
