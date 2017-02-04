//
//  TestProxy.h
//  ObjcDemo
//
//  Created by Dongdong on 17/2/3.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookStore.h"
#import "ClothesStore.h"
#import <objc/runtime.h>

@interface TestProxy : NSProxy <BookStoreDelegate, ClothesStoreDelegate>

+ (instancetype)storeProxy;

@end
