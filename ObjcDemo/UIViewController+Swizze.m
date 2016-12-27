//
//  UIViewController+Swizze.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/27.
//  Copyright © 2016年 com. All rights reserved.
//

#import "UIViewController+Swizze.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizze)

static BOOL isSwizzed;
static NSString *logTag = @"";

static void swizeeMethod(Class cls, SEL originalSel, SEL swizzeSel) {
    Method original = class_getInstanceMethod(cls, originalSel);
    Method swizze = class_getInstanceMethod(cls, swizzeSel);
    IMP originIMP = class_getMethodImplementation(cls, originalSel);
    IMP swizzeIMP = class_getMethodImplementation(cls, swizzeSel);
    BOOL didAddMethod = class_addMethod(cls, originalSel, swizzeIMP, method_getTypeEncoding(swizze));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzeSel, originIMP, method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, swizze);
    }
}


- (void)logWithLevel:(NSInteger)level
{
    NSString *paddingItems = @"";
    for (NSUInteger i = 0; i <= level; i++) {
        paddingItems = [paddingItems stringByAppendingFormat:@"--"];
    }
    NSLog(@"%@%@-> %@", logTag, paddingItems, [[self class] description]);
}

- (void)printPath {
    if ([self parentViewController] == nil) {
        [self logWithLevel:0];
    } else if ([[self parentViewController] isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.parentViewController;
        NSInteger interger = [nav.viewControllers indexOfObject:self];
        [self logWithLevel:interger];
    } else if ([[self parentViewController] isMemberOfClass:[UITabBarController class]]) {
        [self logWithLevel:1];
    }
}

- (void)swizzeViewDidAppear:(BOOL)animated {
    [self printPath];
    [self swizzeViewDidAppear: animated];
}

+ (void)load
{
    isSwizzed = NO;
}

+ (void)swizze
{
    if (isSwizzed) {
        return;
    }
    swizeeMethod([self class], @selector(viewDidAppear:), @selector(swizzeViewDidAppear:));
    isSwizzed = YES;
}

+ (void)swizeeItWithTag:(NSString *)tag
{
    logTag = tag;
    [self swizze];
}

+ (void)unSwizze
{
    if (!isSwizzed) {
        return;
    }
    isSwizzed = NO;
    swizeeMethod([self class], @selector(viewDidAppear:), @selector(swizzeViewDidAppear:));
}

@end
