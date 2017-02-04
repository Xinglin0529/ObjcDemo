//
//  ClothesStore.h
//  ObjcDemo
//
//  Created by Dongdong on 17/2/3.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClothesStoreDelegate <NSObject>

- (void)purchaseForBuyClothesWithName:(NSString *)name;

@end

@interface ClothesStore : NSObject

@end
