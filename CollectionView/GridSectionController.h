//
//  GridSectionController.h
//  ObjcDemo
//
//  Created by Dongdong on 17/2/10.
//  Copyright © 2017年 com. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@interface GridModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger count;

@end

@interface GridSectionController : IGListSectionController <IGListSectionType>

@end
