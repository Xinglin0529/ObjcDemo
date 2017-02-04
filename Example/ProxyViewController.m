//
//  ProxyViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/3.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ProxyViewController.h"
#import "TestProxy.h"

@interface ProxyViewController ()

@end

@implementation ProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TestProxy storeProxy] purchaseBookForTitle:@"swift"];
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
