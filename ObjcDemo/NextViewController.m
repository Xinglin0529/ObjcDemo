//
//  NextViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/27.
//  Copyright © 2016年 com. All rights reserved.
//

#import "NextViewController.h"
#import <Masonry/Masonry.h>
#import "JSViewController.h"

@interface NextViewController ()

@property (nonatomic, strong) NSInvocation *invocation;
@property (nonatomic, strong) id returnValue;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"action" style:UIBarButtonItemStylePlain target:self action:@selector(gotoJSViewController)];
    
    NSArray *titles = @[@"改变参数", @"改变selector", @"改变target"];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(100 + i * 40);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
    }
    
    [self createInvocation];
}

- (void)gotoJSViewController {
    [self.navigationController pushViewController:[JSViewController new] animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self changeArgument];
            break;
        case 1:
            [self changeSelector];
            break;
        case 2:
            [self changeTarget];
            break;
        default:
            break;
    }
}

- (void)changeArgument {
    NSString *name2 = @"ccccc";
    [self.invocation setArgument:&name2 atIndex:3];
    [self.invocation invoke];
    [self.invocation getReturnValue:&_returnValue];
    NSLog(@"returnValue is %@",_returnValue);
}

- (void)changeSelector {
    self.invocation.selector = @selector(addSomething:);
    [self.invocation invoke];
}

- (void)changeTarget {
    NSString *target = [[NSString alloc] init];
    self.invocation.target = target;
    [self.invocation invoke];
    [self.invocation getReturnValue:&_returnValue];
    NSLog(@"returnvalue is: %@", _returnValue);
}

- (void)createInvocation {
    NSMethodSignature *signature = [NextViewController instanceMethodSignatureForSelector:@selector(doSomething:name:)];
    self.invocation = [NSInvocation invocationWithMethodSignature:signature];
    NSString *name1 = @"aaaa";
    NSString *name2 = @"bbbb";
    /// 传入的参数的标题，必须从2，3，4，开始计算，因为第一个argumengt第一个数据和第二个数据被处理者self和即将被调用的方法引用
    [self.invocation setArgument:&name1 atIndex:2];
    [self.invocation setArgument:&name2 atIndex:3];
    self.invocation.target = self;
    self.invocation.selector = @selector(doSomething:name:);
    self.returnValue = nil;
}

- (NSString *)doSomething:(NSString *)sth name:(NSString *)name {
    NSLog(@"sth: %@, name: %@", sth, name);
    return [sth stringByAppendingString:name];
}

- (NSString *)addSomething:(NSString *)sth {
    NSLog(@"sth: %@", sth);
    return sth;
}

- (void)test:(NSString *)name,... {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
