//
//  WKWebViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/29.
//  Copyright © 2016年 com. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 16.0;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    configuration.preferences = preferences;
    
    [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Share"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Location"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Shake"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Color"];
    [configuration.userContentController addScriptMessageHandler:self name:@"Pay"];
    [configuration.userContentController addScriptMessageHandler:self name:@"GoBack"];
    [configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    self.wkWebView = wkWebView;
    [self.view addSubview:wkWebView];
    
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"MessageHandler" withExtension:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    [wkWebView loadRequest:request];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"method name : %@, message body : %@", message.name, message.body);
    if ([message.name isEqualToString:@"Share"]) {
        [self share:message.body];
    }
}

- (void)share:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)params;
        NSString *title = dictionary[@"title"];
        NSString *content = dictionary[@"content"];
        NSString *url = dictionary[@"url"];
        NSString *script = [NSString stringWithFormat:@"shareResult('%@', '%@', '%@')", title, content, url];
        [self shareResultToJS:script];
    }
}

- (void)shareResultToJS:(NSString *)script {
    [self.wkWebView evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result is %@, error is %@", result, error.localizedDescription);
    }];
}

#pragma mark - WKNavigationDelegate

/// 使用WKNavigationDelegate中的代理方法，拦截自定义的URL来实现JS调用OC方法。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = URL.scheme;
    if ([scheme isEqualToString:@"action"]) {
        [self handleURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/// JS call Native
- (void)handleURL:(NSURL *)URL {
    
}

///Native call JS
- (void)nativeCallJS {
    NSString *script = @"";
    [self.wkWebView evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result is %@, error is %@", result, error);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0)) {
    return YES;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0)) {
    return self;
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0)) {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
