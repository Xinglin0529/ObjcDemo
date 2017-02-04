//
//  ReactiveViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ReactiveViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation Person
@end

@interface ReactiveViewController ()

@end

@implementation ReactiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testRACSignal1];
    [self testRACSignal2];
}

- (void)testRACSignal1 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        Person *p = [Person new];
        p.name = @"小明";
        p.age = 20;
        [subscriber sendNext:p];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号销毁");
        }];
    }];
    
    [signal subscribeNext:^(Person *x) {
        NSLog(@"收到信号: %@", x.name);
    }];
}

- (void)testRACSignal2 {
    
}

@end
