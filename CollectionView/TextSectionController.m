//
//  TextSectionController.m
//  ObjcDemo
//
//  Created by Dongdong on 17/2/10.
//  Copyright © 2017年 com. All rights reserved.
//

#import "TextSectionController.h"
#import <Masonry/Masonry.h>

@interface TextCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
- (void)updateGridCellWithText:(NSString *)text;

@end

@implementation TextCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)updateGridCellWithText:(NSString *)text {
    self.textLabel.text = text;
    self.contentView.backgroundColor = [UIColor yellowColor];
}

@end

@interface TextSectionController ()

@property (nonatomic, copy) NSString *text;

@end

@implementation TextSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake([self.collectionContext containerSize].width, 40);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    TextCell *cell = [self.collectionContext dequeueReusableCellOfClass:[TextCell class] forSectionController:self atIndex:index];
    [cell updateGridCellWithText:self.text];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    self.text = object;
    [self.collectionContext reloadSectionController:self];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}

@end
