//
//  CircleViewController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleAnimation.h"

@interface CircleViewController ()

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Circle" style:UIBarButtonItemStylePlain target:self action:@selector(pushAction)];
    CircleAnimation *animationView = [[CircleAnimation alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    //    animationView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:animationView];
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
