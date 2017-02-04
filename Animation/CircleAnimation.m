//
//  CircleAnimation.m
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import "CircleAnimation.h"

@interface CircleAnimation() <CAAnimationDelegate>

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CABasicAnimation *strokeAnimation;
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation CircleAnimation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width / 2];
        _bezierPath = [UIBezierPath bezierPath];
        [_bezierPath moveToPoint:CGPointMake(20, 40)];
        [_bezierPath addLineToPoint:CGPointMake(40, 80)];
        [_bezierPath addLineToPoint:CGPointMake(80, 60)];
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.lineWidth = 5;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.path = _bezierPath.CGPath;
        [self.layer addSublayer:_shapeLayer];
        [_shapeLayer addAnimation:self.strokeAnimation forKey:@"animationStroke"];
    }
    return self;
}

- (void)startRotationAnimation {
    [self.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (CABasicAnimation *)rotationAnimation {
    if (!_rotationAnimation) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        _rotationAnimation.duration = 1;
        _rotationAnimation.repeatCount = 2;
        _rotationAnimation.removedOnCompletion = YES;
        _rotationAnimation.delegate = self;
    }
    return _rotationAnimation;
}

- (CABasicAnimation *)strokeAnimation {
    if (!_strokeAnimation) {
        _strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeAnimation.fromValue = [NSNumber numberWithFloat:0];
        _strokeAnimation.toValue = [NSNumber numberWithFloat:1];
        _strokeAnimation.duration = 1;
        _strokeAnimation.removedOnCompletion = NO;
        _strokeAnimation.fillMode = kCAFillModeForwards;
        _strokeAnimation.repeatCount = 1;
        _strokeAnimation.beginTime = 0;
        _strokeAnimation.delegate = self;
    }
    return _strokeAnimation;
}

@end
