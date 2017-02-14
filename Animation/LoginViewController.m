//
//  LoginViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "LoginViewController.h"
#import "SecondViewController.h"
#import <objc/runtime.h>
#import "FisrtViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
}

- (void)pushAction {
    SecondViewController *second = [SecondViewController new];
    [self.navigationController pushViewController:second animated:YES];
    [self clearLoginViewController];
}

- (void)clearLoginViewController {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    UIViewController *findvc = nil;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            findvc = vc;
        }
    }
    [viewControllers removeObject:findvc];
    self.navigationController.viewControllers = viewControllers;
}

void otherFunction(id self, SEL cmd) {
    NSLog(@"动态处理callLoginPage方法");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if ([NSStringFromSelector(sel) isEqualToString:@"callLoginPage"]) {
//        class_addMethod([self class], sel, (IMP)otherFunction, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [FisrtViewController new];
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
