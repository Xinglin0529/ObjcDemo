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
#import "Reactive.h"
#import "IGCollectionViewController.h"

@interface RootViewController ()

@property (copy) NSMutableArray *dataArray;

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

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
        NSString *regex = @"^[eE][mM][sS][0-9]{12}";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:textField.text];
        if (isValid) {
            NSLog(@"验证通过..............");
        }
    }];
    [self.view addSubview:button];
    
    UILabel *content = [UILabel new];
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:content];
//    [content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(textField);
//        make.top.equalTo(button.mas_bottom).offset(10);
//    }];
    
    RAC(button, enabled) = [RACSignal combineLatest:@[textField.rac_textSignal] reduce:^id(NSString *text){
        return @(text.length > 0);
    }];
    
    RAC(content, text) = textField.rac_textSignal;
    
    [[RACObserve(content, text) filter:^BOOL(NSString *value) {
        return [value hasPrefix:@"Q"];
    }] subscribeNext:^(id x) {
        NSLog(@"Observer value: %@", x);
    }];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    content.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:80]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:100]];
    
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).offset(20);
//        make.trailing.equalTo(self.view).offset(-20);
//        make.top.equalTo(self.view).offset(100);
//        make.height.mas_equalTo(44);
//    }];
//    
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(textField);
//        make.top.equalTo(textField.mas_bottom).offset(10);
//        make.size.mas_equalTo(CGSizeMake(80, 40));
//    }];
    
    RACSubject *sub = [self subject];
    [sub subscribeNext:^(id x) {
        content.text = x;
    }];
    
    [self testValist:@"name1", @"name2", @"name3", nil];
}

- (void)testValist:(NSString *)name,... {
    va_list va;
    va_start(va, name);
    NSString *temp = name;
    while (temp != nil) {
        NSLog(@"tempValue-------------%@", temp);
        temp = va_arg(va, NSString *);
    }
    va_end(va);
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
//    ReactiveViewController *react = [ReactiveViewController new];
//    react.subjectDelegate = [RACSubject subject];
//    [react.subjectDelegate subscribeNext:^(id x) {
//        NSLog(@"x------------- %@", x);
//    }];
    IGCollectionViewController *ig = [IGCollectionViewController new];
    [self.navigationController pushViewController:ig animated:YES];
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
