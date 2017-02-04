//
//  ReactiveViewController.h
//  ObjcDemo
//
//  Created by Dongdong on 17/2/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ReactiveViewController : UIViewController

@property (nonatomic, strong) RACSubject *subjectDelegate;

@end
