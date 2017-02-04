//
//  JSWebExport.h
//  ObjcDemo
//
//  Created by Dongdong on 16/12/29.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSWebExportable <JSExport>

- (void)scan;
- (void)share:(id)param;
- (void)getLocation;
- (void)setColor:(id)param;
- (void)payAction:(id)param;
- (void)shake;

@end

@interface JSWebExport : NSObject <JSWebExportable>

@end
