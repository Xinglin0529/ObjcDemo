//
//  SecondViewController.h
//  ObjcDemo
//
//  Created by Dongdong on 17/1/20.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFViewModel : NSObject

@property (nonatomic, assign) CGFloat row;
@property (nonatomic, assign) CGFloat colomn;
@property (nonatomic, copy) NSString *title;

@end

@interface SecondViewController : UIViewController

@end
