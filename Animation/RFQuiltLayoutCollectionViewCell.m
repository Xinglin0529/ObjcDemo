//
//  RFQuiltLayoutCollectionViewCell.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/23.
//  Copyright © 2017年 com. All rights reserved.
//

#import "RFQuiltLayoutCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "SecondViewController.h"

@interface RFQuiltLayoutCollectionViewCell()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RFQuiltLayoutCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.label = label;
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)configCellWitgModel:(RFViewModel *)model {
    self.label.text = [NSString stringWithFormat:@"%@:r-%ldc-%ld", model.title, (long)model.row, (long)model.colomn];
}

@end
