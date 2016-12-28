//
//  NSNull+Nullsafe.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/27.
//  Copyright © 2016年 com. All rights reserved.
//

#import "NSNull+Nullsafe.h"
#import <objc/runtime.h>

@implementation NSNull (Nullsafe)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    @synchronized ([self class]) {
        NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
        if (!signature) {
            static NSMutableSet *classList = nil;
            static NSMutableDictionary *signatureCache = nil;
            
            if (signatureCache == nil) {
                classList = [[NSMutableSet alloc] init];
                signatureCache = [[NSMutableDictionary alloc] init];
                
                int numberClasses = objc_getClassList(NULL, 0);
                Class *classes = (Class *)malloc(sizeof(Class) * (unsigned long)numberClasses);
                numberClasses = objc_getClassList(classes, numberClasses);
                
                NSMutableSet *excluded = [[NSMutableSet alloc] init];
                for (NSInteger i = 0; i < numberClasses; i++) {
                    Class someClass = classes[i];
                    Class superClass = class_getSuperclass(someClass);
                    while (superClass) {
                        if (superClass == [NSObject class]) {
                            [classList addObject:someClass];
                            break;
                        }
                        [excluded addObject:superClass];
                        superClass = class_getSuperclass(superClass);
                    }
                }
                
                for (Class someClass in excluded) {
                    [classList removeObject:someClass];
                }
                
                free(classes);
            }
            //
            NSString *selectorString = NSStringFromSelector(aSelector);
            signature = signatureCache[selectorString];
            if (!signature) {
                for (Class someClass in classList) {
                    if ([someClass instancesRespondToSelector:aSelector]) {
                        signature = [someClass instanceMethodSignatureForSelector:aSelector];
                        break;
                    }
                }
                signatureCache[selectorString] = signature ?: [NSNull null];
            } else if ([signature isKindOfClass:[NSNull class]]) {
                signature = nil;
            }
        }
        return signature;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:nil];
}

@end
