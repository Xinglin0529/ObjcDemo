//
//  SecondViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SecondViewController.h"
#import <objc/runtime.h>
#import "LoginViewController.h"

@interface SecondViewController ()

@property (nonatomic, copy) NSString *clsName;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Second" style:UIBarButtonItemStylePlain target:self action:@selector(objcTest)];
}

- (void)objcTest {
    Class cls = objc_allocateClassPair([NSObject class], "Person", 0);
    class_addIvar(cls, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(cls, "_age", sizeof(NSInteger), log2(sizeof(NSInteger)), @encode(NSInteger));
//    objc_registerClassPair(cls);
    
    id obj = [[cls alloc] init];
    [obj setValue:@"xiaoming" forKey:@"name"];
    Ivar ageIvar = class_getInstanceVariable(cls, "_age");
    object_setIvar(obj, ageIvar, @(18));
    NSLog(@"name == %@ age === %ld", [obj objectForKey:@"name"], [[obj objectForKey:@"age"] integerValue]);
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"ivar name == %@", @(ivar_getName(ivar)));
    }
    
    [[LoginViewController new] callLoginPage];
}

- (void)pushAction {
    
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
