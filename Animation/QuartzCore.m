//
//  QuartzCore.m
//  ObjcDemo
//
//  Created by Linbao on 17/2/12.
//  Copyright © 2017年 com. All rights reserved.
//

#import "QuartzCore.h"

@implementation QuartzCore

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 50, 50);
    CGPathAddLineToPoint(path, NULL, 100, 100);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
}


@end
