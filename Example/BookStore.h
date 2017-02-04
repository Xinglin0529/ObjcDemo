//
//  BookStore.h
//  ObjcDemo
//
//  Created by Dongdong on 17/2/3.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookStoreDelegate <NSObject>

- (void)purchaseBookForTitle:(NSString *)title;

@end

@interface BookStore : NSObject

@end
