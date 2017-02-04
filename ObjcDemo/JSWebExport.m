//
//  JSWebExport.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/29.
//  Copyright © 2016年 com. All rights reserved.
//

#import "JSWebExport.h"

@interface JSWebExport()

@property (nonatomic, strong) JSContext *context;

@end

@implementation JSWebExport

- (void)scan {
    NSLog(@"scan");
}

- (void)share:(id)param {
    NSLog(@"param : %@", param);
}

- (void)getLocation {
    NSLog(@"getLocation");
}

- (void)setColor:(id)param {
    NSLog(@"param : %@", param);
}

- (void)payAction:(id)param {
    NSLog(@"param : %@", param);
}

- (void)shake {
    NSLog(@"shake");
}

@end
