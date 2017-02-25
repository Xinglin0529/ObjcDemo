//
//  ComputedModel.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/23.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ComputedModel.h"

@implementation ComputedModel

+ (void)load {
    NSLog(@"--------------原始类调用load");
}

+ (void)initialize {
    NSLog(@"--------------原始类调用initialize");
}

///冒泡
- (void)computed1 {
    NSMutableArray *list = @[@3, @4, @8, @1, @7, @2, @5].mutableCopy;
    for (NSInteger i = 0; i < list.count; i++) {
        for (NSInteger j = 0; j < list.count - 1 - i; j++) {
            if ([list[j] integerValue] > [list[j + 1] integerValue]) {
                [list exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    NSLog(@"---------冒泡排序结果: %@", list);
}

//希尔
- (void)computed2 {
    NSMutableArray *list = @[@3, @4, @8, @1, @7, @2, @5].mutableCopy;
    NSInteger gap = list.count / 2.0;
    while (gap >= 1) {
        for (NSInteger i = gap; i < list.count; i++) {
            NSInteger temp = [[list objectAtIndex:i] integerValue];
            NSInteger j = i;
            while (j >= gap && temp < [[list objectAtIndex:j - gap] integerValue]) {
                [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j - gap]];
                j -= gap;
            }
            [list replaceObjectAtIndex:j withObject:@(temp)];
        }
        gap = gap / 2;
    }
    NSLog(@"-----------希尔排序结果: %@", list);
}

//直接插入排序
- (void)computed3 {
    NSMutableArray *list = @[@3, @4, @8, @1, @7, @2, @5].mutableCopy;
    for (NSInteger i = 1; i < list.count; i++) {
        NSInteger j = i;
        NSInteger temp = [[list objectAtIndex:i] integerValue];
        while (j > 0 && temp < [[list objectAtIndex:j - 1] integerValue]) {
            [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j - 1]];
            j--;
        }
        [list replaceObjectAtIndex:j withObject:@(temp)];
    }
    NSLog(@"-----------直接插入排序结果: %@", list);
}

//间接插入排序
- (void)computed4 {
    NSMutableArray *list = @[@3, @4, @8, @1, @7, @2, @5].mutableCopy;
    for (NSInteger i = 1; i < [list count]; i++) {
        NSInteger temp = [[list objectAtIndex:i] integerValue];
        NSInteger left = 0;
        NSInteger right = i - 1;
        while (left <= right) {
            NSInteger middle = (left + right) / 2;
            if (temp < [[list objectAtIndex:middle] integerValue]) {
                right = middle - 1;
            }else{
                left = middle + 1;
            }
        }
        for (NSInteger j = i; j > left; j--) {
            [list replaceObjectAtIndex:j withObject:[list objectAtIndex:j-1]];
        }
        [list replaceObjectAtIndex:left withObject:[NSNumber numberWithInteger:temp]];
    }
    NSLog(@"-----------间接插入排序结果: %@", list);
}

- (void)computed5 {}

@end
