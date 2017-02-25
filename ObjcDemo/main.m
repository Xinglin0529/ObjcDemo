//
//  main.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/22.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSLog(@"-------执行main函数");
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

__attribute__((constructor)) static void beforeMain() {
    NSLog(@"-------方法执行在main函数之前");
}

//__attribute__((destructor))修饰的函数会在main函数退出或者调用exit()方法之后调用
__attribute__((destructor)) static void afterMainOrExitOver() {
    NSLog(@"-------main函数退出或者调用exit()");
}

//声明
__attribute__((constructor(101))) void before1();

//实现
void before1()
{
    printf("before1\n");
}

static  __attribute__((constructor(102))) void before2()
{
    
    printf("before2\n");
}
static  __attribute__((constructor(102))) void before3()
{
    
    printf("before3\n");
}


