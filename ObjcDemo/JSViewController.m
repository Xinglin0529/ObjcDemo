//
//  JSViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/29.
//  Copyright © 2016年 com. All rights reserved.
//

#import "JSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebViewController.h"

@protocol LDJSExport <JSExport>

JSExportAs(jsCallNative, - (void)jsCallNative:(NSString *)paramter);

@end

@interface JSManage : NSObject <LDJSExport>

- (instancetype)initWith:(UIViewController *)controller;
@property (nonatomic, strong) UIViewController *current;
@end

@implementation JSManage

- (instancetype)initWith:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.current = controller;
    }
    return self;
}

- (void)jsCallNative:(NSString *)paramter {
    JSValue *currentThis = [JSContext currentThis];
    JSValue *currentCallee = [JSContext currentCallee];
    NSArray *currentParams = [JSContext currentArguments];
    NSLog(@"currentThis: %@", currentThis);
    NSLog(@"currentCallee: %@", currentCallee);
    NSLog(@"currentParams: %@", currentParams);
}

@end

@interface JSViewController () <UIWebViewDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) JSManage *jsManage;
@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = self.view.bounds;
    web.delegate = self;
    [self.view addSubview:web];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"JavaScriptCore" ofType:@"html"];
    NSString *htmlStr=  [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [web loadHTMLString:htmlStr baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"callJS" style:UIBarButtonItemStylePlain target:self action:@selector(nativeCallJS)];
}

- (void)nativeCallJS {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakself = self;
    self.jsContext[@"scan"] = ^{
        NSLog(@"scan.......");
        [weakself.navigationController pushViewController:[WKWebViewController new] animated:YES];
    };
    
    self.jsContext[@"share"] = ^{
        NSArray *arguments = [JSContext currentArguments];
        NSLog(@"arguments is %@", arguments);
        NSString *title = [arguments[0] toString];
        NSString *content = [arguments[1] toString];
        NSString *url = [arguments[2] toString];
        NSString *script = [NSString stringWithFormat:@"shareResult('%@', '%@', '%@')", title, content, url];
        [[JSContext currentContext] evaluateScript:script];
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error.localizedDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
