//
//  FakeSafariViewController.m
//  SwiftGG
//
//  Created by 徐开源 on 2016/9/23.
//  Copyright © 2016年 kyxu. All rights reserved.
//

#import "FakeSafariViewController.h"
#import <WebKit/WebKit.h>
#import "UIWebView+JS.h"


#pragma mark - UIProgressView Category
@implementation UIProgressView (Frame)

- (void)setFrameByVC:(UIViewController*)vc {
    CGRect barFrame = vc.navigationController.navigationBar.frame;
    CGFloat barHeight = barFrame.size.height + barFrame.origin.y;
    self.frame = CGRectMake(0, barHeight, vc.view.frame.size.width, 2);
}

@end


@interface FakeSafariViewController ()

@property(nonatomic, strong) WKWebView *webview;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) NSString *progressKeyPath;

@end

// 如果用户使用 iOS 8，则没有 SFSafariViewController，用这个 VC 来加载一个网页
@implementation FakeSafariViewController

#pragma mark - Init
-(instancetype)initWithUrl:(NSURL*)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressKeyPath = @"estimatedProgress";
    
    // webView
    self.webview = [[WKWebView alloc] init];
    [self.webview expandToFullView];
    self.webview.frame = self.view.frame;
    [self.webview loadRequest:
     (NSURLRequest*)[[NSURLRequest alloc] initWithURL:self.url]];
    [self.webview addObserver:self
                   forKeyPath:self.progressKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.view addSubview:self.webview];
    
    // progressView
    self.progressView = [[UIProgressView alloc] init];
    [self.progressView setFrameByVC:self];
    [self.webview addSubview:self.progressView];
    
    // 屏幕旋转监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenRotate)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webview removeObserver:self forKeyPath:self.progressKeyPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:self.progressKeyPath]) {
        // 防止进度条突变
        [UIView animateWithDuration:0.5 animations:^{
            [self.progressView setProgress: self.webview.estimatedProgress];
        }];
        // 渐隐
        if (self.webview.estimatedProgress == (double)1.00) {
            [UIView animateWithDuration:1 animations:^{
                self.progressView.alpha = 0;
            }];
        }
    }
}

- (void)screenRotate {
    [self.webview expandToFullView];
    // 保证 progressView 不错位
    [self.progressView setFrameByVC:self];
}

@end
