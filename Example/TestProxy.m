//
//  TestProxy.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/3.
//  Copyright © 2017年 com. All rights reserved.
//

#import "TestProxy.h"
#import <objc/runtime.h>

@interface TestProxy ()

@property (nonatomic, strong) NSMutableDictionary *methodsMap;
@property (nonatomic, strong) BookStore *bookStore;
@property (nonatomic, strong) ClothesStore *clothesStore;

@end

@implementation TestProxy

+ (instancetype)storeProxy {
    return [[TestProxy alloc] init];
}

- (instancetype)init {
    _methodsMap = [NSMutableDictionary dictionary];
    _bookStore = [BookStore new];
    _clothesStore = [ClothesStore new];
    [self _registerMethodsWithTarget:_bookStore];
    [self _registerMethodsWithTarget:_clothesStore];
    return self;
}

#pragma mark - private method
- (void)_registerMethodsWithTarget:(id )target
{
    unsigned int numberOfMethods = 0;
    //获取target方法列表
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    for (int i = 0; i < numberOfMethods; i ++)
    {
        //获取方法名并存入字典
        Method temp_method = method_list[i];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    free(method_list);
}

#pragma mark - NSProxy override methods
- (void)forwardInvocation:(NSInvocation *)invocation
{
    //获取当前选择子
    SEL sel = invocation.selector;
    //获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    //在字典中查找对应的target
    id target = _methodsMap[methodName];
    //检查target
    if (target && [target respondsToSelector:sel])
    {
        [invocation invokeWithTarget:target];
    }
    else
    {
        [super forwardInvocation:invocation];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    //获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    //在字典中查找对应的target
    id target = _methodsMap[methodName];
    //检查target
    if (target && [target respondsToSelector:sel])
    {
        return [target methodSignatureForSelector:sel];
    }
    else
    {
        return [super methodSignatureForSelector:sel];
    }
}

@end
