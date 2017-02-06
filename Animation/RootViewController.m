//
//  RootViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "RootViewController.h"
#import "FisrtViewController.h"
#import "ProxyViewController.h"
#import "ReactiveViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Root" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"输入...";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.enabled = NO;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    [self.view addSubview:button];
    
    UILabel *content = [UILabel new];
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textField);
        make.top.equalTo(button.mas_bottom).offset(10);
    }];
    
    RAC(button, enabled) = [RACSignal combineLatest:@[textField.rac_textSignal] reduce:^id(NSString *text){
        return @(text.length > 0);
    }];
    
    RAC(content, text) = textField.rac_textSignal;
    
    [[RACObserve(content, text) filter:^BOOL(NSString *value) {
        return [value hasPrefix:@"Q"];
    }] subscribeNext:^(id x) {
        NSLog(@"Observer value: %@", x);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(44);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(textField);
        make.top.equalTo(textField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    RACSubject *sub = [self subject];
    [sub subscribeNext:^(id x) {
        content.text = x;
    }];
}

- (RACSubject *)subject {
    RACSubject *subject = [RACSubject subject];
    [[[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] take:1] map:^id(NSString *value) {
        NSString *s = @"upperCaseString";
        [subject sendNext:s];
        [subject sendCompleted];
        return nil;
    }] subscribeNext:^(id x) {}];
    return subject;
}

- (void)pushAction {
    ReactiveViewController *react = [ReactiveViewController new];
    react.subjectDelegate = [RACSubject subject];
    [react.subjectDelegate subscribeNext:^(id x) {
        NSLog(@"x------------- %@", x);
    }];
    [self.navigationController pushViewController:react animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
