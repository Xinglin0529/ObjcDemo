//
//  NSString+invocation.m
//  ObjcDemo
//
//  Created by Dongdong on 16/12/28.
//  Copyright © 2016年 com. All rights reserved.
//

#import "NSString+invocation.h"
#import "NextViewController.h"

@implementation NSString (invocation)

/// 1 第一个接盘侠代表动态方法解析阶段，对应的具体方法是+(BOOL)resolveInstanceMethod:(SEL)sel 和+(BOOL)resolveClassMethod:(SEL)sel，当方法是实例方法时调用前者，当方法为类方法时，调用后者。这个方法设计的目的是为了给类利用 class_addMethod 添加方法的机会。
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    return [super resolveClassMethod:sel];
}

/// 2第二个阶段是备援接收者阶段，对象的具体方法是-(id)forwardingTargetForSelector:(SEL)aSelector ，此时，运行时询问能否把消息转给其他接收者处理，也就是此时系统给了个将这个 SEL 转给其他对象的机会。我们继续来研究下参数和返回值，参数和一号接盘侠一样，都是 selector，返回值是 id 类型，当返回 非self\非nil 时，消息被转给新对象执行。
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NextViewController *nex = [[NextViewController alloc] init];
    if ([nex respondsToSelector:aSelector]) {
        return nex;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super methodSignatureForSelector:aSelector];
}

/// 3第三个阶段是完整消息转发阶段，对应方法-(void)forwardInvocation:(NSInvocation *)anInvocation，这是消息转发流程的最后一个环节。参数 anInvocation 中包含未处理消息的各种信息（selector\target\参数...）。在这个方法中，可以把 anInvocation 转发给多个对象，与二号接盘侠不同，二号只能转给一个对象。
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
}

- (NSString *)addSomething:(NSString *)sth
{
    NSLog(@"NSString sth is: %@", sth);
    return sth;
}

@end
